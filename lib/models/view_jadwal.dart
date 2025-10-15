class JadwalModel {
  final String bimbinganId;
  final String subjek;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String pesan;
  final String status;

  JadwalModel({
    required this.bimbinganId,
    required this.subjek,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.pesan,
    required this.status,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      bimbinganId: json['bimbingan_id'] ?? '',
      subjek: json['subjek'] ?? '',
      tanggal: json['tanggal'] ?? '',
      waktu: json['waktu'] ?? '',
      lokasi: json['lokasi'] ?? '',
      pesan: json['pesan'] ?? '',
      status: json['status'] ?? 'waiting',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bimbingan_id': bimbinganId,
      'subjek': subjek,
      'tanggal': tanggal,
      'waktu': waktu,
      'lokasi': lokasi,
      'pesan': pesan,
      'status': status,
    };
  }

  // Helper method untuk format tanggal Indonesia
  String get formattedTanggal {
    try {
      final date = DateTime.parse(tanggal);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return tanggal;
    }
  }

  // Helper method untuk format waktu HH:MM
  String get formattedWaktu {
    try {
      if (waktu.contains(':')) {
        final parts = waktu.split(':');
        return '${parts[0]}:${parts[1]}';
      }
      return waktu;
    } catch (e) {
      return waktu;
    }
  }
}