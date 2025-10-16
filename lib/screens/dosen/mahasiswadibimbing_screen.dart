import 'package:bimta/layouts/add_mahasiswa_layout.dart';
import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/card_bimbingan.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/layouts/dosen_bottombar_layout.dart';
import 'package:bimta/layouts/listMahasiswa.dart';
import 'package:bimta/models/mahasiswa.dart';
import 'package:bimta/models/mahasiswa_dibimbing.dart';
import 'package:bimta/screens/dosen/view_profil_mahasiswa.dart';
import 'package:bimta/services/bimbingan/addMahasiswaBimbingan.dart';
import 'package:bimta/services/bimbingan/mahasiswaDibimbing.dart';
import 'package:bimta/services/general/mahasiswa.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/dropdown.dart';
import 'package:bimta/widgets/subnav.dart';
import 'package:flutter/material.dart';

class MahasiswaDibimbingScreen extends StatefulWidget {
  const MahasiswaDibimbingScreen({super.key});

  @override
  State<MahasiswaDibimbingScreen> createState() => _MahasiswaDibimbingState();
}

class _MahasiswaDibimbingState extends State<MahasiswaDibimbingScreen> {
  int CurrentIndex = 0;

  // Services
  final DaftarMahasiswaService _service = DaftarMahasiswaService();
  final MahasiswaDibimbingService _mahasiswaService = MahasiswaDibimbingService();
  final AddMahasiswaBimbinganService _addMahasiswaService = AddMahasiswaBimbinganService();

  // Data lists
  List<DaftarMahasiswa> newMahasiswa = [];
  List<MahasiswaDibimbing> mahasiswaDibimbing = [];
  Set<String> selectedMahasiswaIds = {};

  // Loading states
  bool isLoadingMahasiswa = false;
  bool isLoadingMahasiswaDibimbing = false;
  bool isAddingMahasiswa = false;

