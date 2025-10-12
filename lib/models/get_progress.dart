class ProgressModel {
  final String judul;
  final String tanggal;
  final String jam;
  final String namaFile;
  final String pesan;
  final String status;

  ProgressModel({
    required this.judul,
    required this.tanggal,
    required this.jam,
    required this.namaFile,
    required this.pesan,
    required this.status,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      judul: json['judul'] ?? '',
      tanggal: json['tanggal'] ?? '',
      jam: json['jam'] ?? '',
      namaFile: json['namaFile'] ?? '',
      pesan: json['pesan'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'tanggal': tanggal,
      'jam': jam,
      'namaFile': namaFile,
      'pesan': pesan,
      'status': status,
    };
  }
}