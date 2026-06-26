import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:gastos_personales/data/services/profile_image_service.dart';

class ProfileImageProvider extends ChangeNotifier {
  final ProfileImageService _service;

  Uint8List? _imageBytes;
  bool _isLoading = false;

  Uint8List? get imageBytes => _imageBytes;
  bool get isLoading => _isLoading;

  ProfileImageProvider({ProfileImageService? service})
      : _service = service ?? ProfileImageService();

  Future<void> loadImage() async {
    _isLoading = true;
    notifyListeners();

    try {
      _imageBytes = await _service.getProfileImageFile();
    } catch (_) {
      _imageBytes = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImage() {
    _imageBytes = null;
    notifyListeners();
  }
}
