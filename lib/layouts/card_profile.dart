import 'package:bimta/models/change_password.dart';
import 'package:bimta/services/auth/change_password.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final _formKey = GlobalKey<FormState>();
  final _sandiLamaController = TextEditingController();
  final _sandiBaruController = TextEditingController();
  final _konfirmasiSandiController = TextEditingController();
  final _changePasswordService = ChangePasswordService();

  bool _isLoading = false;
  bool _obscureSandiLama = true;
  bool _obscureSandiBaru = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _sandiLamaController.dispose();
    _sandiBaruController.dispose();
    _konfirmasiSandiController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final dto = ChangePasswordDto(
      sandiLama: _sandiLamaController.text,
      sandiBaru: _sandiBaruController.text,
      konfirmasiSandi: _konfirmasiSandiController.text,
    );

    try {
      final response = await _changePasswordService.changePassword(dto);

      if (!mounted) return;

      if (response.success) {
        _sandiLamaController.clear();
        _sandiBaruController.clear();
        _konfirmasiSandiController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan: $e',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      child: Form(
        key: _formKey,
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

            // Input password saat ini
            _buildPasswordField(
              label: "Password Saat Ini",
              hint: "masukkan password saat ini",
              controller: _sandiLamaController,
              obscureText: _obscureSandiLama,
              onToggleVisibility: () {
                setState(() {
                  _obscureSandiLama = !_obscureSandiLama;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password saat ini harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Input password baru
            _buildPasswordField(
              label: "Password Baru",
              hint: "masukkan password baru",
              controller: _sandiBaruController,
              obscureText: _obscureSandiBaru,
              onToggleVisibility: () {
                setState(() {
                  _obscureSandiBaru = !_obscureSandiBaru;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password baru harus diisi';
                }
                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Input konfirmasi password baru
            _buildPasswordField(
              label: "Konfirmasi Password Baru",
              hint: "konfirmasi password baru",
              controller: _konfirmasiSandiController,
              obscureText: _obscureKonfirmasi,
              onToggleVisibility: () {
                setState(() {
                  _obscureKonfirmasi = !_obscureKonfirmasi;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password harus diisi';
                }
                if (value != _sandiBaruController.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Tombol
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isLoading
                          ? [
                        const Color(0xFF677BE6).withOpacity(0.5),
                        const Color(0xFF754EA6).withOpacity(0.5),
                      ]
                          : [
                        const Color(0xFF677BE6),
                        const Color(0xFF754EA6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Ubah Password",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            errorStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}