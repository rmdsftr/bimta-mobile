import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/layouts/dosen_bottombar_layout.dart';
import 'package:flutter/material.dart';
import 'package:bimta/layouts/card_bimbingan_online.dart';
import 'package:bimta/widgets/action_buttons.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/subnav.dart';

class MahasiswaProgressScreen extends StatefulWidget {
  const MahasiswaProgressScreen({super.key});

  @override
  State<MahasiswaProgressScreen> createState() => _MahasiswaProgressScreenState();
}

class _MahasiswaProgressScreenState extends State<MahasiswaProgressScreen> {
  int selectedIndex = 0;

  String getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'unread';
      case 1:
        return 'revisi';
      case 2:
        return 'approved';
      default:
        return 'unread';
    }
  }

  final List<Map<String, String>> listProgressMahasiswa = [
    {
      'nama': 'Muhammad Zaki',
      'nim': '2211523031',
      'judul':
      'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'pesan':
      'Mohon direview Bab 2: tinjauan pustaka dan algoritma LSTM yang saya pakai.',
      'status': 'unread'
    },
    {
      'nama': 'Tegar Ananda',
      'nim': '2211523011',
      'judul':
      'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'pesan':
      'Terima kasih atas masukannya, sudah saya terapkan. Mohon konfirmasi akhir apakah bisa lanjut ke Bab 4.',
      'status': 'approved'
    },
    {
      'nama': 'Talitha Zulfa Amira',
      'nim': '2211522023',
      'judul':
      'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'pesan':
      'Saya masih kebingungan pada bagian preprocessing data. Bisa dibantu contoh scaling yang tepat?',
      'status': 'revisi'
    },
    {
      'nama': 'Ramadhani Safitri',
      'nim': '2211522009',
      'judul':
      'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'pesan':
      'Sudah saya perbaiki format referensi sesuai APA dan menambahkan 5 jurnal terbaru.',
      'status': 'approved'
    },
    {
      'nama': 'Ari Raihan Dafa',
      'nim': '2211523011',
      'judul':
      'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'pesan':
      'File draft Bab 3 saya lampirkan, mohon cek bagian metodologi dan jadwal penelitian.',
      'status': 'revisi'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = listProgressMahasiswa
        .where((mhs) => mhs['status'] == getStatusFromIndex(selectedIndex))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundWidget(),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomTopbar(
              leading: const Text(
                "Bimbingan Online",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),

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


                      Subnav(
                        items: const [
                          Text("Unread"),
                          Text("Revisi"),
                          Text("Approved"),
                        ],
                        selectedIndex: selectedIndex,
                        onChanged: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

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
                          children: filteredList.map((mhs) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                children: [
                                  CardBimbinganOnline(
                                    nama: mhs['nama']!,
                                    nim: mhs['nim']!,
                                    judul: mhs['judul']!,
                                    pesan: mhs['pesan']!,
                                    namaFile: 'BAB3_${mhs['nim']!}.pdf',
                                    status: mhs['status']!,
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
          const DosenBottombarLayout(initialIndex: 1),
        ],
      ),
    );
  }
}
