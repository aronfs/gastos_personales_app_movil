import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:gastos_personales/layers/scanner/domain/usecase/analyze_shelf_label_usecase.dart';
import 'package:gastos_personales/presentation/screens/bloc/scanner/scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final AnalyzeShelfLabelUseCase _analyzeUseCase;
  DateTime? _lastDetectionTime;
  DateTime? _lastWarningTime;

  ScannerCubit(this._analyzeUseCase) : super(ScannerInitial());

  Future<void> requestCameraPermission() async {
    emit(ScannerCameraLoading());
    final status = await Permission.camera.request();
    if (status.isGranted) {
      emit(const ScannerScanning());
    } else {
      emit(const ScannerError("Se requiere acceso a la cámara para escanear cenefas."));
    }
  }

  Future<void> processText(RecognizedText recognizedText, Rect roi, String imagePath) async {
    if (state is ScannerProductDetected) return;

    // Debounce total (para no procesar si acabamos de detectar algo)
    if (_lastDetectionTime != null && DateTime.now().difference(_lastDetectionTime!).inMilliseconds < 1000) {
      return;
    }

    final result = _analyzeUseCase(recognizedText, roi, imagePath);

    if (result.status == ShelfLabelStatus.success && result.product != null) {
      _lastDetectionTime = DateTime.now();
      // Vibrate on detect
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 200);
      }
      emit(ScannerProductDetected(result.product!));
    } else if (result.status == ShelfLabelStatus.warning) {
      // Mostrar warning, pero no floodear la pantalla (cada 2 segundos máximo)
      if (_lastWarningTime == null || DateTime.now().difference(_lastWarningTime!).inSeconds >= 2) {
        _lastWarningTime = DateTime.now();
        emit(ScannerScanning(warningMessage: result.message));
        // Limpiar el warning después de 2 segundos
        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed && state is ScannerScanning) {
            emit(const ScannerScanning());
          }
        });
      }
    }
  }

  void resumeScanning() {
    emit(const ScannerScanning());
  }
}
