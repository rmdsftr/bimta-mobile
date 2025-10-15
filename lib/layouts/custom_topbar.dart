import 'package:flutter/material.dart';
import 'package:bimta/widgets/photo_corner.dart';
import 'package:bimta/screens/notifikasi_screen.dart';

class CustomTopbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;

  const CustomTopbar({
    Key? key,
    required this.leading,
  }) : super(key: key);

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
          leading,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ Bungkus icon notifikasi dengan GestureDetector
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotifikasiScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFF4D81E7),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const PhotoCorner(),
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
