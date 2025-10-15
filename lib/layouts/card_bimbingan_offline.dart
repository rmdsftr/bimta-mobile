import 'package:bimta/widgets/action_buttons.dart';
import 'package:bimta/widgets/snackbar.dart'; // Import custom snackbar
import 'package:flutter/material.dart';

class CardBimbinganOffline extends StatelessWidget {
  final String nama;
  final String nim;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String judul;
  final String pesan;
  final String namaFile;
  final String status;
  final Function(int)? onActionChanged;

  const CardBimbinganOffline({
    super.key,
    required this.nama,
    required this.nim,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.judul,
    required this.pesan,
    required this.namaFile,
    required this.status,
    this.onActionChanged,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return const Color(0xFF5B6AE3);
      case 'accepted':
        return const Color(0xFF4CAF50);
      case 'declined':
        return const Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'waiting':
        return 'Waiting';
      case 'accepted':
        return 'Accepted';
      case 'declined':
        return 'Declined';
      default:
        return 'Unknown';
    }
  }

  void _handleAction(BuildContext context, int index) {
    if (index == 0) {
      showCustomSnackBar(
        context,
        '$nama - Bimbingan diterima',
        isError: false,
      );
    } else if (index == 1) {
      showCustomSnackBar(
        context,
        '$nama - Bimbingan ditolak',
        isError: true,
      );
    }
    onActionChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: Center(
                  child: Text(
                    nama.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      nim,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  getStatusLabel(status),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tanggal",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    tanggal,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Waktu",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    waktu,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lokasi",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              Text(
                lokasi,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Topik Pembahasan",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              Text(
                judul,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.black87,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (status != 'accepted' && status!= 'declined')
            ActionButtons(
              selectedIndex: -1,
              onChanged: (index) {
                _handleAction(context, index);
              },
              items: const [
                Text("Terima"),
                Text("Tolak"),
              ],
            ),
        ],
      ),
    );
  }
}