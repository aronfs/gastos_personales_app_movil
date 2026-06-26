import 'package:equatable/equatable.dart';

class ProfileImage with EquatableMixin {
  final String id;
  final String fileUrl;
  final String mimeType;

  ProfileImage({
    required this.id,
    required this.fileUrl,
    required this.mimeType,
  });

  @override
  List<Object?> get props => [id, fileUrl, mimeType];
}
