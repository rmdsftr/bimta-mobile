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
          TextField(
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black
            ),
            decoration: InputDecoration(
              hintText: "Cari nim atau nama",
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
                  borderSide: BorderSide.none
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
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
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
