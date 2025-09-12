import 'package:flutter/material.dart';

class CustomBottombar extends StatelessWidget{
  const CustomBottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
              child: SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/icons/house.png",
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Home",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/icons/progress.png",
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Progress",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/icons/calendar.png",
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Jadwal",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/icons/clock-time.png",
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Riwayat",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
          )
        )
    );
  }
}