import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/widgets/background.dart';
import 'package:flutter/material.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> notifikasiData = [];

  @override
  void initState() {
    super.initState();
    _loadNotifikasi();
  }

  Future<void> _loadNotifikasi() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        notifikasiData = [
          {
            "judul": "Progress Baru",
            "pesan": "Mahasiswa Andi Saputra mengirimkan progress terbaru.",
            "tanggal": "15 Nov 2024, 09.10 WIB",
            "icon": Icons.upload_file_rounded,
            "color": const Color(0xFF60D394),
          },
          {
            "judul": "Pengajuan Jadwal Bimbingan",
            "pesan": "Mahasiswa Bunga Lestari mengajukan jadwal bimbingan baru.",
            "tanggal": "14 Nov 2024, 13.45 WIB",
            "icon": Icons.event_note_rounded,
            "color": const Color(0xFF677BE6),
          },
          {
            "judul": "Perubahan Judul TA",
            "pesan": "Mahasiswa Rafi Hidayat mengajukan perubahan judul Tugas Akhir.",
            "tanggal": "14 Nov 2024, 08.25 WIB",
            "icon": Icons.edit_document,
            "color": const Color(0xFFFFA726),
          },
          {
            "judul": "Pengingat Bimbingan",
            "pesan": "Anda memiliki jadwal bimbingan hari ini pukul 10.00 WIB dengan Mahasiswa Dita.",
            "tanggal": "13 Nov 2024, 07.00 WIB",
            "icon": Icons.notifications_active_outlined,
            "color": const Color(0xFFFFB347),
          },
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat notifikasi: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundWidget(),

          // 🔹 Header mirip ReferensiTA
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Notifikasi",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Konten utama
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 65),
              child: RefreshIndicator(
                onRefresh: _loadNotifikasi,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Pantau semua notifikasi terbaru dari mahasiswa bimbingan Anda.",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Loading
                        if (isLoading)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: const CircularProgressIndicator(
                              color: Color(0xFF74ADDF),
                            ),
                          )

                        // Error
                        else if (errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(Icons.error_outline,
                                    size: 60, color: Colors.red[400]),
                                const SizedBox(height: 10),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _loadNotifikasi,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFF74ADDF),
                                  ),
                                  child: const Text(
                                    "Coba Lagi",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                        // Kosong
                        else if (notifikasiData.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(Icons.notifications_off_outlined,
                                      size: 60, color: Colors.grey[400]),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Belum ada notifikasi",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )

                          // Ada data
                          else
                            Column(
                              children: notifikasiData.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: _NotificationCard(
                                    title: item["judul"],
                                    message: item["pesan"],
                                    date: item["tanggal"],
                                    icon: item["icon"],
                                    color: item["color"],
                                  ),
                                );
                              }).toList(),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Bottom bar biar konsisten
          const BottombarLayout(initialIndex: 0),
        ],
      ),
    );
  }
}

// 🔹 Kartu notifikasi
class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final IconData icon;
  final Color color;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.date,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 13, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
