class DaftarMahasiswa {
  final String user_id;
  final String nama;

  DaftarMahasiswa({
    required this.user_id,
    required this.nama,
  });

  factory DaftarMahasiswa.fromJson(Map<String, dynamic> json) {
    return DaftarMahasiswa(
      user_id: json['user_id'] as String,
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'nama': nama,
    };
  }
}
