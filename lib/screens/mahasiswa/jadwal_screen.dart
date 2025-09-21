import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_jadwal.dart';
import 'package:bimta/layouts/card_progress.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/logo_corner.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:flutter/material.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  int currentIndex = 0;

  final List<Map<String, String>> allProgressData = [
    {
      'subjek': 'Bimbingan Skripsi - Bab 1',
      'tanggal': '15 Sep 2024',
      'waktu': '10:30',
      'lokasi': 'BAB1_Pendahuluan.docx',
      'pesan': 'Mohon review untuk bab pendahuluan skripsi saya. Saya sudah menambahkan latar belakang masalah dan rumusan masalah sesuai saran sebelumnya.',
      'status': 'waiting'
    },
    {
      'subjek': 'Revisi Proposal Penelitian',
      'tanggal': '14 Sep 2024',
      'waktu': '14:15',
      'lokasi': 'Proposal_Revisi.pdf',
      'pesan': 'Sudah saya revisi sesuai masukan kemarin. Terutama pada bagian metodologi penelitian dan jadwal penelitian.',
      'status': 'accepted'
    },
    {
      'subjek': 'Konsultasi Metodologi',
      'tanggal': '13 Sep 2024',
      'waktu': '09:00',
      'lokasi': 'Metodologi_Draft.docx',
      'pesan': 'Perlu bimbingan untuk metodologi penelitian. Masih bingung mengenai teknik sampling yang tepat untuk penelitian ini.',
      'status': 'declined'
    },
    {
      'subjek': 'Final Draft Abstrak',
      'tanggal': '12 Sep 2024',
      'waktu': '16:45',
      'lokasi': 'Abstrak_Final.pdf',
      'pesan': 'Abstrak sudah selesai dan siap untuk dipresentasikan. Terima kasih atas bimbingannya selama ini.',
      'status': 'waiting'
    },
    {
      'subjek': 'Bimbingan Skripsi - Bab 2',
      'tanggal': '11 Sep 2024',
      'waktu': '13:20',
      'lokasi': 'BAB2_TinjauanPustaka.docx',
      'pesan': 'Draft bab 2 tinjauan pustaka. Saya sudah mengumpulkan 25 referensi jurnal dari tahun 2019-2024.',
      'status': 'accepted'
    },
    {
      'subjek': 'Perbaikan Daftar Pustaka',
      'tanggal': '10 Sep 2024',
      'waktu': '11:30',
      'lokasi': 'DaftarPustaka_Revisi.docx',
      'pesan': 'Sudah diperbaiki sesuai format APA yang benar. Mohon dicek kembali apakah sudah sesuai standar.',
      'status': 'declined'
    },
    {
      'subjek': 'Konsultasi Analisis Data',
      'tanggal': '09 Sep 2024',
      'waktu': '15:00',
      'lokasi': 'AnalisisData_Draft.xlsx',
      'pesan': 'Butuh bimbingan untuk analisis statistik menggunakan SPSS. Data sudah terkumpul semua.',
      'status': 'waiting'
    },
    {
      'subjek': 'Persetujuan Judul Skripsi',
      'tanggal': '08 Sep 2024',
      'waktu': '10:00',
      'lokasi': 'JudulSkripsi_Final.pdf',
      'pesan': 'Judul skripsi telah disetujui dan dapat dilanjutkan ke tahap penulisan proposal. Selamat!',
      'status': 'accepted'
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
                "Jadwal",
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
              padding: const EdgeInsets.only(top: 100, bottom: 65),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Bimbingan secara offline, segera ajukan dan pantau bimbingan offline Anda!",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 15),
                      Subnav(
                        items: [
                          Text("Waiting"),
                          Text("Accepted"),
                          Text("Declined"),
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
                          Navigator.pushNamed(context, '/form-offline');
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
                              "Tambah Bimbingan Offline",
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
                              child: CardJadwal(
                                subjek: data['subjek']!,
                                tanggal: data['tanggal']!,
                                waktu: data['waktu']!,
                                lokasi: data['lokasi']!,
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
          const BottombarLayout(initialIndex: 2),
        ],
      ),
    );
  }
}