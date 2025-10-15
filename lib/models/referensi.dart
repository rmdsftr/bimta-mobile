class ReferensiTa {
  final String nimMahasiswa;
  final String namaMahasiswa;
  final String topik;
  final String judul;
  final int tahun;
  final String? docUrl; // Tambahkan field ini

  ReferensiTa({
    required this.nimMahasiswa,
    required this.namaMahasiswa,
    required this.topik,
    required this.judul,
    required this.tahun,
    this.docUrl, // Tambahkan parameter ini
  });

  factory ReferensiTa.fromJson(Map<String, dynamic> json) {
    // DEBUG: Print docUrl value
    print('Parsing docUrl: ${json['doc_url']}');

    return ReferensiTa(
      nimMahasiswa: json['nim_mahasiswa'] as String,
      namaMahasiswa: json['nama_mahasiswa'] as String,
      topik: json['topik'] as String,
      judul: json['judul'] as String,
      tahun: json['tahun'] as int,
      docUrl: json['doc_url'] as String?, // Parse doc_url dari API
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim_mahasiswa': nimMahasiswa,
      'nama_mahasiswa': namaMahasiswa,
      'topik': topik,
      'judul': judul,
      'tahun': tahun,
      'doc_url': docUrl,
    };
  }
}