class MahasiswaDibimbing {
  final String userId;
  final String nama;
  final String? judul;
  final String? photo_url;
  final String statusBimbingan;

  MahasiswaDibimbing({
    required this.userId,
    required this.nama,
    this.judul,
    this.photo_url,
    required this.statusBimbingan,
  });

  factory MahasiswaDibimbing.fromJson(Map<String, dynamic> json) {
    return MahasiswaDibimbing(
      userId: json['users_bimbingan_mahasiswa_idTousers']['user_id'] as String,
      nama: json['users_bimbingan_mahasiswa_idTousers']['nama'] as String,
      judul: json['users_bimbingan_mahasiswa_idTousers']['judul'] as String?,
      photo_url: json['users_bimbingan_mahasiswa_idTousers']['photo_url'] as String?,
      statusBimbingan: json['status_bimbingan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama': nama,
      'judul': judul,
      'photo_url' : photo_url,
      'status_bimbingan': statusBimbingan,
    };
  }
}