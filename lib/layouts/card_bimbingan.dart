import 'package:flutter/material.dart';

class CardBimbingan extends StatelessWidget{
  final String nama;
  final String nim;
  final String judul;

  const CardBimbingan({
    required this.nama,
    required this.nim,
    required this.judul,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0, 2),
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: AssetImage("assets/images/avatar.png"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      nama,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 13
                      ),
                  ),
                  Text(
                      nim,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.black87
                      ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Text(
              judul,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12
              ),
          )
        ],
      ),
    );
  }
}