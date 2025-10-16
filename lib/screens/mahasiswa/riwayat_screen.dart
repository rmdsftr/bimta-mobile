import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_riwayat.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/riwayat_mahasiswa.dart';
import 'package:bimta/services/riwayat_mahasiswa.dart';
import 'package:bimta/widgets/background.dart';
import 'package:flutter/material.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RiwayatService _riwayatService = RiwayatService();

  late Future<List<RiwayatBimbinganModel>> _riwayatFuture;
  List<RiwayatBimbinganModel> _filteredData = [];
  List<RiwayatBimbinganModel> _allData = [];

  @override
  void initState() {
    super.initState();
    _riwayatFuture = _riwayatService.getRiwayatBimbingan();
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterData);
    _searchController.dispose();
    super.dispose();
  }

  void _filterData() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _allData.where((item) {
        return item.pembahasan.toLowerCase().contains(query) ||
            item.hasil.toLowerCase().contains(query) ||
            item.displayTopik.toLowerCase().contains(query) ||
            item.formattedTanggal.toLowerCase().contains(query);
      }).toList();
    });
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
              leading: const Text(
                "Riwayat Bimbingan",
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Cari riwayat bimbingan",
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
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<RiwayatBimbinganModel>>(
                      future: _riwayatFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF74ADDF),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: Colors.red[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Terjadi Kesalahan',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[300],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(
                                    snapshot.error.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _riwayatFuture =
                                          _riwayatService.getRiwayatBimbingan();
                                    });
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Coba Lagi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF74ADDF),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 60,
                                  color: Colors.black26,
                                ),
                                SizedBox(height: 16),
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
                            ),
                          );
                        }

                        // Initialize filtered data after getting data
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_allData.isEmpty) {
                            setState(() {
                              _allData = snapshot.data!;
                              _filteredData = _allData;
                            });
                          }
                        });

                        // If search is active, use filtered data, otherwise use all data
                        final dataToDisplay = _searchController.text.isEmpty
                            ? _allData
                            : _filteredData;

                        if (dataToDisplay.isEmpty && _searchController.text.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Tidak ada hasil pencarian",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: dataToDisplay.length,
                          itemBuilder: (context, index) {
                            final item = dataToDisplay[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ExpandableCard(
                                topik: item.displayTopik,
                                tanggal: item.formattedTanggal,
                                pembahasan: item.pembahasan,
                                hasil: item.hasil,
                                icon: item.icon,
                                color: item.color,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BottombarLayout(initialIndex: 3),
        ],
      ),
    );
  }
}