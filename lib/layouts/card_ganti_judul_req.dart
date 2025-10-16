import 'package:flutter/material.dart';

class JudulRequestCard extends StatelessWidget {
  final String judulBaru;
  final VoidCallback onSetuju;
  final VoidCallback onTidakSetuju;
  final bool isLoading;

  const JudulRequestCard({
    Key? key,
    required this.judulBaru,
    required this.onSetuju,
    required this.onTidakSetuju,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF9E6),
            Color(0xFFFFECB3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_note,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Pengajuan Perubahan Judul TA',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Judul yang diajukan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Judul yang ingin diubah:',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  judulBaru,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onTidakSetuju,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(
                      color: isLoading ? Colors.grey : Colors.red,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                      : const Text(
                    'Tidak Setuju',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSetuju,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading ? Colors.grey : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Setuju',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Contoh penggunaan di dalam ViewProfileMahasiswaScreen
class JudulRequestSection extends StatefulWidget {
  final String mahasiswaId;

  const JudulRequestSection({
    Key? key,
    required this.mahasiswaId,
  }) : super(key: key);

  @override
  State<JudulRequestSection> createState() => _JudulRequestSectionState();
}

class _JudulRequestSectionState extends State<JudulRequestSection> {
  bool _isLoading = false;

  // TODO: Replace dengan data dari API
  final bool _hasRequest = true; // Cek apakah ada request pending
  final String _judulBaru = "Implementasi Machine Learning untuk Rekomendasi Buku pada Sistem Informasi Perpustakaan Digital Menggunakan Algoritma Collaborative Filtering";

  void _handleSetuju() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implementasi API untuk menerima perubahan judul
      await Future.delayed(const Duration(seconds: 1)); // Simulasi

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Perubahan judul TA disetujui',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Refresh data
        // TODO: Panggil fungsi refresh dari parent
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleTidakSetuju() async {
    // Tampilkan dialog konfirmasi
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin tidak menyetujui perubahan judul TA ini?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Batal',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Ya, Tidak Setuju',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      try {
        // TODO: Implementasi API untuk menolak perubahan judul
        await Future.delayed(const Duration(seconds: 1)); // Simulasi

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Perubahan judul TA tidak disetujui',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Refresh data
          // TODO: Panggil fungsi refresh dari parent
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceFirst('Exception: ', ''),
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasRequest) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudulRequestCard(
          judulBaru: _judulBaru,
          onSetuju: _handleSetuju,
          onTidakSetuju: _handleTidakSetuju,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}