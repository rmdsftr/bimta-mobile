import 'package:flutter/material.dart';

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
  // 🧩 FUNCTION: SUCCESS DIALOG
  // =========================
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline,
                    color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),
              const Text(
                'Berhasil!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // 🧩 FUNCTION: ERROR DIALOG
  // =========================
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child:
                const Icon(Icons.error_outline, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),
              const Text(
                'Oops!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF677BE6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // 🧩 FUNCTION: VALIDASI
  // =========================
  void _ajukanJudul() {
    if (_judulController.text.trim().isEmpty) {
      _showErrorDialog("Judul TA tidak boleh kosong.");
      return;
    }
    _showSuccessDialog(
        "Perubahan judul TA diajukan.\nMenunggu persetujuan dosen pembimbing.");
  }

  void _simpanNomorHP() {
    if (_nomorHpController.text.trim().isEmpty) {
      _showErrorDialog("Nomor HP tidak boleh kosong.");
      return;
    }
    _showSuccessDialog("Nomor HP berhasil diperbarui.");
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
            _buildTextField("Judul Tugas Akhir", "Masukkan judul TA anda",
                controller: _judulController),
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

          _buildTextField("Nomor HP", "Masukkan nomor HP aktif anda",
              controller: _nomorHpController),
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
