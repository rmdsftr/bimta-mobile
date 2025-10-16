class MahasiswaInfo {
  final String? judul;
  final String? noWhatsapp;

  MahasiswaInfo({
    this.judul,
    this.noWhatsapp,
  });

  factory MahasiswaInfo.fromJson(Map<String, dynamic> json) {
    return MahasiswaInfo(
      judul: json['judul'] as String?,
      noWhatsapp: json['no_whatsapp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'no_whatsapp': noWhatsapp,
    };
  }
}

class MahasiswaInfoResponse {
  final bool success;
  final String message;
  final MahasiswaInfo? data;

  MahasiswaInfoResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MahasiswaInfoResponse.success(MahasiswaInfo data) {
    return MahasiswaInfoResponse(
      success: true,
      message: 'Berhasil mengambil informasi mahasiswa',
      data: data,
    );
  }

  factory MahasiswaInfoResponse.error(String message) {
    return MahasiswaInfoResponse(
      success: false,
      message: message,
      data: null,
    );
  }
}