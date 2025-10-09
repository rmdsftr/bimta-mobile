class ReferensiTa {
  final String nimMahasiswa;
  final String namaMahasiswa;
  final String topik;
  final String judul;
  final int tahun;

  ReferensiTa({
    required this.nimMahasiswa,
    required this.namaMahasiswa,
    required this.topik,
    required this.judul,
    required this.tahun,
  });

  factory ReferensiTa.fromJson(Map<String, dynamic> json) {
    return ReferensiTa(
      nimMahasiswa: json['nim_mahasiswa'] as String,
      namaMahasiswa: json['nama_mahasiswa'] as String,
      topik: json['topik'] as String,
      judul: json['judul'] as String,
      tahun: json['tahun'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nim_mahasiswa': nimMahasiswa,
      'nama_mahasiswa': namaMahasiswa,
      'topik': topik,
      'judul': judul,
      'tahun': tahun,
    };
  }
}