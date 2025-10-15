import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/models/aktivitas_terkini_mahasiswa.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'package:bimta/services/bimbingan/dospem.dart';
import 'package:bimta/services/general/aktivitas_terkini_mahasiswa.dart';
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
  String? nama;
  List<Dospem> dosenPembimbing = [];
  bool isLoadingDospem = true;
  String? errorDospem;

  List<AktivitasTerkini> aktivitasList = [];
  bool isLoadingAktivitas = true;
  String? errorAktivitas;

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadDosenPembimbing();
    loadAktivitasTerkini();
  }

  void loadUserData() async {
    final userData = await TokenStorage().getUserData();
    setState(() {
      nama = userData['nama'];
    });
  }

  void loadDosenPembimbing() async {
    try {
      final dospemService = DospemService();
      final dospem = await dospemService.getDospem();
      setState(() {
        dosenPembimbing = dospem;
        isLoadingDospem = false;
      });
    } catch (e) {
      setState(() {
        errorDospem = e.toString();
        isLoadingDospem = false;
      });
      print('Error loading dosen pembimbing: $e');
    }
  }

  void loadAktivitasTerkini() async {
    try {
      final aktivitasService = AktivitasTerkiniService();
      final aktivitas = await aktivitasService.getAktivitasTerkini();
      setState(() {
        aktivitasList = aktivitas;
        isLoadingAktivitas = false;
      });
    } catch (e) {
      setState(() {
        errorAktivitas = e.toString();
        isLoadingAktivitas = false;
      });
      print('Error loading aktivitas terkini: $e');
    }
  }

  IconData _getIconByType(String iconType) {
    switch (iconType) {
      case 'progress':
        return Icons.assignment_turned_in;
      case 'jadwal':
        return Icons.event;
      default:
        return Icons.info;
    }
  }

  List<Color> _getGradientByType(String iconType) {
    switch (iconType) {
      case 'progress':
        return [Colors.orange.shade400, Colors.orange.shade600];
      case 'jadwal':
        return [Colors.blue.shade400, Colors.blue.shade600];
      default:
        return [Colors.grey.shade400, Colors.grey.shade600];
    }
  }

  Color _getIconShadowColor(String iconType) {
    switch (iconType) {
      case 'progress':
        return Colors.orange.withOpacity(0.3);
      case 'jadwal':
        return Colors.blue.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  String _formatTanggal(DateTime tanggal) {
    // Format tanggal manual untuk menghindari locale initialization
    const List<String> bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

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
                        "Selamat Datang,",
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        nama ?? '...',
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Mulai Bimbingan Tugas Akhirmu",
                        style: TextStyle(fontFamily: 'Poppins'),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              isLoadingDospem
                                  ? Text(
                                "Memuat...",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                                  : errorDospem != null
                                  ? Text(
                                "Gagal memuat data",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.red,
                                ),
                              )
                                  : dosenPembimbing.isEmpty
                                  ? Text(
                                "Belum ada dosen pembimbing",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                ),
                              )
                                  : Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: dosenPembimbing
                                    .map(
                                      (dospem) => Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        bottom: 5),
                                    child: Text(
                                      dospem.nama,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                )
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/kalender');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.deepOrangeAccent,
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Jadwal Kegiatan",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Lihat jadwal dosen pembimbing Anda",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/form-online');
                              },
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
                                            fontSize: 13,
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
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/form-offline');
                              },
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
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Text(
                                          "Ajukan pertemuan secara langsung",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Poppins',
                                          ),
                                        )
                                      ],
                                    ),
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
                              isLoadingAktivitas
                                  ? "Aktivitas Terkini (...)"
                                  : "Aktivitas Terkini (${aktivitasList.length})",
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          isLoadingAktivitas
                              ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : errorAktivitas != null
                              ? Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Gagal memuat aktivitas terkini",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.red.shade700,
                              ),
                            ),
                          )
                              : aktivitasList.isEmpty
                              ? Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Belum ada aktivitas terkini",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          )
                              : ListView.separated(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5),
                            itemCount: aktivitasList.length,
                            separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = aktivitasList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withAlpha(20),
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
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  child: InkWell(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    onTap: () {
                                      // Handle tap action
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration:
                                            BoxDecoration(
                                              gradient:
                                              LinearGradient(
                                                colors:
                                                _getGradientByType(
                                                    item.icon),
                                                begin: Alignment
                                                    .topLeft,
                                                end: Alignment
                                                    .bottomRight,
                                              ),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                  _getIconShadowColor(
                                                      item.icon),
                                                  spreadRadius: 0,
                                                  blurRadius: 8,
                                                  offset:
                                                  const Offset(
                                                      0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              _getIconByType(
                                                  item.icon),
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                              width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  item.nama,
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                    'Poppins',
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    color: Colors
                                                        .black87,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .access_time_rounded,
                                                      size: 10,
                                                      color: Colors
                                                          .grey
                                                          .shade600,
                                                    ),
                                                    const SizedBox(
                                                        width: 4),
                                                    Text(
                                                      _formatTanggal(
                                                          item.tanggal),
                                                      style:
                                                      TextStyle(
                                                        fontSize:
                                                        12,
                                                        fontFamily:
                                                        'Poppins',
                                                        fontWeight:
                                                        FontWeight
                                                            .w400,
                                                        color: Colors
                                                            .grey
                                                            .shade600,
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
                                            decoration:
                                            BoxDecoration(
                                              color: Colors
                                                  .grey.shade50,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                              border: Border.all(
                                                color: Colors.grey
                                                    .shade200,
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons
                                                  .arrow_forward_ios_rounded,
                                              size: 14,
                                              color: Colors
                                                  .grey.shade600,
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
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/referensi');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 25,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF677BE6),
                                      Color(0xFF754EA6)
                                    ],
                                  ),
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
                                        fontWeight: FontWeight.w600,
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
                ),
              ),
            ),
          ),
          BottombarLayout(initialIndex: 0)
        ],
      ),
    );
  }
}