import 'package:bimta/layouts/custom_topbar.dart';
import 'package:flutter/material.dart';

class LogoCorner extends StatelessWidget{
  const LogoCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: CustomTopbar(
        leading: Image.asset(
          "assets/images/bimta.png",
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}