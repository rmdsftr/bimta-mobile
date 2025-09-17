import 'package:flutter/material.dart';

class PhotoCorner extends StatelessWidget{
  const PhotoCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: DecorationImage(
            image: AssetImage("assets/images/avatar.png"),
            fit: BoxFit.cover
        )
      ),
    );
  }
}