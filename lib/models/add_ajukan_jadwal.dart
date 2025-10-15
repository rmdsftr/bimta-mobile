class AddJadwalRequest {
  final String judul;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String pesan;

  AddJadwalRequest({
    required this.judul,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.pesan,
  });

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'tanggal': tanggal,
      'waktu': waktu,
      'lokasi': lokasi,
      'pesan': pesan,
    };
  }
}

class AddJadwalResponse {
  final int count;
  final bool success;
  final String? message;

  AddJadwalResponse({
    required this.count,
    this.success = true,
    this.message,
  });

  factory AddJadwalResponse.fromJson(Map<String, dynamic> json) {
    return AddJadwalResponse(
      count: json['count'] ?? 0,
      success: true,
      message: json['message'],
    );
  }
}