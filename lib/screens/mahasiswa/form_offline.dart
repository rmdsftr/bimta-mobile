import 'package:bimta/models/add_ajukan_jadwal.dart';
import 'package:bimta/services/jadwal/add_ajukan_jadwal.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/custom_alert.dart';
import 'package:bimta/widgets/input_datetime.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormOfflineScreen extends StatefulWidget {
  const FormOfflineScreen({super.key});

  @override
  State<FormOfflineScreen> createState() => _FormOfflineState();
}

class _FormOfflineState extends State<FormOfflineScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final JadwalService _jadwalService = JadwalService();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

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
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Form Bimbingan Offline",
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
              padding: const EdgeInsets.only(top: 100),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Ajukan janji temu dengan dosen pembimbingmu. Pastikan jadwal yang kamu ajukan tidak bentrok dengan jadwal beliau ya!",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Judul pertemuan",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: _judulController,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Ex: Membahas revisi BAB III",
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
                                      borderSide: BorderSide(
                                          color: Colors.black12, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF74ADDF),
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Judul pertemuan harus diisi';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                DateInputWidget(
                                  label: "Tanggal",
                                  hintText: "Pilih tanggal bimbingan",
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2026, 12, 31),
                                  onDateSelected: (date) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                TimeInputWidget(
                                  label: "Waktu",
                                  hintText: "Pilih waktu acara",
                                  initialTime: TimeOfDay(hour: 9, minute: 0),
                                  onTimeSelected: (time) {
                                    setState(() {
                                      selectedTime = time;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Lokasi",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: _locationController,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Ex: Ruang Dosen",
                                    hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Colors.black38),
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                      size: 23,
                                      color: Colors.deepPurple,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.black12, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF74ADDF),
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Lokasi harus diisi';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Pesan untuk dosen pembimbing",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: _messageController,
                                  maxLines: 5,
                                  minLines: 3,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Tulis sesuatu di sini...",
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
                                      borderSide: BorderSide(
                                          color: Colors.black12, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF74ADDF),
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pesan harus diisi';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF677BE6),
                                          Color(0xFF754EA6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Text(
                                        "Ajukan Bimbingan Offline",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      CustomDialog.showWarning(
        context: context,
        message: 'Tanggal harus dipilih',
      );
      return;
    }

    if (selectedTime == null) {
      CustomDialog.showWarning(
        context: context,
        message: 'Waktu harus dipilih',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final tanggal = DateFormat('yyyy-MM-dd').format(selectedDate!);
      final waktu = '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00';

      final request = AddJadwalRequest(
        judul: _judulController.text.trim(),
        tanggal: tanggal,
        waktu: waktu,
        lokasi: _locationController.text.trim(),
        pesan: _messageController.text.trim(),
      );

      final response = await _jadwalService.addJadwal(request);

      if (mounted) {
        CustomDialog.showSuccess(
          context: context,
          message: 'Berhasil mengajukan bimbingan offline! ${response.count} jadwal telah dibuat.',
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showError(
          context: context,
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _locationController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}