import 'package:bimta/models/view_jadwal_dosen_pov.dart';
import 'package:bimta/services/jadwal/response_jadwal.dart';
import 'package:bimta/services/jadwal/view_jadwal_dosen_pov.dart';
import 'package:bimta/widgets/action_buttons.dart';
import 'package:bimta/widgets/custom_alert.dart';
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
  final JadwalService _jadwalService = JadwalService();
  final JadwalResponseService _jadwalResponseService = JadwalResponseService();

  List<JadwalBimbingan> _allJadwal = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadJadwalData();
  }

  Future<void> _loadJadwalData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final jadwalList = await _jadwalService.getJadwalDosen();
      setState(() {
        _allJadwal = jadwalList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

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

  Future<void> _handleAcceptReject({
    required String bimbinganId,
    required DateTime datetime,
    required bool isAccepted,
    String? message,
  }) async {
    try {
      if (isAccepted) {
        await _jadwalResponseService.acceptBimbingan(
          bimbinganId: bimbinganId,
          datetime: datetime,
          message: message,
        );
      } else {
        await _jadwalResponseService.rejectBimbingan(
          bimbinganId: bimbinganId,
          datetime: datetime,
          message: message,
        );
      }

      // Reload data setelah berhasil
      await _loadJadwalData();

      if (mounted) {
        if (isAccepted) {
          CustomDialog.showSuccess(
            context: context,
            title: 'Berhasil!',
            message: 'Bimbingan berhasil diterima',
            buttonText: 'OK',
          );
        } else {
          CustomDialog.showSuccess(
            context: context,
            title: 'Berhasil!',
            message: 'Bimbingan berhasil ditolak',
            buttonText: 'OK',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showError(
          context: context,
          title: 'Gagal!',
          message: e.toString().replaceAll('Exception: ', ''),
          buttonText: 'Tutup',
        );
      }
    }
  }

  Future<void> _handleCancelDone({
    required String bimbinganId,
    required DateTime datetime,
    required bool isDone,
    String? message,
  }) async {
    try {
      if (isDone) {
        await _jadwalResponseService.doneBimbingan(
          bimbinganId: bimbinganId,
          datetime: datetime,
          message: message,
        );
      } else {
        await _jadwalResponseService.cancelBimbingan(
          bimbinganId: bimbinganId,
          datetime: datetime,
          message: message,
        );
      }

      await _loadJadwalData();

      if (mounted) {
        if (isDone) {
          CustomDialog.showSuccess(
            context: context,
            title: 'Berhasil!',
            message: 'Bimbingan telah selesai',
            buttonText: 'OK',
          );
        } else {
          CustomDialog.showSuccess(
            context: context,
            title: 'Berhasil!',
            message: 'Bimbingan telah dibatalkan',
            buttonText: 'OK',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showError(
          context: context,
          title: 'Gagal!',
          message: e.toString().replaceAll('Exception: ', ''),
          buttonText: 'Tutup',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _allJadwal
        .where((bimbingan) => bimbingan.status == getStatusFromIndex(selectedIndex))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundWidget(),

          // Custom Topbar
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

          // Konten utama
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              child: RefreshIndicator(
                onRefresh: _loadJadwalData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pantau dan kelola bimbingan offline mahasiswa Anda di sini!",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Subnav
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

                        // Loading State
                        if (_isLoading)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )

                        // Error State
                        else if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: Colors.red[300],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.red[700],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton.icon(
                                  onPressed: _loadJadwalData,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Coba Lagi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )

                        // Empty State
                        else if (filteredList.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              ),
                            )

                          // Data List
                          else
                            Column(
                              children: filteredList.map((bimbingan) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: CardBimbinganOffline(
                                    nama: bimbingan.nama,
                                    nim: bimbingan.nim,
                                    photoUrl: bimbingan.photo_url,
                                    tanggal: bimbingan.formattedTanggal,
                                    waktu: bimbingan.waktu,
                                    lokasi: bimbingan.lokasi,
                                    judul: bimbingan.topik,
                                    pesan: bimbingan.pesan,
                                    status: bimbingan.status,
                                    pesanDosen: bimbingan.pesanDosen,
                                    onAccept: (message) async {
                                      await _handleAcceptReject(
                                        bimbinganId: bimbingan.bimbinganId,
                                        datetime: bimbingan.datetime,
                                        isAccepted: true,
                                        message: message,
                                      );
                                    },
                                    onReject: (message) async {
                                      await _handleAcceptReject(
                                        bimbinganId: bimbingan.bimbinganId,
                                        datetime: bimbingan.datetime,
                                        isAccepted: false,
                                        message: message,
                                      );
                                    },
                                    onCancel: (message) async {
                                      await _handleCancelDone(
                                        bimbinganId: bimbingan.bimbinganId,
                                        datetime: bimbingan.datetime,
                                        isDone: false,
                                        message: message,
                                      );
                                    },
                                    onDone: (message) async {
                                      await _handleCancelDone(
                                        bimbinganId: bimbingan.bimbinganId,
                                        datetime: bimbingan.datetime,
                                        isDone: true,
                                        message: message,
                                      );
                                    },
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
          ),

          // Bottom bar
          const DosenBottombarLayout(initialIndex: 2),
        ],
      ),
    );
  }
}