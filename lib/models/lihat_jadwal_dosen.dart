class KegiatanModel {
  final String id;
  final String dosenId;
  final DateTime tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String namaKegiatan;
  final String? deskripsi;
  final DateTime createdAt;
  final DateTime updatedAt;

  KegiatanModel({
    required this.id,
    required this.dosenId,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.namaKegiatan,
    this.deskripsi,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      id: json['id']?.toString() ?? '',
      dosenId: json['dosen_id']?.toString() ?? '',
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'].toString())
          : DateTime.now(),
      jamMulai: json['jam_mulai']?.toString() ?? '00:00',
      jamSelesai: json['jam_selesai']?.toString() ?? '00:00',
      namaKegiatan: json['kegiatan']?.toString() ?? 'Kegiatan',
      deskripsi: json['deskripsi']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dosen_id': dosenId,
      'tanggal': tanggal.toIso8601String(),
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'nama_kegiatan': namaKegiatan,
      'deskripsi': deskripsi,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper method untuk format waktu
  String get formattedTime {
    // Jika jamMulai dan jamSelesai adalah string waktu (HH:mm:ss atau HH:mm)
    String formatTime(String time) {
      try {
        // Coba parse sebagai DateTime jika format ISO
        if (time.contains('T')) {
          final dateTime = DateTime.parse(time);
          return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        }
        // Jika sudah format HH:mm:ss, ambil HH:mm saja
        if (time.contains(':')) {
          final parts = time.split(':');
          return '${parts[0]}:${parts[1]}';
        }
        return time;
      } catch (e) {
        return time;
      }
    }

    return 'Jam ${formatTime(jamMulai)}-${formatTime(jamSelesai)}';
  }
}