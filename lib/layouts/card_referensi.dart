import 'package:flutter/material.dart';

class CardReferensi extends StatelessWidget{
  final String nama;
  final String nim;
  final String topik;
  final String judul;
  final String tahun;
  
  const CardReferensi({
    super.key,
    required this.nama,
    required this.nim,
    required this.topik,
    required this.judul,
    required this.tahun
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF407549)
                ),
              ),
              SizedBox(height: 5),
              Text(
                  "$tahun | $topik",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12
                  ),
              ),
              SizedBox(height: 2),
              Text(
                  "$nim | $nama",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12
                  ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: (){},
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Color(0xFF74ADDF)
                            )
                        ),
                        child: Text(
                            "Preview",
                            style: TextStyle(
                              color: Color(0xFF74ADDF),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600
                            ),
                        ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF74ADDF)
                        ),
                        child: Text(
                            "Download",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600
                            ),
                        )
                    ),
                  )
                ],
              )
            ],
        ),
      )
    );
  }
}