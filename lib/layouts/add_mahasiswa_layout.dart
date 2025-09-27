import 'package:flutter/material.dart';

class AddMahasiswaLayout extends StatelessWidget {
  final Widget child;

  const AddMahasiswaLayout({
    super.key,
    required this.child
  });


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cari Mahasiswa Bimbingan",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black
            ),
            decoration: InputDecoration(
              hintText: "Cari berdasarkan judul atau nama",
              hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.black38
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black38,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none  // Hilangkan border default
              ),
              enabledBorder: OutlineInputBorder(  // Border saat tidak fokus
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,  // Tidak ada border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Color(0xFF74ADDF),
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,  // Tidak ada border saat disabled
              ),
            ),
          ),
          child,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF677BE6),
                    Color(0xFF754EA6)
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Tambahkan Mahasiswa",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
