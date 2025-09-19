import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/input_datetime.dart';
import 'package:bimta/widgets/upload_pdf.dart';
import 'package:flutter/material.dart';

class FormOfflineScreen extends StatefulWidget{
  const FormOfflineScreen({super.key});

  @override
  State<FormOfflineScreen> createState() => _FormOfflineState();
}

class _FormOfflineState extends State<FormOfflineScreen>{
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

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
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Form Bimbingan Online",
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
                  child: Column(
                    children: [
                      Text(
                        "Upload progress Tugas Akhirmu dalam format pdf, dan pantau tanggapan dari dosen pembimbingmu pada menu progress",
                        style: TextStyle(
                            fontFamily: 'Poppins'
                        ),
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
                              DateInputWidget(
                                label: "Tanggal",
                                hintText: "Pilih tanggal acara",
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025),
                                onDateSelected: (date) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                  print('Date selected: $date'); // Debug
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
                                  print('Time selected: $time'); // Debug
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
                                    color: Colors.black
                                ),
                                decoration: InputDecoration(
                                  hintText: "Ex: Ruang Dosen",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black38
                                  ),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    size: 23,
                                    color: Colors.deepPurple,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF74ADDF),
                                      width: 1.5,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
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
                              TextField(
                                controller: _messageController,
                                maxLines: 5,
                                minLines: 3,
                                decoration: InputDecoration(
                                  hintText: "Tulis sesuatu di sini...",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black38
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.black12,
                                        width: 1
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF74ADDF),
                                      width: 1.5,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
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
                                    onPressed: () {
                                      // Debug print untuk cek data
                                      print('Form Data:');
                                      print('Date: $selectedDate');
                                      print('Time: $selectedTime');
                                      print('Location: ${_locationController.text}');
                                      print('Message: ${_messageController.text}');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Submit Progress",
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}