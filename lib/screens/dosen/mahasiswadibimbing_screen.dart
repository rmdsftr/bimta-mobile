import 'package:bimta/layouts/add_mahasiswa_layout.dart';
import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_bimbingan.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/layouts/dosen_bottombar_layout.dart';
import 'package:bimta/layouts/listMahasiswa.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/dropdown.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:flutter/material.dart';

class MahasiswaDibimbingScreen extends StatefulWidget{
  const MahasiswaDibimbingScreen({super.key});

  @override
  State<MahasiswaDibimbingScreen> createState() => _MahasiswaDibimbingState();
}

class _MahasiswaDibimbingState extends State<MahasiswaDibimbingScreen>{
  int CurrentIndex = 0;

  final List<Map<String, String>> listMahasiswa = [
    {
      'nama' : 'Muhammad Zaki',
      'nim' : '2211523031',
      'judul' : 'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'status' : 'ongoing'
    },
    {
      'nama' : 'Tegar Ananda',
      'nim' : '2211523011',
      'judul' : 'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'status' : 'done'
    },
    {
      'nama' : 'Talitha Zulfa Amira',
      'nim' : '2211522023',
      'judul' : 'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'status' : 'ongoing'
    },
    {
      'nama' : 'Ramadhani Safitri',
      'nim' : '2211522009',
      'judul' : 'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'status' : 'done'
    },
    {
      'nama' : 'Ari Raihan Dafa',
      'nim' : '2211523011',
      'judul' : 'Implementasi Machine Learning untuk Prediksi Harga Saham menggunakan Algoritma LSTM',
      'status' : 'ongoing'
    }
  ];

  final List<Map<String, String>> newMahasiswa = [
    {
      'nama' : 'Muhammad Zaki',
      'nim' : '2211523031',
    },
    {
      'nama' : 'Tegar Ananda',
      'nim' : '2211523011',
    },
    {
      'nama' : 'Talitha Zulfa Amira',
      'nim' : '2211522023',
    },
    {
      'nama' : 'Ramadhani Safitri',
      'nim' : '2211522009',
    },
    {
      'nama' : 'Ari Raihan Dafa',
      'nim' : '2211523011',
    }
  ];

  String getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'ongoing';
      case 1:
        return 'done';
      default:
        return 'waiting';
    }
  }

  List<Map<String, String>> getFilteredData() {
    String selectedStatus = getStatusFromIndex(CurrentIndex);
    return listMahasiswa.where((data) => data['status'] == selectedStatus).toList();
  }

  // Fungsi untuk menghitung jumlah mahasiswa per status
  int getCountByStatus(String status) {
    return listMahasiswa.where((data) => data['status'] == status).length;
  }

  final List<String> listStatus = [
    'Masih berlangsung',
    'Selesai bimbingan',
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredData = getFilteredData();
    int currentFilterCount = filteredData.length;

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
                "Mahasiswa Bimbingan",
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Cari berdasarkan nama atau NIM",
                          hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black38
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black38,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none
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
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: AddMahasiswaLayout(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: newMahasiswa.map((data) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: ListMahasiswa(
                                                  nama: data['nama']!,
                                                  nim: data['nim']!,
                                              ),
                                            );
                                          }).toList()
                                        )
                                    ),
                                  )
                                );
                              }
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
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
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Tambah Mahasiswa Bimbingan",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "$currentFilterCount",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                    Icons.person,
                                    size: 17,
                                    color: Colors.deepPurple,
                                )
                              ],
                            )
                          ),
                          // Dropdown filter
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(30),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  height: 40,
                                  child: CustomDropdown(
                                    items: listStatus,
                                    hint: 'Pilih status',
                                    selectedIndex: CurrentIndex,
                                    prefixIcon: Icons.sort,
                                    onChanged: (int index, String value) {
                                      setState(() {
                                        CurrentIndex = index;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      if(listMahasiswa.isEmpty)
                        Container(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 10),
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
                              child: CardBimbingan(
                                nama: data['nama']!,
                                nim: data['nim']!,
                                judul: data['judul']!,
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
          const DosenBottombarLayout(initialIndex: 3)
        ],
      ),
    );
  }
}