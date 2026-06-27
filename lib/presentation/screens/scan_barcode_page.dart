import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/products/data/products_repository_impl.dart';
import 'package:gastos_personales/layers/products/data/source/network/products_api.dart';
import 'package:gastos_personales/layers/products/domain/usecase/create_product.dart';
import 'package:gastos_personales/presentation/screens/bloc/product_form/product_form_bloc.dart';
import 'package:gastos_personales/presentation/screens/scan_confirm_page.dart';

import 'package:gastos_personales/layers/scanner/domain/usecase/analyze_shelf_label_usecase.dart';
import 'package:gastos_personales/presentation/screens/bloc/scanner/scanner_cubit.dart';
import 'package:gastos_personales/presentation/screens/bloc/scanner/scanner_state.dart';

class ScanBarcodePage extends StatelessWidget {
  const ScanBarcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScannerCubit(
            AnalyzeShelfLabelUseCase(),
          )..requestCameraPermission(),
        ),
        BlocProvider(
          create: (context) => ProductFormBloc(
            CreateProduct(ProductsRepositoryImpl(ProductsApiImpl())),
          ),
        ),
      ],
      child: const _ScanOcrView(),
    );
  }
}

class _ScanOcrView extends StatefulWidget {
  const _ScanOcrView();

  @override
  State<_ScanOcrView> createState() => _ScanOcrViewState();
}

