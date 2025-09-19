import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget{
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        "assets/images/bg-landing.png",
        fit: BoxFit.cover,
      ),
    );
  }
}