class AktivitasTerkini {
  final String? progressId;
  final String? bimbinganId;
  final String nama;
  final DateTime tanggal;
  final String icon;

  AktivitasTerkini({
    this.progressId,
    this.bimbinganId,
    required this.nama,
    required this.tanggal,
    required this.icon,
  });

  factory AktivitasTerkini.fromJson(Map<String, dynamic> json) {
    return AktivitasTerkini(
      progressId: json['progress_id'],
      bimbinganId: json['bimbingan_id'],
      nama: json['nama'] ?? '',
      tanggal: DateTime.parse(json['tanggal']),
      icon: json['icon'] ?? 'progress',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progress_id': progressId,
      'bimbingan_id': bimbinganId,
      'nama': nama,
      'tanggal': tanggal.toIso8601String(),
      'icon': icon,
    };
  }
}