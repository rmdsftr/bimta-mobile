import 'package:flutter/material.dart';
import 'package:bimta/widgets/custom_alert.dart'; // pastikan path sesuai (custom_alert.dart berisi class CustomDialog)

class ProfileInformationCard extends StatefulWidget {
  final String role;
  const ProfileInformationCard({super.key, required this.role});

  @override
  State<ProfileInformationCard> createState() => _ProfileInformationCardState();
}

class _ProfileInformationCardState extends State<ProfileInformationCard> {
  final _judulController = TextEditingController();
  final _nomorHpController = TextEditingController();

  // =========================
  // 🧩 FUNCTION: VALIDASI
  // =========================
  void _ajukanJudul() {
    if (_judulController.text.trim().isEmpty) {
      CustomDialog.showError(
        context: context,
        message: "Judul TA tidak boleh kosong.",
      );
      return;
    }

    CustomDialog.showSuccess(
      context: context,
      message:
      "Perubahan judul TA diajukan.\nMenunggu persetujuan dosen pembimbing.",
    );
  }

  void _simpanNomorHP() {
    if (_nomorHpController.text.trim().isEmpty) {
      CustomDialog.showError(
        context: context,
        message: "Nomor HP tidak boleh kosong.",
      );
      return;
    }

    CustomDialog.showSuccess(
      context: context,
      message: "Nomor HP berhasil diperbarui.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMahasiswa = widget.role.toLowerCase() == 'mahasiswa';

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

          if (isMahasiswa) ...[
            _buildTextField(
              "Judul Tugas Akhir",
              "Masukkan judul TA anda",
              controller: _judulController,
            ),
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
            _buildGradientButton(
              context,
              label: "Ajukan Perubahan Judul TA",
              onPressed: _ajukanJudul,
            ),
            const SizedBox(height: 12),
          ],

          _buildTextField(
            "Nomor HP",
            "Masukkan nomor HP aktif anda",
            controller: _nomorHpController,
          ),
          const SizedBox(height: 24),
          _buildGradientButton(
            context,
            label: "Simpan Nomor HP",
            onPressed: _simpanNomorHP,
          ),
        ],
      ),
    );
  }

  // =========================
  // 🧩 Helper Widget
  // =========================
  static Widget _buildTextField(String label, String hint,
      {TextEditingController? controller}) {
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
          controller: controller,
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
              colors: [Color(0xFF677BE6), Color(0xFF754EA6)],
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
