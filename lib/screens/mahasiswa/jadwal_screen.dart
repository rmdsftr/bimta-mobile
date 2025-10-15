import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_jadwal.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/view_jadwal.dart';
import 'package:bimta/services/jadwal/view_jadwal.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:flutter/material.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  int currentIndex = 0;
  final JadwalService _jadwalService = JadwalService();

  List<JadwalModel> allJadwalData = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  Future<void> _loadJadwal() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final jadwalList = await _jadwalService.viewJadwal();
      setState(() {
        allJadwalData = jadwalList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
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

  List<JadwalModel> getFilteredData() {
    String selectedStatus = getStatusFromIndex(currentIndex);
    return _jadwalService.filterByStatus(allJadwalData, selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    List<JadwalModel> filteredData = getFilteredData();

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
              child: RefreshIndicator(
                onRefresh: _loadJadwal,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Bimbingan secara offline, segera ajukan dan pantau bimbingan offline Anda!",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Subnav(
                          items: const [
                            Text("Waiting"),
                            Text("Accepted"),
                            Text("Declined"),
                          ],
                          selectedIndex: currentIndex,
                          onChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/form-offline');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
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
                              children: const [
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Tambah Bimbingan Offline",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
                        const SizedBox(height: 20),

                        // Loading State
                        if (isLoading)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: const CircularProgressIndicator(),
                          )

                        // Error State
                        else if (errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: Colors.red[300],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: _loadJadwal,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Coba Lagi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF677BE6),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )

                        // Empty State
                        else if (filteredData.isEmpty)
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

                          // Data List
                          else
                            Column(
                              children: filteredData.map((jadwal) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: CardJadwal(
                                    subjek: jadwal.subjek,
                                    tanggal: jadwal.formattedTanggal,
                                    waktu: jadwal.formattedWaktu,
                                    lokasi: jadwal.lokasi,
                                    pesan: jadwal.pesan,
                                    status: jadwal.status,
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
          const BottombarLayout(initialIndex: 2),
        ],
      ),
    );
  }
}