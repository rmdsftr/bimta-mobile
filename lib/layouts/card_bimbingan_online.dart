import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:bimta/widgets/action_buttons.dart'; // pastikan impor ini sesuai path kamu

class CardBimbinganOnline extends StatelessWidget {
  final String nama;
  final String nim;
  final String judul;
  final String pesan;
  final String namaFile;
  final String status;

  const CardBimbinganOnline({
    super.key,
    required this.nama,
    required this.nim,
    required this.judul,
    required this.pesan,
    required this.namaFile,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    Color getStatusColor(String status) {
      switch (status) {
        case 'unread':
          return const Color(0xFF5B6AE3);
        case 'read':
          return Colors.grey;
        case 'revisi':
          return const Color(0xFFFF9800);
        case 'approved':
          return const Color(0xFF4CAF50);
        default:
          return Colors.grey;
      }
    }

    String getStatusLabel(String status) {
      switch (status) {
        case 'unread':
          return 'Unread';
        case 'read':
          return 'Read';
        case 'revisi':
          return 'Revisi';
        case 'approved':
          return 'Approved';
        default:
          return 'Unknown';
      }
    }
    int selectedIndex = -1;

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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  getStatusLabel(status),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            judul,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          ReadMoreText(
            pesan,
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Lihat selengkapnya',
            trimExpandedText: 'Tutup',
            colorClickableText: const Color(0xFF5B6AE3),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    namaFile,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  '2 jam lalu',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          if (status != 'approved')
            ActionButtons(
              selectedIndex: -1,
              onChanged: (index) {},
              items: const [
                Text("Preview"),
                Text("Correction"),
              ],
            ),
        ],
      ),
    );
  }
}
