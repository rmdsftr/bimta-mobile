import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_progress.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/get_progress.dart';
import 'package:bimta/services/progress/show_progress.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int currentIndex = 0;
  final ProgressService _progressService = ProgressService();

  List<ProgressModel> allProgressData = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _progressService.getAllProgressOnline();
      setState(() {
        allProgressData = data;
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
        return 'unread';
      case 1:
        return 'read';
      case 2:
        return 'need_revision';
      case 3:
        return 'approved';
      default:
        return 'unread';
    }
  }

  List<ProgressModel> getFilteredData() {
    String selectedStatus = getStatusFromIndex(currentIndex);
    return allProgressData.where((data) => data.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<ProgressModel> filteredData = getFilteredData();

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
              child: RefreshIndicator(
                onRefresh: _loadProgressData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Bimbingan secara online, kelola dan tambah bimbingan online Anda!",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Subnav(
                          items: const [
                            Text("Unread"),
                            Text("Read"),
                            Text("Revisi"),
                            Text("Approved")
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
                            Navigator.pushNamed(context, '/form-online');
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
                                  "Tambah Bimbingan Online",
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
                        if (isLoading)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: const CircularProgressIndicator(),
                          )
                        else if (errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: Colors.red[400],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.red[600],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: _loadProgressData,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          )
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
                          else
                            Column(
                              children: filteredData.map((data) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: CardProgress(
                                    judul: data.judul,
                                    tanggal: data.tanggal,
                                    jam: data.jam,
                                    namaFile: data.namaFile,
                                    pesan: data.pesan,
                                    status: data.status,
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
          const BottombarLayout(initialIndex: 1),
        ],
      ),
    );
  }
}