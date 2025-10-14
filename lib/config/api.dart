class ApiConfig {
  static const String _devBaseUrl = 'http://192.168.100.106:3000';
  static const String _prodBaseUrl = 'https://your-production-url.com';

  static const bool _isDevelopment = true;

  static String get baseUrl => _isDevelopment ? _devBaseUrl : _prodBaseUrl;

  static String get loginEndpoint => '$baseUrl/auth/login';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}