
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum JenisBimbinganEnum {
  offline,
  online;

  static JenisBimbinganEnum fromString(String value) {
    return JenisBimbinganEnum.values.firstWhere(
          (e) => e.name == value,
      orElse: () => JenisBimbinganEnum.offline,
    );
  }
}

class RiwayatBimbinganModel {
  final String id;
  final DateTime tanggal;
  final String pembahasan;
  final String hasil;
  final JenisBimbinganEnum jenis;

  RiwayatBimbinganModel({
    required this.id,
    required this.tanggal,
    required this.pembahasan,
    required this.hasil,
    required this.jenis,
  });

  factory RiwayatBimbinganModel.fromJson(Map<String, dynamic> json) {
    return RiwayatBimbinganModel(
      id: json['id'] as String? ?? '',
      tanggal: json['tanggal'] is String
          ? DateTime.parse(json['tanggal'] as String)
          : json['tanggal'] as DateTime,
      pembahasan: json['pembahasan'] as String? ?? '',
      hasil: json['hasil'] as String? ?? '',
      jenis: JenisBimbinganEnum.fromString(
        (json['jenis'] as String?)?.toLowerCase() ?? 'offline',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'pembahasan': pembahasan,
      'hasil': hasil,
      'jenis': jenis.name,
    };
  }

  // For displaying in UI
  String get displayTopik {
    return jenis == JenisBimbinganEnum.offline
        ? 'Bimbingan Offline'
        : 'Bimbingan Online';
  }

  IconData get icon {
    return jenis == JenisBimbinganEnum.offline
        ? Icons.meeting_room_rounded
        : Icons.phone_android_rounded;
  }

  Color get color {
    return jenis == JenisBimbinganEnum.offline
        ? Colors.blue
        : Colors.green;
  }

  String get formattedTanggal {
    return "${tanggal.day} ${_monthName(tanggal.month)} ${tanggal.year}";
  }

  static String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}