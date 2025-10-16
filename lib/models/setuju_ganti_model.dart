class ApproveJudulResponse {
  final bool success;
  final String message;

  ApproveJudulResponse({
    required this.success,
    required this.message,
  });

  factory ApproveJudulResponse.fromJson(Map<String, dynamic> json) {
    return ApproveJudulResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Perubahan judul berhasil disetujui',
    );
  }
}

class JudulRequestData {
  final String? judulLama;
  final String? judulBaru;
  final bool hasRequest;

  JudulRequestData({
    this.judulLama,
    this.judulBaru,
    required this.hasRequest,
  });

  factory JudulRequestData.fromProfile(Map<String, dynamic> profileData) {
    final judulTemp = profileData['judul_temp'] as String?;
    final judul = profileData['judul'] as String?;

    final hasRequest = judulTemp != null && judulTemp.isNotEmpty;

    return JudulRequestData(
      judulLama: judul,
      judulBaru: judulTemp,
      hasRequest: hasRequest,
    );
  }
}