  // Search
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMahasiswa();
    _loadMahasiswaDibimbing();
  }

  Future<void> _loadMahasiswa() async {
    setState(() {
      isLoadingMahasiswa = true;
    });

    try {
      final data = await _service.getListMahasiswa();
      setState(() {
        newMahasiswa = data;
        isLoadingMahasiswa = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMahasiswa = false;
      });
      if (mounted) {
        _showSnackBar(
          'Gagal memuat data mahasiswa: $e',
          Colors.red,
        );
      }
    }
  }

  Future<void> _loadMahasiswaDibimbing() async {
    setState(() {
      isLoadingMahasiswaDibimbing = true;
    });

    try {
      final data = await _mahasiswaService.getMahasiswaDibimbing();
      setState(() {
        mahasiswaDibimbing = data;
        isLoadingMahasiswaDibimbing = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMahasiswaDibimbing = false;
      });
      if (mounted) {
        _showSnackBar(
          'Gagal memuat data mahasiswa dibimbing: $e',
          Colors.red,
        );
      }
    }
  }

  void _toggleMahasiswaSelection(String userId, bool? selected) {
    setState(() {
      if (selected == true) {
        selectedMahasiswaIds.add(userId);
      } else {
        selectedMahasiswaIds.remove(userId);
      }
    });
  }

  Future<void> _handleTambahMahasiswa(BuildContext dialogContext) async {
    if (selectedMahasiswaIds.isEmpty) {
      _showSnackBar(
        'Pilih minimal satu mahasiswa',
        Colors.orange,
      );
      return;
    }

    setState(() {
      isAddingMahasiswa = true;
    });

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Menambahkan mahasiswa...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      final success = await _addMahasiswaService.addMahasiswaBimbingan(
        selectedMahasiswaIds.toList(),
      );

      if (mounted) {
        Navigator.pop(context);
      }

      if (success) {
        if (mounted) {
          Navigator.pop(dialogContext);
        }

        _showSnackBar(
          'Berhasil menambahkan ${selectedMahasiswaIds.length} mahasiswa',
          Colors.green,
        );

        setState(() {
          selectedMahasiswaIds.clear();
          isAddingMahasiswa = false;
        });

        await _loadMahasiswaDibimbing();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }

      setState(() {
        isAddingMahasiswa = false;
      });

      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }

      _showSnackBar(
        'Gagal menambahkan mahasiswa: $errorMessage',
        Colors.red,
        duration: Duration(seconds: 4),
      );
    }
  }

  void _showSnackBar(String message, Color backgroundColor, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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

  List<MahasiswaDibimbing> getFilteredData() {
    String selectedStatus = getStatusFromIndex(CurrentIndex);

    var filtered = mahasiswaDibimbing.where((data) =>
    data.statusBimbingan == selectedStatus
    ).toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((data) =>
      data.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
          data.userId.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  int getCountByStatus(String status) {
    return mahasiswaDibimbing.where((data) => data.statusBimbingan == status).length;
  }

  List<DaftarMahasiswa> getAvailableMahasiswa() {
    final dibimbingIds = mahasiswaDibimbing.map((m) => m.userId).toSet();
    return newMahasiswa.where((m) => !dibimbingIds.contains(m.user_id)).toList();
  }

  void _showAddMahasiswaDialog() {
    final availableMahasiswa = getAvailableMahasiswa();

    if (availableMahasiswa.isEmpty) {
      _showSnackBar(
        'Semua mahasiswa sudah dalam bimbingan Anda',
        Colors.orange,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pilih Mahasiswa',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (selectedMahasiswaIds.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF677BE6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selectedMahasiswaIds.length} dipilih',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              content: SizedBox(
                height: 350,
                width: 700,
                child: AddMahasiswaLayout(
                  child: isLoadingMahasiswa
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : availableMahasiswa.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 60,
                          color: Colors.green[300],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Semua mahasiswa sudah dibimbing',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: availableMahasiswa.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListMahasiswa(
                          nama: data.nama,
                          nim: data.user_id,
                          isSelected: selectedMahasiswaIds.contains(data.user_id),
                          onChanged: (selected) {
                            setDialogState(() {
                              _toggleMahasiswaSelection(data.user_id, selected);
                            });
                            setState(() {});
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isAddingMahasiswa ? null : () {
                    setState(() {
                      selectedMahasiswaIds.clear();
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: isAddingMahasiswa ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (selectedMahasiswaIds.isEmpty || isAddingMahasiswa)
                      ? null
                      : () => _handleTambahMahasiswa(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF677BE6),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isAddingMahasiswa ? 'Menambahkan...' : 'Tambahkan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final List<String> listStatus = [
    'Masih berlangsung',
    'Selesai bimbingan',
  ];

  @override
  Widget build(BuildContext context) {
    List<MahasiswaDibimbing> filteredData = getFilteredData();
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
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    _loadMahasiswa(),
                    _loadMahasiswaDibimbing(),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Search field
                        TextField(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Cari berdasarkan nama atau NIM",
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black38,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
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
                        SizedBox(height: 15),

                        GestureDetector(
                          onTap: _showAddMahasiswaDialog,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF677BE6),
                                  Color(0xFF754EA6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF677BE6).withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
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
                                  ),
                                ],
                              ),
                            ),
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
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                        if (isLoadingMahasiswaDibimbing)
                          Container(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          )
                        else if (filteredData.isEmpty)
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
                                  searchQuery.isNotEmpty
                                      ? "Tidak ada hasil pencarian"
                                      : "Belum ada data",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (searchQuery.isEmpty && mahasiswaDibimbing.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "Mulai tambahkan mahasiswa bimbingan",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: filteredData.map((data) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/dosen/viewProfile',
                                    arguments: data.userId,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: CardBimbingan(
                                    nama: data.nama,
                                    nim: data.userId,
                                    judul: data.judul ?? 'Judul belum ditentukan',
                                    photoUrl: data.photo_url,
                                  ),
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
          ),
          const DosenBottombarLayout(initialIndex: 3),
        ],
      ),
    );
  }
}