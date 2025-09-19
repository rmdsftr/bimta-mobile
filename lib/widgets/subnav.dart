import 'package:flutter/material.dart';

class Subnav extends StatelessWidget {
  final List<Widget> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const Subnav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          bool isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF74ADDF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12
                    ),
                    child: items[index],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
