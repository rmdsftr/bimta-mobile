class Kegiatan {
  final String jadwalDosenId;
  final String dosenId;
  final String kegiatan;
  final DateTime tanggal;
  final DateTime jamMulai;
  final DateTime jamSelesai;

  Kegiatan({
    required this.jadwalDosenId,
    required this.dosenId,
    required this.kegiatan,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    // Parse tanggal sebagai local date tanpa timezone conversion
    final tanggalStr = json['tanggal'].toString().split('T')[0];
    final tanggalParts = tanggalStr.split('-');

    return Kegiatan(
      jadwalDosenId: json['jadwal_dosen_id'],
      dosenId: json['dosen_id'],
      kegiatan: json['kegiatan'],
      tanggal: DateTime(
        int.parse(tanggalParts[0]),
        int.parse(tanggalParts[1]),
        int.parse(tanggalParts[2]),
      ),
      jamMulai: DateTime.parse(json['jam_mulai']),
      jamSelesai: DateTime.parse(json['jam_selesai']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jadwal_dosen_id': jadwalDosenId,
      'dosen_id': dosenId,
      'kegiatan': kegiatan,
      'tanggal': tanggal.toIso8601String(),
      'jam_mulai': jamMulai.toIso8601String(),
      'jam_selesai': jamSelesai.toIso8601String(),
    };
  }

  String get timeRange {
    final mulai = '${jamMulai.hour.toString().padLeft(2, '0')}:${jamMulai.minute.toString().padLeft(2, '0')}';
    final selesai = '${jamSelesai.hour.toString().padLeft(2, '0')}:${jamSelesai.minute.toString().padLeft(2, '0')}';
    return 'Jam $mulai-$selesai';
  }
}

class AddKegiatanRequest {
  final String kegiatan;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;

  AddKegiatanRequest({
    required this.kegiatan,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
  });

  Map<String, dynamic> toJson() {
    return {
      'kegiatan': kegiatan,
      'tanggal': tanggal,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
    };
  }
}