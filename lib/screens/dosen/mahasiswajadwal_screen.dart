import 'package:bimta/widgets/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/layouts/dosen_bottombar_layout.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:bimta/layouts/card_bimbingan_offline.dart';

class MahasiswaJadwalScreen extends StatefulWidget {
  const MahasiswaJadwalScreen({super.key});

  @override
  State<MahasiswaJadwalScreen> createState() => _MahasiswaJadwalScreenState();
}

class _MahasiswaJadwalScreenState extends State<MahasiswaJadwalScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> listBimbinganOffline = [
    {
      'nama': 'Zaki Andafi',
      'nim': '2211523031',
      'tanggal': '15 Nov 2025',
      'waktu': '10.00 – 11.30',
      'lokasi': 'LDKOM',
      'judul':
      'Diskusi hasil analisis dan pembahasan untuk BAB 4. Perlu review interpretasi data dan saran untuk perbaikan.',
      'pesan': '',
      'namaFile': '',
      'status': 'waiting'
    },
    {
      'nama': 'Tegar Ananda',
      'nim': '2211523011',
      'tanggal': '16 Nov 2025',
      'waktu': '09.00 – 10.00',
      'lokasi': 'Ruang Dosen',
      'judul':
      'Diskusi finalisasi Bab 5 dan penyiapan presentasi hasil penelitian.',
      'pesan': '',
      'namaFile': '',
      'status': 'accepted'
    },
    {
      'nama': 'Ramadhani Safitri',
      'nim': '2211522009',
      'tanggal': '17 Nov 2025',
      'waktu': '10.00 – 11.00',
      'lokasi': 'Ruang LDKOM',
      'judul':
      'Diskusi finalisasi Bab 5 dan penyiapan presentasi hasil penelitian.',
      'pesan': '',
      'namaFile': '',
      'status': 'accepted'
    },
    {
      'nama': 'Ari Raihan Dafa',
      'nim': '2211522003',
      'tanggal': '14 Nov 2025',
      'waktu': '10.00 – 11.30',
      'lokasi': 'Ruang Seminar',
      'judul':
      'Diskusi hasil analisis dan pembahasan untuk BAB 4. Perlu review interpretasi data dan saran untuk perbaikan.',
      'pesan': '',
      'namaFile': '',
      'status': 'waiting'
    },
    {
      'nama': 'Talitha Zulfa Amira',
      'nim': '2211522023',
      'tanggal': '14 Nov 2025',
      'waktu': '13.00 – 14.30',
      'lokasi': 'Lab BI',
      'judul':
      'Diskusi perbaikan Bab 3 (Metodologi) dan penyesuaian format referensi.',
      'pesan': '',
      'namaFile': '',
      'status': 'declined'
    },
  ];

  String getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'waiting';
      case 1:
        return 'accepted';
      case 2:
        return 'declined';
      default:
        return 'waiting';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = listBimbinganOffline
        .where((bimbingan) => bimbingan['status'] == getStatusFromIndex(selectedIndex))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundWidget(),

          // ✅ Custom Topbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomTopbar(
              leading: const Text(
                "Bimbingan Offline",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          // ✅ Konten utama seperti ProgressScreen
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pantau dan kelola bimbingan online mahasiswa Anda di sini!",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ✅ Subnav mirip ProgressScreen
                      Subnav(
                        items: const [
                          Text("Waiting"),
                          Text("Accepted"),
                          Text("Declined"),
                        ],
                        selectedIndex: selectedIndex,
                        onChanged: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // ✅ Data Bimbingan
                      if (filteredList.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Belum ada data bimbingan",
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
                      else
                        Column(
                          children: filteredList.map((bimbingan) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                children: [
                                  CardBimbinganOffline(
                                    nama: bimbingan['nama'] ?? '',
                                    nim: bimbingan['nim'] ?? '',
                                    tanggal: bimbingan['tanggal'] ?? '',
                                    waktu: bimbingan['waktu'] ?? '',
                                    lokasi: bimbingan['lokasi'] ?? '',
                                    judul: bimbingan['judul'] ?? '',
                                    pesan: bimbingan['pesan'] ?? '',
                                    namaFile: bimbingan['namaFile'] ?? '',
                                    status: bimbingan['status'] ?? '',
                                  ),
                                  const SizedBox(height: 8),
                                ],
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

          // ✅ Bottom bar
          const DosenBottombarLayout(initialIndex: 2),
        ],
      ),
    );
  }
}
