class LoginRequest {
  final String userId;
  final String password;

  LoginRequest({
    required this.userId,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'sandi': password,
  };
}


class LoginResponse {
  final bool success;
  final String message;
  final UserData? data;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String userId;
  final String nama;
  final String role;
  final String access_token;
  final String refresh_token;

  UserData({
    required this.userId,
    required this.nama,
    required this.role,
    required this.access_token,
    required this.refresh_token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] ?? '',
      nama: json['nama'] ?? '',
      role: json['role'] ?? '',
      access_token: json['access_token'],
      refresh_token: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'nama': nama,
    'role': role,
    'email': access_token,
    'token': refresh_token,
  };
}