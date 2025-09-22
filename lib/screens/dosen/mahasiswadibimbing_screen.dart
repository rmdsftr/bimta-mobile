import 'package:bimta/layouts/bottombar_layout.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/layouts/dosen_bottombar_layout.dart';
import 'package:bimta/widgets/background.dart';
import 'package:flutter/material.dart';

class MahasiswaDibimbingScreen extends StatefulWidget{
  const MahasiswaDibimbingScreen({super.key});

  @override
  State<MahasiswaDibimbingScreen> createState() => _MahasiswaDibimbingState();
}

class _MahasiswaDibimbingState extends State<MahasiswaDibimbingScreen>{
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
          const DosenBottombarLayout(initialIndex: 3)
        ],
      ),
    );
  }
}