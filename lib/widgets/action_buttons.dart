import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final List<Widget> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ActionButtons({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    final bgColors = [
      const Color(0xFFE7EBFF),
      const Color(0xFFF5D2D5),
      const Color(0xFFFFF1E6),
    ];

    final textColors = [
      const Color(0xFF5A6ACF),
      const Color(0xFFB00C20),
      const Color(0xFFE67E22),
    ];

    return Row(
      children: List.generate(items.length, (index) {
        bool isSelected = selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: bgColors[index % bgColors.length],
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
                    : [],
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColors[index % textColors.length],
                  ),
                  child: items[index],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
