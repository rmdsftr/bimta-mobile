import 'package:bimta/widgets/custom_bottombar.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget{
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg-landing.png",
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottombar(),
          ),
        ],
      )
    );
  }
}