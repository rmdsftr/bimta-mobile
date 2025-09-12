import 'package:flutter/material.dart';
import 'dart:math' as math;

class LandingScreen extends StatelessWidget{
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg-landing.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 0),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "BIMTA",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27,
                                    color: Color(0xFF6E8AFC)
                                  ),
                              ),
                              Transform.rotate(
                                angle: 0,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/logo-bimta.png"),
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                          SizedBox(height: 15),
                          Column(
                            children: [
                              Text(
                                  "Partner Digital \nBimbingan Tugas Akhir",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF407549),
                                  ),
                              ),
                              SizedBox(height: 7),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    "Mulai konsultasi, pantau progress, dan selesaikan tugas akhirmu",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                      color: Color(0xFF6F6F6F)
                                    ),
                                  ),
                              )
                            ],
                          )
                        ],
                      ),
                      ElevatedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Color(0xFF74ADDF)
                          ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              "Get Started",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_circle_right,
                              color: Colors.white,
                              size: 25,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
              )
          )
        ],
      ),
    );
  }
}