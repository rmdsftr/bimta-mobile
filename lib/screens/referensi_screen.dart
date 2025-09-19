import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_progress.dart';
import 'package:bimta/layouts/card_referensi.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/logo_corner.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:flutter/material.dart';

class ReferensiTAScreen extends StatefulWidget {
  const ReferensiTAScreen({super.key});

  @override
  State<ReferensiTAScreen> createState() => _ReferensiState();
}

class _ReferensiState extends State<ReferensiTAScreen> {

  final List<Map<String, String>> allReferensi = [
    {
      'nama' : 'Ramadhani Safitri',
      'nim' : '2211522009',
      'topik' : 'System Development',
      'tahun' : '2025',
      'judul' : 'Pembangunan Sistem Informasi Manajemen Perpustakaan'
    },
    {
      'nama' : 'Ramadhani Safitri',
      'nim' : '2211522009',
      'topik' : 'System Development',
      'tahun' : '2025',
      'judul' : 'Pembangunan Sistem Informasi Manajemen Perpustakaan'
    },
    {
      'nama' : 'Ramadhani Safitri',
      'nim' : '2211522009',
      'topik' : 'System Development',
      'tahun' : '2025',
      'judul' : 'Pembangunan Sistem Informasi Manajemen Perpustakaan'
    }
  ];

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
              leading: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Referensi Tugas Akhir",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
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
                      TextField(
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Cari berdasarkan judul atau nama",
                          hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black38
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black38,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none  // Hilangkan border default
                          ),
                          enabledBorder: OutlineInputBorder(  // Border saat tidak fokus
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,  // Tidak ada border
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
                            borderSide: BorderSide.none,  // Tidak ada border saat disabled
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if(allReferensi.isEmpty)
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
                          children: allReferensi.map((data) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: CardReferensi(
                                  nama: data['nama']!,
                                  nim: data['nim']!,
                                  topik: data['topik']!,
                                  judul: data['judul']!,
                                  tahun: data['tahun']!
                              ),
                            );
                          }).toList()
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const BottombarLayout(initialIndex: 0),
        ],
      ),
    );
  }
}