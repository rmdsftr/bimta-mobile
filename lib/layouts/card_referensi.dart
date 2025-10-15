import 'package:flutter/material.dart';

class CardReferensi extends StatelessWidget {
  final String nama;
  final String nim;
  final String topik;
  final String judul;
  final String tahun;
  final String? docUrl;
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;

  const CardReferensi({
    super.key,
    required this.nama,
    required this.nim,
    required this.topik,
    required this.judul,
    required this.tahun,
    this.docUrl,
    this.onPreview,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDocument = docUrl != null && docUrl!.isNotEmpty;

    // DEBUG: Print docUrl status
    print('Card: $judul - docUrl: $docUrl - hasDocument: $hasDocument');

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
                color: Color(0xFF407549),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "$tahun | $topik",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "$nim | $nama",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: hasDocument ? onPreview : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: hasDocument
                            ? Color(0xFF74ADDF)
                            : Colors.grey.shade300,
                      ),
                      disabledForegroundColor: Colors.grey.shade400,
                    ),
                    child: Text(
                      "Preview",
                      style: TextStyle(
                        color: hasDocument
                            ? Color(0xFF74ADDF)
                            : Colors.grey.shade400,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: hasDocument ? onDownload : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasDocument
                          ? Color(0xFF74ADDF)
                          : Colors.grey.shade300,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: Text(
                      "Download",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}