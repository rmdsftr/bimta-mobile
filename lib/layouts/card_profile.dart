import 'package:flutter/material.dart';
import 'package:bimta/widgets/custom_alert.dart';


class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // =========================
  // 🔒 HANDLE PASSWORD CHANGE
  // =========================
  void _handlePasswordChange() {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      CustomDialog.showError(
        context: context,
        title: "Gagal Mengubah Password",
        message: "Harap isi semua kolom terlebih dahulu.",
      );
      return;
    }

    if (newPass != confirm) {
      CustomDialog.showError(
        context: context,
        title: "Password Tidak Sama",
        message: "Pastikan password baru dan konfirmasi password cocok.",
      );
      return;
    }

    CustomDialog.showSuccess(
      context: context,
      message:
      "Password berhasil diubah!\nSilakan login kembali untuk keamanan akun Anda.",
    );
  }

  @override
  Widget build(BuildContext context) {
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
            "Ubah Password",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          _buildTextField("Password Saat Ini", "Masukkan password saat ini",
              controller: currentPasswordController),
          const SizedBox(height: 16),

          _buildTextField("Password Baru", "Masukkan password baru",
              controller: newPasswordController),
          const SizedBox(height: 16),

          _buildTextField(
              "Konfirmasi Password Baru", "Konfirmasi password baru",
              controller: confirmPasswordController),
          const SizedBox(height: 24),

          _buildGradientButton(
            context,
            label: "Ubah Password",
            onPressed: _handlePasswordChange,
          ),
        ],
      ),
    );
  }

  // =========================
  // 🧩 HELPER WIDGETS
  // =========================
  static Widget _buildTextField(String label, String hint,
      {required TextEditingController controller}) {
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
          obscureText: true,
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
