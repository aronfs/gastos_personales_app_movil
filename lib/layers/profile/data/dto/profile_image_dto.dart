import 'package:gastos_personales/layers/profile/domain/entity/profile_image.dart';

class ProfileImageDto {
  static ProfileImage fromMap(Map<String, dynamic> json) {
    final data = _toMap(json['data']);
    return ProfileImage(
      id: _string(data['id']),
      fileUrl: _string(data['file_url']),
      mimeType: _string(data['mime_type']),
    );
  }

  static Map<String, dynamic> metadataFromMap(Map<String, dynamic> json) {
    final data = _toMap(json['data']);
    return {
      'file_name': _string(data['file_name']),
      'mime_type': _string(data['mime_type']),
      'file_size': _parseInt(data['file_size']),
      'created_at': _string(data['created_at']),
    };
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return {};
  }

  static String _string(dynamic value) {
    if (value is String) return value;
    return value?.toString() ?? '';
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return 0;
      return int.tryParse(trimmed) ?? 0;
    }
    return 0;
  }
}
