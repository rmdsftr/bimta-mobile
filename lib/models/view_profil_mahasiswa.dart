class ProfileMahasiswa {
  final String userId;
  final String nama;
  final String? judul;

  ProfileMahasiswa({
    required this.userId,
    required this.nama,
    this.judul,
  });

  factory ProfileMahasiswa.fromJson(Map<String, dynamic> json) {
    return ProfileMahasiswa(
      userId: json['user_id'] as String,
      nama: json['nama'] as String,
      judul: json['judul'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama': nama,
      'judul': judul,
    };
  }
}