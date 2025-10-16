class ChangePasswordDto {
  final String sandiLama;
  final String sandiBaru;
  final String konfirmasiSandi;

  ChangePasswordDto({
    required this.sandiLama,
    required this.sandiBaru,
    required this.konfirmasiSandi,
  });

  Map<String, dynamic> toJson() {
    return {
      'sandiLama': sandiLama,
      'sandiBaru': sandiBaru,
      'konfirmasiSandi': konfirmasiSandi,
    };
  }
}

class ChangePasswordResponse {
  final bool success;
  final String message;

  ChangePasswordResponse({
    required this.success,
    required this.message,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      success: true,
      message: json['message'] ?? 'Password berhasil diubah',
    );
  }

  factory ChangePasswordResponse.error(String message) {
    return ChangePasswordResponse(
      success: false,
      message: message,
    );
  }
}