import 'dart:math';

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CardProgress extends StatelessWidget {
  final String judul;
  final String tanggal;
  final String jam;
  final String namaFile;
  final String pesan;
  final String status;

  const CardProgress({
    super.key,
    required this.judul,
    required this.tanggal,
    required this.jam,
    required this.namaFile,
    required this.pesan,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              judul,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
          ),
          SizedBox(height: 2),
          Text(
              "$tanggal | $jam",
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Poppins'
              ),
          ),
          SizedBox(height: 10),
          Container(
              decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                      "assets/icons/file.png",
                      height: 20,
                      width: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                      namaFile,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          ReadMoreText(
              pesan,
              trimLines: 2,
              colorClickableText: Colors.blue,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Read more',
              trimExpandedText: 'Read less',
              style: TextStyle(
                  fontSize: 13
              ),
          )
        ],
      ),
    );
  }
}
