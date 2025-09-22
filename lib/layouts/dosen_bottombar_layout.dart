import 'package:bimta/widgets/custom_bottombar.dart';
import 'package:bimta/widgets/dosen_bottombar.dart';
import 'package:flutter/material.dart';

class DosenBottombarLayout extends StatefulWidget {
  final int? initialIndex;

  const DosenBottombarLayout({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<DosenBottombarLayout> createState() => _DosenBottombarLayoutState();
}

class _DosenBottombarLayoutState extends State<DosenBottombarLayout> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex ?? _getIndexFromCurrentRoute();
  }

  int _getIndexFromCurrentRoute() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    switch (currentRoute) {
      case '/dosen/home':
        return 0;
      case '/dosen/progress':
        return 1;
      case '/dosen/jadwal':
        return 2;
      case '/dosen/mahasiswa':
        return 3;
      default:
        return 0;
    }
  }

  void _onTabTapped(int index) {
    if (selectedIndex == index) return;

    setState(() {
      selectedIndex = index;
    });

    String? currentRoute = ModalRoute.of(context)?.settings.name;
    String targetRoute;

    switch (index) {
      case 0:
        targetRoute = '/dosen/home';
        break;
      case 1:
        targetRoute = '/dosen/progress';
        break;
      case 2:
        targetRoute = '/dosen/jadwal';
        break;
      case 3:
        targetRoute = '/dosen/mahasiswa';
        break;
      default:
        targetRoute = '/dosen/home';
    }

    if (currentRoute != targetRoute) {
      Navigator.pushReplacementNamed(context, targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: DosenBottombar(
        selectedIndex: selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}