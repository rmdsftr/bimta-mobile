import 'package:bimta/screens/dosen/home_screen.dart';
import 'package:bimta/screens/dosen/jadwal_dosen.dart';
import 'package:bimta/screens/dosen/mahasiswadibimbing_screen.dart';
import 'package:bimta/screens/dosen/mahasiswaprogress_screen.dart';
import 'package:bimta/screens/dosen/view_profil_mahasiswa.dart';
import 'package:bimta/screens/mahasiswa/lihat_jadwal_dosen.dart';
import 'package:bimta/screens/splash_screen.dart'; // <-- TAMBAH INI
import 'package:bimta/screens/landing_screen.dart';
import 'package:bimta/screens/login_screen.dart';
import 'package:bimta/screens/mahasiswa/form_offline.dart';
import 'package:bimta/screens/mahasiswa/form_online.dart';
import 'package:bimta/screens/mahasiswa/home_screen.dart';
import 'package:bimta/screens/mahasiswa/jadwal_screen.dart';
import 'package:bimta/screens/mahasiswa/progress_screen.dart';
import 'package:bimta/screens/mahasiswa/riwayat_screen.dart';
import 'package:bimta/screens/profile_screen.dart';
import 'package:bimta/screens/referensi_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/landing': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Homescreen(),
        '/progress': (context) => const ProgressScreen(),
        '/referensi': (context) => const ReferensiTAScreen(),
        '/form-online': (context) => const FormOnlineScreen(),
        '/form-offline': (context) => const FormOfflineScreen(),
        '/jadwal': (context) => const JadwalScreen(),
        '/riwayat': (context) => const RiwayatScreen(),
        '/kalender' : (context) => const LihatJadwalDosenScreen(),
        '/profil': (context) => const ProfileScreen(),
        '/dosen/home': (context) => const Dosen_Homescreen(),
        '/dosen/mahasiswa': (context) => const MahasiswaDibimbingScreen(),
        '/dosen/kalender' : (context) => const JadwalDosenScreen(),
        '/dosen/viewProfile': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return ViewProfileMahasiswaScreen(mahasiswaId: args);
        },
        '/dosen/mahasiswaprogress' : (context) => const MahasiswaProgressScreen()
      },
    );
  }
}