import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/layers/receipt_scanner/domain/usecase/analyze_receipt_usecase.dart';
import 'package:gastos_personales/presentation/screens/receipt_edit_page.dart';

enum _CaptureState { preview, processing, error }

class ReceiptCapturePage extends StatefulWidget {
  const ReceiptCapturePage({super.key});

  @override
  State<ReceiptCapturePage> createState() => _ReceiptCapturePageState();
}

class _ReceiptCapturePageState extends State<ReceiptCapturePage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  final TextRecognizer _textRecognizer = TextRecognizer();
  final AnalyzeReceiptUseCase _analyzeUseCase = AnalyzeReceiptUseCase();
  _CaptureState _state = _CaptureState.preview;
  String _statusMessage = '';
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final loc = AppLocalizations.of(context)!;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _setState(_CaptureState.error, loc.noCameraDetected);
        return;
      }

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
    } catch (e) {
      _setState(_CaptureState.error, loc.cameraError);
    }
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
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    final loc = AppLocalizations.of(context)!;
    _setState(_CaptureState.processing, loc.capturingImage);

    try {
      final xFile = await _cameraController!.takePicture();
      await _processImage(xFile.path);
    } catch (e) {
      _setState(_CaptureState.error, loc.captureError);
    }
  }

  Future<void> _pickFromGallery() async {
    final loc = AppLocalizations.of(context)!;
    _setState(_CaptureState.processing, loc.selectingImage);

    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        await _processImage(xFile.path);
      } else {
        _setState(_CaptureState.preview, '');
      }
    } catch (e) {
      _setState(_CaptureState.preview, '');
    }
  }

  Future<void> _processImage(String imagePath) async {
    final loc = AppLocalizations.of(context)!;
    _setState(_CaptureState.processing, loc.processingOcr);

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final ocrText = recognizedText.text;

      _setState(_CaptureState.processing, loc.analyzingReceipt);
      await Future.delayed(const Duration(milliseconds: 300));

      _setState(_CaptureState.processing, loc.detectingTotal);
      await Future.delayed(const Duration(milliseconds: 300));

      final analysis = _analyzeUseCase(ocrText);

      if (!mounted) return;

      if (analysis.total != null && !analysis.needsReview) {
        Navigator.pop(context, {'imagePath': imagePath, 'ocrText': ocrText, 'total': analysis.total});
      } else {
        final result = await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (_) => ReceiptEditPage(
              imagePath: imagePath,
              ocrText: ocrText,
              hintTotal: analysis.total,
            ),
          ),
        );

        if (!mounted) return;

        if (result != null) {
          Navigator.pop(context, result);
        } else {
          _setState(_CaptureState.preview, '');
        }
      }
    } catch (e) {
      _setState(_CaptureState.error, loc.imageProcessingError);
    }
  }

  void _setState(_CaptureState newState, String message) {
    if (!mounted) return;
    setState(() {
      _state = newState;
      _statusMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            CameraPreview(_cameraController!)
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Processing overlay
          if (_state == _CaptureState.processing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

          // Error overlay
          if (_state == _CaptureState.error)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _setState(_CaptureState.preview, ''),
                      child: Text(loc.retry),
                    ),
                  ],
                ),
              ),
            ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    loc.scanReceipt,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4)],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                      color: _flashOn ? Colors.yellow : Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      if (_cameraController != null) {
                        setState(() {
                          _flashOn = !_flashOn;
                          _cameraController!.setFlashMode(
                            _flashOn ? FlashMode.torch : FlashMode.off,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom bar
          if (_state == _CaptureState.preview)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 28),
                          onPressed: _pickFromGallery,
                        ),
                      ),
                      GestureDetector(
                        onTap: _captureImage,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.takePhotoHint,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
