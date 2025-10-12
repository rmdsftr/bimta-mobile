class Dospem {
  final String nama;

  Dospem({
    required this.nama,
  });

  factory Dospem.fromJson(Map<String, dynamic> json) {
    return Dospem(
      nama: json['nama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
    };
  }
}
