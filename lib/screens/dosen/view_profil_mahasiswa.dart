import 'package:bimta/layouts/card_riwayat.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/view_profil_mahasiswa.dart';
import 'package:bimta/services/profile/view_profil_mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/logo_corner.dart';

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

class ViewProfileMahasiswaScreen extends StatefulWidget {
  final String mahasiswaId;

  const ViewProfileMahasiswaScreen({
    Key? key,
    required this.mahasiswaId,
  }) : super(key: key);

  @override
  State<ViewProfileMahasiswaScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileMahasiswaScreen> {
  final ProfileMahasiswaService _profileService = ProfileMahasiswaService();

  ProfileMahasiswa? _profileData;
  bool _isLoading = true;
  String? _errorMessage;

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
  ];

  late List<RiwayatBimbingan> _filteredData;

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_dummyData);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = await _profileService.getProfileMahasiswa(widget.mahasiswaId);
      setState(() {
        _profileData = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _hapusDariBimbingan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus mahasiswa ini dari bimbingan?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mahasiswa dihapus dari bimbingan'),
                  ),
                );
              },
              child: const Text(
                'Hapus',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _bimbinganSelesai() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          content: const Text(
            'Apakah Anda yakin bimbingan mahasiswa ini sudah selesai?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bimbingan mahasiswa selesai'),
                  ),
                );
              },
              child: const Text(
                'Selesai',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Terjadi kesalahan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProfileData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF677BE6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Coba Lagi',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                ],
              ),
            ),
          ),
          if (_isLoading)
            _buildLoadingState()
          else if (_errorMessage != null)
            _buildErrorState()
          else
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Card Profile
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFfff2cb),
                                Colors.white,
                                Color(0xFFC6E2CB),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        image: const DecorationImage(
                                          image: AssetImage("assets/images/avatar.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _profileData?.nama ?? '-',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            _profileData?.userId ?? '-',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      _profileData?.judul ?? 'Judul belum ditentukan',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: const [
                                      Text(
                                        "2",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        "Bimbingan",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        "Offline",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: const [
                                      Text(
                                        "1",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        "Bimbingan",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        "Online",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _hapusDariBimbingan,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red, width: 1.5),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Hapus dari bimbingan',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _bimbinganSelesai,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green, width: 1.5),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Bimbingan selesai',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Riwayat bimbingan",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        _filteredData.isEmpty
                            ? const Column(
                          children: [
                            SizedBox(height: 20),
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
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}