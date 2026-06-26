import 'package:gastos_personales/layers/profile/domain/entity/profile.dart';
import 'package:gastos_personales/layers/profile/domain/entity/profile_image.dart';

class ProfileDto {
  static Profile fromMap(Map<String, dynamic> json) {
    final data = _toMap(json['data']);

    ProfileImage? profileImage;
    if (data['profileImage'] != null) {
      final img = _toMap(data['profileImage']);
      profileImage = ProfileImage(
        id: _string(img['id']),
        fileUrl: _string(img['file_url']),
        mimeType: _string(img['mime_type']),
      );
    }

    return Profile(
      id: _string(data['id']),
      email: _string(data['email']),
      firstName: _string(data['first_name']),
      lastName: _string(data['last_name']),
      active: _bool(data['active']),
      roles: _list(data['roles']),
      profileImage: profileImage,
    );
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

  static bool _bool(dynamic value) {
    if (value is bool) return value;
    return false;
  }

  static List<String> _list(dynamic value) {
    if (value is List) {
      return value.map<String>((e) {
        if (e is Map) return _string(e['name'] ?? e['nombre'] ?? '');
        return _string(e);
      }).toList();
    }
    return [];
  }
}
