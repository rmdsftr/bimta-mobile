class AddProgressOnlineRequest {
  final String subjectProgress;
  final String noteMahasiswa;

  AddProgressOnlineRequest({
    required this.subjectProgress,
    required this.noteMahasiswa,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject_progress': subjectProgress,
      'note_mahasiswa': noteMahasiswa,
    };
  }
}

class ProgressResponse {
  final bool success;
  final String message;
  final dynamic data;

  ProgressResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProgressResponse.fromJson(Map<String, dynamic> json) {
    return ProgressResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Progress berhasil disubmit',
      data: json['data'],
    );
  }
}