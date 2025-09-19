import 'package:bimta/widgets/custom_bottombar.dart';
import 'package:flutter/material.dart';

class BottombarLayout extends StatefulWidget {
  final int? initialIndex;

  const BottombarLayout({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<BottombarLayout> createState() => _BottombarLayoutState();
}

class _BottombarLayoutState extends State<BottombarLayout> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex ?? _getIndexFromCurrentRoute();
  }

  int _getIndexFromCurrentRoute() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    switch (currentRoute) {
      case '/home':
        return 0;
      case '/progress':
        return 1;
      case '/jadwal':
        return 2;
      case '/riwayat':
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
        targetRoute = '/home';
        break;
      case 1:
        targetRoute = '/progress';
        break;
      case 2:
        targetRoute = '/jadwal';
        break;
      case 3:
        targetRoute = '/riwayat';
        break;
      default:
        targetRoute = '/home';
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
      child: CustomBottombar(
        selectedIndex: selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}