class _ScanOcrViewState extends State<_ScanOcrView> with WidgetsBindingObserver {
  CameraController? _cameraController;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isBusy = false;
  Category? _supermercadoCategory;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    try {
      final categories = await GetCategories(
        CategoriesRepositoryImpl(CategoriesApiImpl()),
      )(type: CategoryType.expense);
      if (categories.isNotEmpty) {
        _supermercadoCategory = categories.cast<Category>().firstWhere(
          (c) => c.name.toLowerCase().contains('supermercado'),
          orElse: () => categories.first,
        );
      }
    } catch (_) {}
  }

  Future<void> _initCamera() async {
    if (_cameraController != null) return;
    
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();
    
    if (!mounted) return;

    setState(() {});

    _cameraController!.startImageStream(_processCameraImage);
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isBusy || !mounted) return;
    
    final cubit = context.read<ScannerCubit>();
    if (cubit.state is ScannerProductDetected) return;

    _isBusy = true;

    try {
      final inputImageData = _inputImageFromCameraImage(image);
      if (inputImageData == null) {
        _isBusy = false;
        return;
      }

      final recognizedText = await _textRecognizer.processImage(inputImageData.image);
      
      if (recognizedText.text.isNotEmpty) {
        // Calcular ROI en coordenadas de la imagen
        final screenSize = MediaQuery.of(context).size;
        
        final scale = max(
          screenSize.width / inputImageData.mappedSize.width, 
          screenSize.height / inputImageData.mappedSize.height
        );
        
        final renderedWidth = inputImageData.mappedSize.width * scale;
        final renderedHeight = inputImageData.mappedSize.height * scale;
        
        final dx = (renderedWidth - screenSize.width) / 2;
        final dy = (renderedHeight - screenSize.height) / 2;
        
        // UI ROI
        final scanAreaWidth = screenSize.width * 0.85;
        final scanAreaHeight = scanAreaWidth * 0.4;
        final uiLeft = (screenSize.width - scanAreaWidth) / 2;
        final uiTop = (screenSize.height - scanAreaHeight) / 2;
        
        final roiRect = Rect.fromLTRB(
          (uiLeft + dx) / scale, 
          (uiTop + dy) / scale, 
          (uiLeft + scanAreaWidth + dx) / scale, 
          (uiTop + scanAreaHeight + dy) / scale
        );

        await cubit.processText(recognizedText, roiRect, '');
      }
    } catch (e) {
      debugPrint('Error procesando imagen: $e');
    }

    _isBusy = false;
  }

  _InputImageData? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _cameraController!.value.deviceOrientation.index;
      if (rotationCompensation == -1) rotationCompensation = 0;
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || (Platform.isAndroid && format != InputImageFormat.nv21) || (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.isEmpty) return null;

    final inputImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    // Determinar tamaño mapeado para Portrait
    Size mappedSize;
    if (Platform.isAndroid && (rotation == InputImageRotation.rotation90deg || rotation == InputImageRotation.rotation270deg)) {
      mappedSize = Size(image.height.toDouble(), image.width.toDouble());
    } else {
      mappedSize = Size(image.width.toDouble(), image.height.toDouble());
    }

    return _InputImageData(image: inputImage, mappedSize: mappedSize);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _stopCamera() async {
    if (_cameraController != null) {
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
      await _cameraController!.dispose();
      _cameraController = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed) {
      if (context.read<ScannerCubit>().state is ScannerScanning) {
        _initCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<ScannerCubit, ScannerState>(
        listener: (context, state) {
          if (state is ScannerScanning) {
            if (_cameraController == null || !_cameraController!.value.isStreamingImages) {
               _initCamera();
            }
            if (state.warningMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.warningMessage!),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.orange.shade800,
                ),
              );
            }
          } else if (state is ScannerProductDetected) {
            _stopCamera();
            final categoryId = _supermercadoCategory?.id ?? '';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScanConfirmPage(
                  scanResult: state.result,
                  categoryId: categoryId,
                ),
              ),
            ).then((value) {
              if (value == true && mounted) {
                Navigator.pop(context, true);
              } else if (mounted) {
                context.read<ScannerCubit>().resumeScanning();
              }
            });
          } else if (state is ScannerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ScannerInitial || state is ScannerCameraLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (state is ScannerError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => openAppSettings(),
                      child: const Text('Abrir Configuración'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_cameraController == null || !_cameraController!.value.isInitialized) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(_cameraController!),
              // Overlay / Cenefa
              CustomPaint(
                painter: _ScannerOverlayPainter(),
                child: Container(),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off, color: _flashOn ? Colors.yellow : Colors.white, size: 30),
                        onPressed: () {
                          if (_cameraController != null) {
                            setState(() {
                              _flashOn = !_flashOn;
                              _cameraController!.setFlashMode(
                                _flashOn ? FlashMode.torch : FlashMode.off
                              );
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Encuadra la cenefa del supermercado',
                    style: TextStyle(color: Colors.white, fontSize: 16, shadows: [
                      Shadow(color: Colors.black, blurRadius: 4)
                    ]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Cenefa rectangular, más ancha que alta
    final scanAreaWidth = size.width * 0.85;
    final scanAreaHeight = scanAreaWidth * 0.4; 
    final scanAreaRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaWidth,
      height: scanAreaHeight,
    );

    // Dibujar el fondo oscuro excluyendo el área central
    final bgPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanAreaRect, const Radius.circular(8)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(bgPath, paint);

    // Dibujar las esquinas del marco
    final borderPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final cornerLength = 20.0;

    canvas.drawLine(scanAreaRect.topLeft, scanAreaRect.topLeft + Offset(cornerLength, 0), borderPaint);
    canvas.drawLine(scanAreaRect.topLeft, scanAreaRect.topLeft + Offset(0, cornerLength), borderPaint);

    canvas.drawLine(scanAreaRect.topRight, scanAreaRect.topRight + Offset(-cornerLength, 0), borderPaint);
    canvas.drawLine(scanAreaRect.topRight, scanAreaRect.topRight + Offset(0, cornerLength), borderPaint);

    canvas.drawLine(scanAreaRect.bottomLeft, scanAreaRect.bottomLeft + Offset(cornerLength, 0), borderPaint);
    canvas.drawLine(scanAreaRect.bottomLeft, scanAreaRect.bottomLeft + Offset(0, -cornerLength), borderPaint);

    canvas.drawLine(scanAreaRect.bottomRight, scanAreaRect.bottomRight + Offset(-cornerLength, 0), borderPaint);
    canvas.drawLine(scanAreaRect.bottomRight, scanAreaRect.bottomRight + Offset(0, -cornerLength), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InputImageData {
  final InputImage image;
  final Size mappedSize;

  _InputImageData({required this.image, required this.mappedSize});
}
