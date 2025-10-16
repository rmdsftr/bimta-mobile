class JadwalBimbingan {
  final String bimbinganId;
  final DateTime datetime;
  final String nama;
  final String nim;
  final String? photo_url;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String topik;
  final String pesan;
  final String status;
  final String? pesanDosen;

  JadwalBimbingan({
    required this.bimbinganId,
    required this.datetime,
    required this.nama,
    required this.nim,
    this.photo_url,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.topik,
    required this.pesan,
    required this.status,
    this.pesanDosen
  });

  factory JadwalBimbingan.fromJson(Map<String, dynamic> json) {
    return JadwalBimbingan(
      bimbinganId: json['bimbingan_id'] ?? '',
      datetime: DateTime.tryParse(json['datetime'] ?? '') ?? DateTime.now(),
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
        photo_url: json['photo_url'] ?? '',
      tanggal: json['tanggal'] ?? '',
      waktu: json['waktu'] ?? '',
      lokasi: json['lokasi'] ?? '',
      topik: json['topik'] ?? '',
      pesan: json['pesan'] ?? '',
      status: json['status'] ?? '',
      pesanDosen: json['pesanDosen'] ?? ''
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id' : bimbinganId,
      'datetime' : datetime,
      'nama': nama,
      'nim': nim,
      'photo_url' : photo_url,
      'tanggal': tanggal,
      'waktu': waktu,
      'lokasi': lokasi,
      'topik': topik,
      'pesan': pesan,
      'status': status,
      'pesanDosen' : pesanDosen
    };
  }

  // Helper method untuk format tanggal
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
}