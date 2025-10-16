import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/add_jadwal_dosen.dart';
import 'package:bimta/services/jadwal/add_jadwal_dosen.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/custom_alert.dart';
import 'package:bimta/widgets/input_datetime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalDosenScreen extends StatefulWidget {
  const JadwalDosenScreen({Key? key}) : super(key: key);

  @override
  State<JadwalDosenScreen> createState() => _JadwalDosenScreenState();
}

class _JadwalDosenScreenState extends State<JadwalDosenScreen> {
  DateTime selectedDate = DateTime.now();
  final KegiatanService _kegiatanService = KegiatanService();
  List<Kegiatan> selectedDateEvents = [];
  bool isLoading = false;

  List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _loadKegiatanByDate(selectedDate);
  }

  Future<void> _loadKegiatanByDate(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    try {
      final kegiatan = await _kegiatanService.getKegiatanByDate(date);

      // Filter kegiatan yang benar-benar untuk tanggal yang dipilih
      final filteredKegiatan = kegiatan.where((k) {
        return k.tanggal.year == date.year &&
            k.tanggal.month == date.month &&
            k.tanggal.day == date.day;
      }).toList();

      setState(() {
        selectedDateEvents = filteredKegiatan;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        CustomDialog.showError(
          context: context,
          message: 'Terjadi kesalahan saat memuat data kegiatan',
        );
      }
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _loadKegiatanByDate(date);
  }

  void _showDeleteConfirmation(Kegiatan kegiatan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Hapus Kegiatan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus kegiatan "${kegiatan.kegiatan}"?',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog konfirmasi
              await _deleteKegiatan(kegiatan.jadwalDosenId);
            },
            child: Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteKegiatan(String jadwalDosenId) async {
    setState(() {
      isLoading = true;
    });

    try {
      await _kegiatanService.deleteKegiatan(jadwalDosenId);

      // Reload data setelah berhasil dihapus
      await _loadKegiatanByDate(selectedDate);

      if (mounted) {
        CustomDialog.showSuccess(
          context: context,
          message: 'Kegiatan berhasil dihapus',
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        CustomDialog.showError(
          context: context,
          message: 'Gagal menghapus kegiatan. Silakan coba lagi',
        );
      }
    }
  }

  void _showAddEventDialog() {
    final TextEditingController kegiatanController = TextEditingController();
    // Inisialisasi dengan nilai default, bukan null
    TimeOfDay? jamMulai = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay? jamSelesai = TimeOfDay(hour: 10, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama Kegiatan",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: kegiatanController,
                      maxLines: 5,
                      minLines: 3,
                      decoration: InputDecoration(
                        hintText: "Deskripsikan kegiatan Anda",
                        hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.black38),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black12, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF74ADDF),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TimeInputWidget(
                      label: "Mulai",
                      hintText: "Pilih waktu mulai",
                      initialTime: TimeOfDay(hour: 9, minute: 0),
                      onTimeSelected: (time) {
                        setDialogState(() {
                          jamMulai = time;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TimeInputWidget(
                      label: "Selesai",
                      hintText: "Pilih waktu selesai",
                      initialTime: TimeOfDay(hour: 10, minute: 0),
                      onTimeSelected: (time) {
                        setDialogState(() {
                          jamSelesai = time;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Batal',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (kegiatanController.text.isEmpty) {
                    CustomDialog.showWarning(
                      context: context,
                      message: 'Nama kegiatan tidak boleh kosong',
                    );
                    return;
                  }

                  if (jamMulai == null || jamSelesai == null) {
                    CustomDialog.showWarning(
                      context: context,
                      message: 'Silakan pilih waktu mulai dan selesai',
                    );
                    return;
                  }

                  try {
                    final request = AddKegiatanRequest(
                      kegiatan: kegiatanController.text,
                      tanggal: DateFormat('yyyy-MM-dd').format(selectedDate),
                      jamMulai: '${jamMulai!.hour.toString().padLeft(2, '0')}:${jamMulai!.minute.toString().padLeft(2, '0')}',
                      jamSelesai: '${jamSelesai!.hour.toString().padLeft(2, '0')}:${jamSelesai!.minute.toString().padLeft(2, '0')}',
                    );

                    await _kegiatanService.addKegiatan(request);

                    // Tutup dialog form terlebih dahulu
                    Navigator.pop(context);

                    // Reload data
                    await _loadKegiatanByDate(selectedDate);

                    // Tampilkan success dialog
                    CustomDialog.showSuccess(
                      context: context,
                      message: 'Kegiatan berhasil ditambahkan ke jadwal',
                      onPressed: () {
                        // Hanya tutup dialog success
                        Navigator.pop(context);
                      },
                    );
                  } catch (e) {
                    CustomDialog.showError(
                      context: context,
                      message: 'Gagal menambahkan kegiatan. Silakan coba lagi',
                    );
                  }
                },
                child: Text(
                  'Simpan',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime>[];

    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }

    return days;
  }

  int _getStartingWeekday(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    return firstDay.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(selectedDate);
    final startingWeekday = _getStartingWeekday(selectedDate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BackgroundWidget(),
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
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Jadwal Dosen",
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
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 75, right: 16, left: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(selectedDate),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.chevron_left, size: 24),
                                    onPressed: () {
                                      setState(() {
                                        selectedDate = DateTime(
                                          selectedDate.year,
                                          selectedDate.month - 1,
                                          1,
                                        );
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.chevron_right, size: 24),
                                    onPressed: () {
                                      setState(() {
                                        selectedDate = DateTime(
                                          selectedDate.year,
                                          selectedDate.month + 1,
                                          1,
                                        );
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: dayNames
                                .map((day) => SizedBox(
                              width: 32,
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            flex: 1,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1,
                              ),
                              itemCount: daysInMonth.length + startingWeekday,
                              itemBuilder: (context, index) {
                                if (index < startingWeekday) {
                                  return SizedBox();
                                }

                                final dayIndex = index - startingWeekday;
                                final date = daysInMonth[dayIndex];
                                final isSelected = date.day == selectedDate.day &&
                                    date.month == selectedDate.month &&
                                    date.year == selectedDate.year;

                                return GestureDetector(
                                  onTap: () => _selectDate(date),
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${date.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Upcoming events',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            flex: 1,
                            child: isLoading
                                ? Center(
                              child: CircularProgressIndicator(),
                            )
                                : selectedDateEvents.isEmpty
                                ? Center(
                              child: Text(
                                'Tidak ada kegiatan',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            )
                                : ListView.builder(
                              itemCount: selectedDateEvents.length,
                              itemBuilder: (context, index) {
                                final kegiatan = selectedDateEvents[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              kegiatan.kegiatan,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              kegiatan.timeRange,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                        onPressed: () => _showDeleteConfirmation(kegiatan),
                                        padding: EdgeInsets.all(8),
                                        constraints: BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: _showAddEventDialog,
                              child: Container(
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
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Text(
                                      'Tambah Kegiatan',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}