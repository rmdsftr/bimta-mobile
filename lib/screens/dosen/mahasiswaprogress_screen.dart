import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/layouts/dosen_bottombar_layout.dart';
import 'package:bimta/models/bimbingan_online_dosen.dart';
import 'package:bimta/screens/preview_pdf.dart';
import 'package:bimta/services/progress/bimbingan_online_dosen.dart';
import 'package:flutter/material.dart';
import 'package:bimta/layouts/card_bimbingan_online.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/subnav.dart';

class MahasiswaProgressScreen extends StatefulWidget {
  const MahasiswaProgressScreen({super.key});

  @override
  State<MahasiswaProgressScreen> createState() => _MahasiswaProgressScreenState();
}

class _MahasiswaProgressScreenState extends State<MahasiswaProgressScreen> {
  int selectedIndex = 0;
  final ProgressOnlineService _progressService = ProgressOnlineService();

  List<ProgressOnlineModel> allProgressList = [];
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
      final data = await _progressService.getProgressOnlineMahasiswa();
      setState(() {
        allProgressList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'unread';
      case 1:
        return 'need_revision';
      case 2:
        return 'done';
      default:
        return 'unread';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = allProgressList
        .where((progress) => progress.status == getStatusFromIndex(selectedIndex))
        .toList();

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
                "Bimbingan Online",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pantau dan kelola bimbingan online mahasiswa Anda di sini!",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Subnav(
                          items: const [
                            Text("Unread"),
                            Text("Revisi"),
                            Text("Approved"),
                          ],
                          selectedIndex: selectedIndex,
                          onChanged: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        if (isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
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
                                  "Terjadi kesalahan",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  errorMessage!,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: _loadProgressData,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          )
                        else if (filteredList.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Column(
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
                          else
                            Column(
                              children: filteredList.map((progress) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Column(
                                    children: [
                                      CardBimbinganOnline(
                                        nama: progress.nama,
                                        nim: progress.nim,
                                        judul: progress.judul,
                                        pesan: progress.pesan,
                                        namaFile: progress.fileName,
                                        status: progress.status,
                                        fileUrl: progress.fileUrl, // Tambahkan ini
                                        onPreview: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PdfPreviewScreen(
                                                fileUrl: progress.fileUrl,
                                                fileName: progress.fileName,
                                              ),
                                            ),
                                          );
                                        },
                                        onCorrection: () {
                                          Navigator.pushNamed(context, '/dosen/koreksi');
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                    ],
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
          const DosenBottombarLayout(initialIndex: 1),
        ],
      ),
    );
  }
}