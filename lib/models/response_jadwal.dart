class ResponseJadwalDto {
  final String? noteDosen;

  ResponseJadwalDto({
    this.noteDosen,
  });

  Map<String, dynamic> toJson() {
    return {
      'note_dosen': noteDosen,
    };
  }

  factory ResponseJadwalDto.fromJson(Map<String, dynamic> json) {
    return ResponseJadwalDto(
      noteDosen: json['note_dosen'] as String?,
    );
  }
}

class JadwalResponseModel {
  final String message;

  JadwalResponseModel({
    required this.message,
  });

  factory JadwalResponseModel.fromJson(Map<String, dynamic> json) {
    return JadwalResponseModel(
      message: json['message'] as String,
    );
  }
}