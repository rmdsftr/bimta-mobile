class ChangeJudulRequest {
  final String judulBaru;

  ChangeJudulRequest({required this.judulBaru});

  Map<String, dynamic> toJson() {
    return {
      'judulBaru': judulBaru,
    };
  }
}

class ChangeJudulResponse {
  final bool success;
  final String message;

  ChangeJudulResponse({
    required this.success,
    required this.message,
  });

  factory ChangeJudulResponse.fromJson(Map<String, dynamic> json) {
    return ChangeJudulResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Judul TA berhasil diubah',
    );
  }
}