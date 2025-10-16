import 'package:bimta/services/auth/change_number.dart';
import 'package:bimta/services/profile/ganti_judul.dart';
import 'package:flutter/material.dart';

class ProfileInformationCard extends StatefulWidget {
  final String role;
  const ProfileInformationCard({super.key, required this.role});

  @override
  State<ProfileInformationCard> createState() => _ProfileInformationCardState();
}

class _ProfileInformationCardState extends State<ProfileInformationCard> {
  final ProfileService _profileService = ProfileService();
  final ChangeJudulService _changeJudulService = ChangeJudulService();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _taController = TextEditingController();

  bool _isLoadingPhone = false;
  bool _isLoadingTA = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _taController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePhone() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      _showSnackBar('Nomor HP tidak boleh kosong', isError: true);
      return;
    }

    if (!_profileService.validatePhoneNumber(phone)) {
      _showSnackBar(
        'Format nomor HP tidak valid. Gunakan format 08xxx atau 628xxx',
        isError: true,
      );
      return;
    }

    setState(() => _isLoadingPhone = true);

    try {
      final formattedPhone = _profileService.formatPhoneNumber(phone);
      final response = await _profileService.changeNumber(formattedPhone);

      _showSnackBar(response.message);
      _phoneController.clear();
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      setState(() => _isLoadingPhone = false);
    }
  }

  Future<void> _handleChangeTATitle() async {
    final title = _taController.text.trim();

    if (title.isEmpty) {
      _showSnackBar('Judul TA tidak boleh kosong', isError: true);
      return;
    }

    if (!_changeJudulService.validateJudul(title)) {
      if (title.length < 10) {
        _showSnackBar('Judul TA minimal 10 karakter', isError: true);
      } else if (title.length > 200) {
        _showSnackBar('Judul TA maksimal 200 karakter', isError: true);
      }
      return;
    }

    setState(() => _isLoadingTA = true);

    try {
      final formattedTitle = _changeJudulService.formatJudul(title);
      final response = await _changeJudulService.changeJudul(formattedTitle);

      _showSnackBar(response.message);
      _taController.clear();
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      setState(() => _isLoadingTA = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
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

          // ==============================
          // Input Mahasiswa: Judul TA
          // ==============================
          if (isMahasiswa) ...[
            _buildTextField(
              "Judul Tugas Akhir",
              "masukkan judul TA anda (min. 10 karakter)",
              controller: _taController,
              maxLines: 3,
              maxLength: 200,
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
          ],

          // ==============================
          // Tombol untuk Mahasiswa
          // ==============================
          if (isMahasiswa) ...[
            _buildGradientButton(
              context,
              label: "Ubah Judul TA",
              onPressed: _isLoadingTA ? null : _handleChangeTATitle,
              isLoading: _isLoadingTA,
            ),
            const SizedBox(height: 12),
          ],

          // ==============================
          // Input Nomor HP (umum)
          // ==============================
          _buildTextField(
            "Nomor HP",
            "masukkan nomor HP aktif anda",
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),

          // ==============================
          // Tombol Simpan Nomor HP
          // ==============================
          _buildGradientButton(
            context,
            label: "Simpan Nomor HP",
            onPressed: _isLoadingPhone ? null : _handleChangePhone,
            isLoading: _isLoadingPhone,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint, {
        required TextEditingController controller,
        TextInputType? keyboardType,
        int maxLines = 1,
        int? maxLength,
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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
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
            counterStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton(
      BuildContext context, {
        required String label,
        required VoidCallback? onPressed,
        bool isLoading = false,
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
            gradient: LinearGradient(
              colors: onPressed == null
                  ? [Colors.grey, Colors.grey]
                  : const [
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
            child: isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
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