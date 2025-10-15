import 'package:flutter/material.dart';

class ProfileInformationCard extends StatelessWidget {
  final String role;
  const ProfileInformationCard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isMahasiswa = role.toLowerCase() == 'mahasiswa';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Profil",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          // ==============================
          // Input Mahasiswa: Judul TA
          // ==============================
          if (isMahasiswa) ...[
            _buildTextField("Judul Tugas Akhir", "masukkan judul TA anda"),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.info_outline, size: 16, color: Colors.orange),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    "Perubahan judul TA memerlukan persetujuan dosen pembimbing.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // ==============================
          // Tombol untuk Mahasiswa
          // ==============================
          if (isMahasiswa) ...[
            _buildGradientButton(
              context,
              label: "Ajukan Perubahan Judul TA",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Perubahan judul TA diajukan. Menunggu persetujuan dosen.",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],


          // ==============================
          // Input Nomor HP (umum)
          // ==============================
          _buildTextField("Nomor HP", "masukkan nomor HP aktif anda"),
          const SizedBox(height: 24),

          // ==============================
          // Tombol Simpan Nomor HP
          // ==============================
          _buildGradientButton(
            context,
            label: "Simpan Nomor HP",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Nomor HP berhasil diperbarui.",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk textfield
  static Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Helper untuk tombol gradient
  static Widget _buildGradientButton(
      BuildContext context, {
        required String label,
        required VoidCallback onPressed,
      }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF677BE6),
                Color(0xFF754EA6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
