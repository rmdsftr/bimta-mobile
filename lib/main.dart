import 'package:bimta/screens/dosen/home_screen.dart';
import 'package:bimta/screens/dosen/mahasiswadibimbing_screen.dart';
import 'package:bimta/screens/landing_screen.dart';
import 'package:bimta/screens/login_screen.dart';
import 'package:bimta/screens/mahasiswa/form_offline.dart';
import 'package:bimta/screens/mahasiswa/form_online.dart';
import 'package:bimta/screens/mahasiswa/home_screen.dart';
import 'package:bimta/screens/mahasiswa/jadwal_screen.dart';
import 'package:bimta/screens/profile_screen.dart';
import 'package:bimta/screens/mahasiswa/progress_screen.dart';
import 'package:bimta/screens/mahasiswa/riwayat_screen.dart';
import 'package:bimta/screens/referensi_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingScreen(),
      routes: {
        '/login' : (context) => LoginScreen(),
        '/home' : (context) => Homescreen(),
        '/progress' : (context) => ProgressScreen(),
        '/referensi' : (context) => ReferensiTAScreen(),
        '/form-online' : (context) => FormOnlineScreen(),
        '/form-offline' : (context) => FormOfflineScreen(),
        '/jadwal' : (context) => JadwalScreen(),
        '/riwayat' : (context) => RiwayatScreen(),
        '/profil' : (context) => ProfileScreen(),
        '/dosen/home' : (context) => Dosen_Homescreen(),
        '/dosen/mahasiswa' : (context) => MahasiswaDibimbingScreen()
      },
    );
  }
}

