import 'package:flutter/material.dart';

class ListMahasiswa extends StatelessWidget {
  final String nama;
  final String nim;

  const ListMahasiswa({
    required this.nama,
    required this.nim,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nama),
          Text(nim),
        ],
      ),
    );
  }

}
