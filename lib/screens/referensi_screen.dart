import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_referensi.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/referensi.dart';
import 'package:bimta/screens/preview_pdf.dart';
import 'package:bimta/services/general/referensi.dart';
import 'package:bimta/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReferensiTAScreen extends StatefulWidget {
  const ReferensiTAScreen({super.key});

  @override
  State<ReferensiTAScreen> createState() => _ReferensiState();
}

class _ReferensiState extends State<ReferensiTAScreen> {
  final GeneralService _generalService = GeneralService();
  List<ReferensiTa> allReferensi = [];
  List<ReferensiTa> filteredReferensi = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReferensi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReferensi() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final referensi = await _generalService.getReferensiTa();
      setState(() {
        allReferensi = referensi;
        filteredReferensi = referensi;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _filterReferensi(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredReferensi = allReferensi;
      });
    } else {
      setState(() {
        filteredReferensi = allReferensi.where((referensi) {
          final judulLower = referensi.judul.toLowerCase();
          final namaLower = referensi.namaMahasiswa.toLowerCase();
          final searchLower = query.toLowerCase();
          return judulLower.contains(searchLower) ||
              namaLower.contains(searchLower);
        }).toList();
      });
    }
  }

  void _openPdfPreview(ReferensiTa referensi) {
    if (referensi.docUrl == null || referensi.docUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Dokumen tidak tersedia',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          fileUrl: referensi.docUrl!,
          fileName: '${referensi.judul}.pdf',
        ),
      ),
    );
  }

  Future<void> _downloadPdf(ReferensiTa referensi) async {
    if (referensi.docUrl == null || referensi.docUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Dokumen tidak tersedia',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Izin penyimpanan diperlukan untuk download',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Color(0xFF74ADDF)),
              SizedBox(width: 20),
              Text(
                'Mengunduh...',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ],
          ),
        ),
      );

      // Download file
      final response = await http.get(Uri.parse(referensi.docUrl!));

      if (response.statusCode == 200) {
        // Get Downloads directory
        Directory? directory;
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        // Create file name
        final fileName = '${referensi.judul}_${referensi.tahun}.pdf';
        final filePath = '${directory!.path}/$fileName';
        final file = File(filePath);

        // Write file
        await file.writeAsBytes(response.bodyBytes);

        // Close loading dialog
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File berhasil diunduh ke: ${directory.path}',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        throw Exception('Gagal mengunduh file');
      }
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengunduh: ${e.toString()}',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              leading: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
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
                        controller: _searchController,
                        onChanged: _filterReferensi,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Cari berdasarkan judul atau nama",
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
                      const SizedBox(height: 20),

                      // Loading State
                      if (isLoading)
                        Container(
                          padding: const EdgeInsets.all(40),
                          child: const CircularProgressIndicator(
                            color: Color(0xFF74ADDF),
                          ),
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
                                color: Colors.red[400],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _loadReferensi,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF74ADDF),
                                ),
                                child: const Text(
                                  "Coba Lagi",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )

                      // Empty State
                      else if (filteredReferensi.isEmpty)
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
                                  _searchController.text.isEmpty
                                      ? "Belum ada data"
                                      : "Tidak ada hasil pencarian",
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
                            children: filteredReferensi.map((data) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: CardReferensi(
                                  nama: data.namaMahasiswa,
                                  nim: data.nimMahasiswa,
                                  topik: data.topik,
                                  judul: data.judul,
                                  tahun: data.tahun.toString(),
                                  docUrl: data.docUrl,
                                  onPreview: () => _openPdfPreview(data),
                                  onDownload: () => _downloadPdf(data),
                                ),
                              );
                            }).toList(),
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