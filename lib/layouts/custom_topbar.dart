import 'package:flutter/material.dart';
import 'package:bimta/widgets/photo_corner.dart';

class CustomTopbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTopbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      height: preferredSize.height,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/bimta.png",
            height: 40,
            width: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                        Icons.notifications,
                        color: Color(0xFF4D81E7),
                        size: 30,
                    ),
                    SizedBox(width: 10),
                    PhotoCorner(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
