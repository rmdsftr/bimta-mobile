import 'package:flutter/material.dart';

class DosenBottombar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const DosenBottombar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? const Color(0xFF4D81E7) : Colors.black54,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? const Color(0xFF4D81E7) : Colors.black54,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavItem(icon: Icons.home, label: "Home", index: 0),
              buildNavItem(icon: Icons.bar_chart, label: "Progress", index: 1),
              buildNavItem(icon: Icons.calendar_today, label: "Jadwal", index: 2),
              buildNavItem(icon: Icons.history, label: "Mahasiswa", index: 3),
            ],
          ),
        ),
      ),
    );
  }
}
