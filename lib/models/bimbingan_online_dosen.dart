class ProgressOnlineModel {
  final String nama;
  final String nim;
  final String judul;
  final String pesan;
  final String status;
  final String fileName;
  final String fileUrl;

  ProgressOnlineModel({
    required this.nama,
    required this.nim,
    required this.judul,
    required this.pesan,
    required this.status,
    required this.fileName,
    required this.fileUrl,
  });

  factory ProgressOnlineModel.fromJson(Map<String, dynamic> json) {
    return ProgressOnlineModel(
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      judul: json['judul'] ?? '',
      pesan: json['pesan'] ?? '',
      status: json['status'] ?? '',
      fileName: json['file_name'] ?? '',
      fileUrl: json['file_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nim': nim,
      'judul': judul,
      'pesan': pesan,
      'status': status,
      'file_name': fileName,
      'file_url': fileUrl,
    };
  }
}