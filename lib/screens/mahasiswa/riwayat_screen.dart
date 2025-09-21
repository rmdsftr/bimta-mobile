import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_riwayat.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/widgets/background.dart';
import 'package:flutter/material.dart';

class RiwayatBimbingan {
  final String topik;
  final String tanggal;
  final String pembahasan;
  final String hasil;
  final String status;

  RiwayatBimbingan({
    required this.topik,
    required this.tanggal,
    required this.pembahasan,
    required this.hasil,
    required this.status,
  });

  IconData get icon {
    return status.toLowerCase() == 'offline'
        ? Icons.meeting_room_rounded
        : Icons.phone_android_rounded;
  }

  Color get color {
    return status.toLowerCase() == 'offline'
        ? Colors.blue
        : Colors.green;
  }

  String get displayTopik {
    return status.toLowerCase() == 'offline'
        ? 'Bimbingan Offline'
        : 'Bimbingan Online';
  }
}

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<RiwayatBimbingan> _dummyData = [
    RiwayatBimbingan(
      topik: 'Konsultasi Metodologi Penelitian',
      tanggal: '12 September 2025',
      pembahasan: 'Revisi BAB II - metodologi penelitian kuantitatif',
      hasil: 'Mahasiswa diminta untuk memperbaiki bagian teknik sampling dan menambahkan justifikasi pemilihan metode analisis data. Perlu ditambahkan flowchart metodologi penelitian.',
      status: 'offline',
    ),
    RiwayatBimbingan(
      topik: 'Review Latar Belakang',
      tanggal: '13 September 2025',
      pembahasan: 'Revisi BAB I - Latar belakang masalah',
      hasil: 'Latar belakang sudah cukup baik, namun perlu penambahan gap research yang lebih spesifik. Rumusan masalah sudah sesuai dengan topik penelitian.',
      status: 'online',
    ),
    RiwayatBimbingan(
      topik: 'Diskusi Tinjauan Pustaka',
      tanggal: '10 September 2025',
      pembahasan: 'Review BAB II - Kajian teoritis dan penelitian terdahulu',
      hasil: 'Tinjauan pustaka perlu diperluas dengan menambah referensi terbaru (5 tahun terakhir). Kerangka teoritis sudah bagus, namun perlu penjelasan yang lebih detail.',
      status: 'offline',
    ),
    RiwayatBimbingan(
      topik: 'Konsultasi Proposal',
      tanggal: '8 September 2025',
      pembahasan: 'Pembahasan keseluruhan draft proposal skripsi',
      hasil: 'Proposal secara keseluruhan sudah baik. Perlu perbaikan pada bagian jadwal penelitian dan penyesuaian budget. Siap untuk ujian proposal.',
      status: 'online',
    ),
    RiwayatBimbingan(
      topik: 'Bimbingan Analisis Data',
      tanggal: '5 September 2025',
      pembahasan: 'Diskusi hasil pengolahan data dan interpretasi',
      hasil: 'Hasil analisis sudah sesuai dengan hipotesis. Perlu penambahan pembahasan untuk hasil yang tidak signifikan dan implikasi praktis dari temuan.',
      status: 'offline',
    ),
  ];

  List<RiwayatBimbingan> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = _dummyData;
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterData);
    _searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _dummyData.where((item) {
        return item.topik.toLowerCase().contains(query) ||
            item.pembahasan.toLowerCase().contains(query) ||
            item.tanggal.toLowerCase().contains(query) ||
            item.displayTopik.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                "Riwayat Bimbingan",
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Cari riwayat bimbingan",
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.black38,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black38,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF74ADDF),
                            width: 2,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _filteredData.isEmpty
                        ? const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: Colors.black26,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Belum ada riwayat bimbingan",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) {
                        final item = _filteredData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ExpandableCard(
                            topik: item.displayTopik,
                            tanggal: item.tanggal,
                            pembahasan: item.pembahasan,
                            hasil: item.hasil,
                            icon: item.icon,
                            color: item.color,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BottombarLayout(initialIndex: 3),
        ],
      ),
    );
  }
}