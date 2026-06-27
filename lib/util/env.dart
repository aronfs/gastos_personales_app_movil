class Env {
  static const String enviroment = String.fromEnvironment('ENV', defaultValue: 'development');

  static String get baseUrl {
    switch (enviroment) {
      case 'production':
        return 'https://api.nike.com/api/v1';
      case 'staging':
        return 'https://staging-api.nike.com/api/v1';
      case 'development':
        return 'https://6f9d-200-24-146-75.ngrok-free.app/api/v1';
      default:
        return 'https://api.nike.com/api/v1';
    }
  }

  /// Backend origin (scheme + host + port) for constructing image URLs.
  /// Extracted from [baseUrl] or overridden for local dev.
  static String get imageBaseUrl {
    switch (enviroment) {
      case 'production':
        return 'https://api.nike.com';
      case 'staging':
        return 'https://staging-api.nike.com';
      case 'development':
        return 'http://localhost:3000';
      default:
        return 'https://api.nike.com';
    }
  }
}