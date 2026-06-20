import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:gastos_personales/layers/scanner/domain/usecase/analyze_shelf_label_usecase.dart';
import 'package:gastos_personales/presentation/screens/bloc/scanner/scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final AnalyzeShelfLabelUseCase _analyzeUseCase;
  DateTime? _lastDetectionTime;

  ScannerCubit(this._analyzeUseCase) : super(ScannerInitial());

  Future<void> requestCameraPermission() async {
    emit(ScannerCameraLoading());
    final status = await Permission.camera.request();
    if (status.isGranted) {
      emit(ScannerScanning());
    } else {
      emit(const ScannerError("Se requiere acceso a la cámara para escanear cenefas."));
    }
  }

  Future<void> processText(String text, String imagePath) async {
    if (state is ScannerProductDetected) return;

    // Debounce to avoid constant processing
    if (_lastDetectionTime != null && DateTime.now().difference(_lastDetectionTime!).inMilliseconds < 1000) {
      return;
    }
    _lastDetectionTime = DateTime.now();

    final result = _analyzeUseCase(text, imagePath);

    if (result != null) {
      // Vibrate on detect
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 200);
      }
      
      emit(ScannerProductDetected(result));
    }
  }

  void resumeScanning() {
    emit(ScannerScanning());
  }
}
