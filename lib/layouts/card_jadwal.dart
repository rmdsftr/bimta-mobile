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
  final String? pesanDosen;

  const CardJadwal({
    super.key,
    required this.subjek,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.pesan,
    required this.status,
    this.pesanDosen
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
          ),
          SizedBox(height: 10),
          if(pesanDosen != null && pesanDosen!.isNotEmpty)...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.topic_rounded,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Pesan dosen",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pesanDosen ?? "",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
