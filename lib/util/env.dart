class Env {
  static const String enviroment = String.fromEnvironment('ENV', defaultValue: 'development');

  static String get  baseUrl {
    switch (enviroment) {
      case 'production':
        return 'https://api.nike.com';
      case 'staging':
        return 'https://staging-api.nike.com';
      case 'development':
        return 'https://94ea-200-24-146-75.ngrok-free.app/api/v1';
      default:
        return 'https://api.nike.com';
    }
  }


}