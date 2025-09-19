import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_progress.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/logo_corner.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int currentIndex = 0;

  final List<Map<String, String>> allProgressData = [
    {
      'judul': 'Bimbingan Skripsi - Bab 1',
      'tanggal': '15 Sep 2024',
      'jam': '10:30',
      'namaFile': 'BAB1_Pendahuluan.docx',
      'pesan': 'Mohon review untuk bab pendahuluan skripsi saya. Saya sudah menambahkan latar belakang masalah dan rumusan masalah sesuai saran sebelumnya.',
      'status': 'unread'
    },
    {
      'judul': 'Revisi Proposal Penelitian',
      'tanggal': '14 Sep 2024',
      'jam': '14:15',
      'namaFile': 'Proposal_Revisi.pdf',
      'pesan': 'Sudah saya revisi sesuai masukan kemarin. Terutama pada bagian metodologi penelitian dan jadwal penelitian.',
      'status': 'read'
    },
    {
      'judul': 'Konsultasi Metodologi',
      'tanggal': '13 Sep 2024',
      'jam': '09:00',
      'namaFile': 'Metodologi_Draft.docx',
      'pesan': 'Perlu bimbingan untuk metodologi penelitian. Masih bingung mengenai teknik sampling yang tepat untuk penelitian ini.',
      'status': 'revisi'
    },
    {
      'judul': 'Final Draft Abstrak',
      'tanggal': '12 Sep 2024',
      'jam': '16:45',
      'namaFile': 'Abstrak_Final.pdf',
      'pesan': 'Abstrak sudah selesai dan siap untuk dipresentasikan. Terima kasih atas bimbingannya selama ini.',
      'status': 'approved'
    },
    {
      'judul': 'Bimbingan Skripsi - Bab 2',
      'tanggal': '11 Sep 2024',
      'jam': '13:20',
      'namaFile': 'BAB2_TinjauanPustaka.docx',
      'pesan': 'Draft bab 2 tinjauan pustaka. Saya sudah mengumpulkan 25 referensi jurnal dari tahun 2019-2024.',
      'status': 'unread'
    },
    {
      'judul': 'Perbaikan Daftar Pustaka',
      'tanggal': '10 Sep 2024',
      'jam': '11:30',
      'namaFile': 'DaftarPustaka_Revisi.docx',
      'pesan': 'Sudah diperbaiki sesuai format APA yang benar. Mohon dicek kembali apakah sudah sesuai standar.',
      'status': 'read'
    },
    {
      'judul': 'Konsultasi Analisis Data',
      'tanggal': '09 Sep 2024',
      'jam': '15:00',
      'namaFile': 'AnalisisData_Draft.xlsx',
      'pesan': 'Butuh bimbingan untuk analisis statistik menggunakan SPSS. Data sudah terkumpul semua.',
      'status': 'revisi'
    },
    {
      'judul': 'Persetujuan Judul Skripsi',
      'tanggal': '08 Sep 2024',
      'jam': '10:00',
      'namaFile': 'JudulSkripsi_Final.pdf',
      'pesan': 'Judul skripsi telah disetujui dan dapat dilanjutkan ke tahap penulisan proposal. Selamat!',
      'status': 'approved'
    },
  ];

  String getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'unread';
      case 1:
        return 'read';
      case 2:
        return 'revisi';
      case 3:
        return 'approved';
      default:
        return 'unread';
    }
  }

  List<Map<String, String>> getFilteredData() {
    String selectedStatus = getStatusFromIndex(currentIndex);
    return allProgressData.where((data) => data['status'] == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredData = getFilteredData();

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
                "Progress",
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
                    children: [
                      Text(
                        "Bimbingan secara online, kelola dan tambah bimbingan online Anda!",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 15),
                      Subnav(
                        items: [
                          Text("Unread"),
                          Text("Read"),
                          Text("Revisi"),
                          Text("Approved")
                        ],
                        selectedIndex: currentIndex,
                        onChanged: (index){
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF677BE6),
                                Color(0xFF754EA6)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Tambah Bimbingan Online",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                      SizedBox(height: 20),
                      if (filteredData.isEmpty)
                        Container(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Belum ada data",
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
                          children: filteredData.map((data) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: CardProgress(
                                judul: data['judul']!,
                                tanggal: data['tanggal']!,
                                jam: data['jam']!,
                                namaFile: data['namaFile']!,
                                pesan: data['pesan']!,
                                status: data['status']!,
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
          const BottombarLayout(initialIndex: 1),
        ],
      ),
    );
  }
}