class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String sessionId;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.sessionId,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>?;
    return LoginResponse(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      userId: user?['id']?.toString() ?? '',
      sessionId: data['sessionId']?.toString() ?? '',
    );
  }
}
