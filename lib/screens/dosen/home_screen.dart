import 'package:bimta/layouts/dosen_bottombar_layout.dart';
import 'package:bimta/models/aktivitas_terkini_dosen.dart';
import 'package:bimta/services/bimbingan/jumlah_mahasiswa_bimbingan.dart';
import 'package:bimta/services/bimbingan/jumlah_pending_review.dart';
import 'package:bimta/services/general/aktivitas_terkini_dosen.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/logo_corner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Dosen_Homescreen extends StatefulWidget {
  const Dosen_Homescreen({Key? key}) : super(key: key);

  @override
  State<Dosen_Homescreen> createState() => _DosenHomescreenState();
}

class _DosenHomescreenState extends State<Dosen_Homescreen> {
  int jumlahMahasiswa = 0;
  int jumlahPending = 0;
  bool isLoadingJumlah = true;
  String? errorJumlah;
  bool isLoadingPending = true;
  String? errorPending;

  List<AktivitasTerkini> aktivitasList = [];
  bool isLoadingAktivitas = true;
  String? errorAktivitas;

  @override
  void initState() {
    super.initState();
    loadJumlahMahasiswa();
    loadJumlahPending();
    loadAktivitasTerkini();
  }

  void loadJumlahMahasiswa() async {
    try {
      final service = JumlahMahasiswaDibimbingService();
      final result = await service.getJumlahMahasiswaDibimbing();

      setState(() {
        jumlahMahasiswa = result;
        isLoadingJumlah = false;
      });
    } catch (e) {
      setState(() {
        errorJumlah = e.toString();
        isLoadingJumlah = false;
      });
      print('Error loading jumlah mahasiswa: $e');
    }
  }

  void loadJumlahPending() async {
    try {
      final service = JumlahPendingReviewService();
      final result = await service.getJumlahPendingReview();

      setState(() {
        jumlahPending = result;
        isLoadingPending = false;
      });
    } catch (e) {
      setState(() {
        errorPending = e.toString();
        isLoadingPending = false;
      });
      print('Error loading jumlah pending: $e');
    }
  }

  void loadAktivitasTerkini() async {
    try {
      final service = AktivitasTerkiniService();
      final result = await service.getAktivitasTerkini();

      setState(() {
        aktivitasList = result;
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

  IconData getIconByType(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'progress':
        return Icons.assignment_turned_in;
      case 'jadwal':
        return Icons.calendar_today;
      default:
        return Icons.circle_notifications;
    }
  }

  Color getIconColorByType(String iconType) {
    switch (iconType.toLowerCase()) {
      case 'progress':
        return Colors.green;
      case 'jadwal':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String formatTanggal(DateTime tanggal) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return '${tanggal.day} ${months[tanggal.month]} ${tanggal.year}';
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
                            "Selamat Datang!",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            "Kelola mahasiswa bimbingan Anda",
                            style: TextStyle(
                                fontFamily: 'Poppins'
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, '/dosen/mahasiswa');
                                    },
                                    child: Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Total Mahasiswa",
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              isLoadingJumlah
                                                  ? SizedBox(
                                                height: 32,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                          Color(0xFF1AAB40)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : errorJumlah != null
                                                  ? Text(
                                                "-",
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25,
                                                    color: Colors.red
                                                ),
                                              )
                                                  : Text(
                                                "$jumlahMahasiswa",
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25,
                                                    color: Color(0xFF1AAB40)
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              const Text(
                                                "Aktif bimbingan",
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
                                  )
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, '/form-offline');
                                    },
                                    child: Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Pending Review",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              isLoadingPending
                                                  ? SizedBox(
                                                height: 32,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                          Color(0xFF1AAB40)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : errorPending != null
                                                  ? Text(
                                                "-",
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25,
                                                    color: Colors.red
                                                ),
                                              ) :
                                              Text(
                                                "${jumlahPending}",
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25,
                                                    color: Color(0xFFEDB91C)
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              const Text(
                                                "Butuh perhatian",
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
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Aksi Cepat",
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, '/dosen/mahasiswaprogress');
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
                                                    fontSize: 13
                                                ),
                                              ),
                                              const Text(
                                                "Review submission mahasiswa",
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
                                  )
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    onTap: (){
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
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              const Text(
                                                "Kelola jadwal bimbingan",
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
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, '/dosen/kalender');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text(
                                          "Lihat dan tambah daftar kegiatan",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),

                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Aktivitas Terkini (${isLoadingAktivitas ? '...' : aktivitasList.length})",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              if (isLoadingAktivitas)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF1AAB40)
                                      ),
                                    ),
                                  ),
                                ),

                              if (!isLoadingAktivitas && errorAktivitas != null)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 48,
                                          color: Colors.red,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Gagal memuat aktivitas',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: loadAktivitasTerkini,
                                          child: Text('Coba Lagi'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (!isLoadingAktivitas && errorAktivitas == null && aktivitasList.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Belum ada aktivitas',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (!isLoadingAktivitas && errorAktivitas == null && aktivitasList.isNotEmpty)
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  itemCount: aktivitasList.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final item = aktivitasList[index];
                                    final iconData = getIconByType(item.icon);
                                    final iconColor = getIconColorByType(item.icon);

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
                                            if (item.progressId != null) {
                                              print('Navigate to progress: ${item.progressId}');
                                            } else if (item.bimbinganId != null) {
                                              print('Navigate to jadwal: ${item.bimbinganId}');
                                            }
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
                                                        iconColor.withOpacity(0.8),
                                                        iconColor,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    borderRadius: BorderRadius.circular(12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: iconColor.withOpacity(0.3),
                                                        spreadRadius: 0,
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Icon(
                                                    iconData,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),

                                                const SizedBox(width: 10),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.nama,
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
                                                            formatTanggal(item.tanggal),
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
                        ],
                      ),
                    )
                ),
              )
          ),
          DosenBottombarLayout(initialIndex: 0)
        ],
      ),
    );
  }
}