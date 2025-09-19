import 'dart:math';

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CardJadwal extends StatelessWidget {
  final String subjek;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String pesan;
  final String status;

  const CardJadwal({
    super.key,
    required this.subjek,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
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
            subjek,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        tanggal,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        waktu,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lokasi,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
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
