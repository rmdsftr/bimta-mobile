class JumlahMahasiswaDibimbing {
  final int jumlah;

  JumlahMahasiswaDibimbing({
    required this.jumlah,
  });

  factory JumlahMahasiswaDibimbing.fromJson(Map<String, dynamic> json) {
    return JumlahMahasiswaDibimbing(
      jumlah: json['jumlah'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jumlah': jumlah,
    };
  }
}