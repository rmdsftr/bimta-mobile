import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/logo_corner.dart';
import 'package:flutter/material.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/widgets/custom_bottombar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<Map<String, dynamic>> data = [
    {
      "icon": Icons.school,
      "nama": "Bimbingan TA",
      "tanggal": "17 Sep 2025",
    },
    {
      "icon": Icons.book,
      "nama": "Review Proposal",
      "tanggal": "15 Sep 2025",
    },
    {
      "icon": Icons.check_circle,
      "nama": "ACC Bab 1",
      "tanggal": "12 Sep 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BackgroundWidget(),
          LogoCorner(),
          Positioned.fill(
              child: Padding(
                  padding: EdgeInsets.only(top: 100, bottom: 50),
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Datang, Zaki!",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              "Mulai Bimbingan Tugas Akhirmu",
                              style: TextStyle(
                                  fontFamily: 'Poppins'
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(25),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Dosen Pembimbing : ",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600
                                        ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                        "Husnil Kamil, M.T",
                                        style: TextStyle(
                                          fontFamily: 'Poppins'
                                        ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFfff2cb),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(25),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/icons/online.png",
                                              height: 90,
                                              width: 90,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                                "Bimbingan Online",
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                                ),
                                            ),
                                            const Text(
                                                "Ajukan bimbingan secara virtual",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFC6E2CB),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(25),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/icons/offline.png",
                                              height: 90,
                                              width: 90,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                                "Bimbingan Offline",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600
                                                ),
                                            ),
                                            const Text(
                                                "Ajukan pertemuan secara langsung",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Poppins'
                                                ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),

                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    "Aktivitas Terkini (${data.length})",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  itemCount: data.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final item = data[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(20),
                                            spreadRadius: 0,
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Color(0x7674ADDF),
                                          width: 1,
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          onTap: () {
                                            // Handle tap action
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.blue.shade400,
                                                        Colors.blue.shade600,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.blue.withOpacity(0.3),
                                                        spreadRadius: 0,
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Icon(
                                                    item['icon'],
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),

                                                const SizedBox(width: 10),

                                                // Content
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item['nama'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.access_time_rounded,
                                                            size: 10,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            item['tanggal'],
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Container(
                                                  height: 32,
                                                  width: 32,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade50,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: Colors.grey.shade200,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 30),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    "Perlu inspirasi buat TA kamu? cek di sini!",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12
                                    ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, '/referensi');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10,bottom: 25),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                              colors: [
                                                Color(0xFF677BE6),
                                                Color(0xFF754EA6)
                                              ]
                                          )
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.bookmarks,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Referensi Tugas Akhir",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                    )
                  ),
              )
          ),

          BottombarLayout(initialIndex: 0)
        ],
      ),
    );
  }
}
