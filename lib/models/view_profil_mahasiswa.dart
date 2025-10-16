class ProfileMahasiswa {
  final String userId;
  final String nama;
  final String? judul;
  final String? judulTemp;
  final String statusBimbingan;
  final String? photoUrl;

  ProfileMahasiswa({
    required this.userId,
    required this.nama,
    this.judul,
    this.judulTemp,
    required this.statusBimbingan,
    this.photoUrl,
  });

  factory ProfileMahasiswa.fromJson(Map<String, dynamic> json) {
    return ProfileMahasiswa(
      userId: json['user_id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      judul: json['judul']?.toString(),
      judulTemp: json['judul_temp']?.toString(),
      photoUrl: json['photo_url']?.toString(),
      statusBimbingan: json['status_bimbingan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama': nama,
      'judul': judul,
      'judul_temp': judulTemp,
      'photo_url': photoUrl,
      'status_bimbingan': statusBimbingan,
    };
  }

  bool get hasJudulRequest {
    return judulTemp != null && judulTemp!.isNotEmpty;
  }

  bool get isBimbinganDone {
    // Trim whitespace dan convert ke lowercase untuk perbandingan yang lebih akurat
    final status = statusBimbingan.trim().toLowerCase();

    // Backend mengirim status dalam format "[done]" atau "done"
    // Kita cek keduanya
    return status == 'done' ||
        status == '[done]' ||
        status == 'selesai' ||
        status == '[selesai]' ||
        status.contains('done') ||
        status.contains('selesai');
  }
}