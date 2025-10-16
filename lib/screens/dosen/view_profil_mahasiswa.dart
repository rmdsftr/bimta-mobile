import 'package:bimta/layouts/card_riwayat.dart';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/riwayat_mahasiswa.dart';
import 'package:bimta/models/view_profil_mahasiswa.dart';
import 'package:bimta/services/bimbingan/bimbingan_selesai.dart';
import 'package:bimta/services/bimbingan/hapus_mahasiswa_bimbingan.dart';
import 'package:bimta/services/profile/setuju_ganti_judul.dart';
import 'package:bimta/services/profile/view_profil_mahasiswa.dart';
import 'package:bimta/services/riwayat_mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:bimta/widgets/background.dart';

class ViewProfileMahasiswaScreen extends StatefulWidget {
  final String mahasiswaId;

  const ViewProfileMahasiswaScreen({
    Key? key,
    required this.mahasiswaId,
  }) : super(key: key);

  @override
  State<ViewProfileMahasiswaScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ViewProfileMahasiswaScreen> {
  final ProfileMahasiswaService _profileService = ProfileMahasiswaService();
  final RiwayatService _riwayatService = RiwayatService();
  final HapusBimbinganService _hapusBimbinganService = HapusBimbinganService();
  final ApproveJudulService _approveJudulService = ApproveJudulService();
  final SelesaiBimbinganService _selesaiBimbinganService = SelesaiBimbinganService();

  ProfileMahasiswa? _profileData;
  List<RiwayatBimbinganModel> _riwayatData = [];
  bool _isLoadingProfile = true;
  bool _isLoadingRiwayat = true;
  bool _isDeleting = false;
  bool _isLoadingJudul = false;
  bool _isCompletingBimbingan = false;
  String? _errorMessageProfile;
  String? _errorMessageRiwayat;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadRiwayatData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoadingProfile = true;
      _errorMessageProfile = null;
    });

    try {
      final profile = await _profileService.getProfileMahasiswa(widget.mahasiswaId);
      setState(() {
        _profileData = profile;
        _isLoadingProfile = false;
      });
    } catch (e) {
      setState(() {
        _errorMessageProfile = e.toString().replaceFirst('Exception: ', '');
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _loadRiwayatData() async {
    setState(() {
      _isLoadingRiwayat = true;
      _errorMessageRiwayat = null;
    });

    try {
      final riwayat = await _riwayatService.getRiwayatBimbingan(
        mahasiswaId: widget.mahasiswaId,
      );
      setState(() {
        _riwayatData = riwayat;
        _isLoadingRiwayat = false;
      });
    } catch (e) {
      setState(() {
        _errorMessageRiwayat = e.toString().replaceFirst('Exception: ', '');
        _isLoadingRiwayat = false;
      });
    }
  }

  void _handleSetujuJudul() async {
    setState(() => _isLoadingJudul = true);

    try {
      await _approveJudulService.approveJudul(widget.mahasiswaId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Perubahan judul TA berhasil disetujui',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        await _loadProfileData();
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
        setState(() => _isLoadingJudul = false);
      }
    }
  }

  void _handleTidakSetujuJudul() async {
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
      setState(() => _isLoadingJudul = true);

      try {
        await _approveJudulService.rejectJudul(widget.mahasiswaId);

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

          await _loadProfileData();
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
          setState(() => _isLoadingJudul = false);
        }
      }
    }
  }

  void _hapusDariBimbingan() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${_profileData?.nama ?? 'mahasiswa ini'} dari bimbingan?\n\nSemua data progress, jadwal, dan riwayat bimbingan akan dihapus permanen.',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: _isDeleting ? null : () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: _isDeleting ? null : () async {
                setState(() {
                  _isDeleting = true;
                });

                try {
                  final success = await _hapusBimbinganService.hapusMahasiswaBimbingan(
                    widget.mahasiswaId,
                  );

                  if (success && mounted) {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context, true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Mahasiswa berhasil dihapus dari bimbingan',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() {
                      _isDeleting = false;
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString().replaceFirst('Exception: ', ''),
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                }
              },
              child: _isDeleting
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
                  : const Text(
                'Hapus',
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
  }

  void _bimbinganSelesai() async {
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
          content: Text(
            'Apakah Anda yakin bimbingan ${_profileData?.nama ?? 'mahasiswa ini'} sudah selesai?\n\nStatus bimbingan akan diubah menjadi selesai.',
            style: const TextStyle(fontFamily: 'Poppins'),
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
                'Selesai',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _isCompletingBimbingan = true);

      try {
        final success = await _selesaiBimbinganService.selesaikanBimbingan(
          widget.mahasiswaId,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Bimbingan ${_profileData?.nama ?? 'mahasiswa'} berhasil diselesaikan',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );

          // Kembali ke halaman sebelumnya dengan hasil true
          Navigator.pop(context, true);
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
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isCompletingBimbingan = false);
        }
      }
    }
  }

  int _countOfflineBimbingan() {
    return _riwayatData
        .where((item) => item.jenis.name == 'offline')
        .length;
  }

  int _countOnlineBimbingan() {
    return _riwayatData
        .where((item) => item.jenis.name == 'online')
        .length;
  }

  Widget _buildJudulRequestCard() {
    if (_profileData == null || !_profileData!.hasJudulRequest) {
      return const SizedBox.shrink();
    }

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
                  _profileData?.judulTemp ?? '',
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoadingJudul ? null : _handleTidakSetujuJudul,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(
                      color: _isLoadingJudul ? Colors.grey : Colors.red,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoadingJudul
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
                  onPressed: _isLoadingJudul ? null : _handleSetujuJudul,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoadingJudul ? Colors.grey : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoadingJudul
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

  Widget _buildRiwayatSection() {
    if (_isLoadingRiwayat) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF74ADDF)),
          ),
        ),
      );
    }

    if (_errorMessageRiwayat != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red[300],
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessageRiwayat ?? 'Gagal memuat riwayat',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.red[300],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadRiwayatData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF74ADDF),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_riwayatData.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 20),
          Icon(
            Icons.inbox_outlined,
            size: 60,
            color: Colors.black26,
          ),
          SizedBox(height: 10),
          Text(
            "Belum ada riwayat bimbingan",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _riwayatData.length,
      itemBuilder: (context, index) {
        final item = _riwayatData[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ExpandableCard(
            topik: item.displayTopik,
            tanggal: item.formattedTanggal,
            pembahasan: item.pembahasan,
            hasil: item.hasil,
            icon: item.icon,
            color: item.color,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Disable buttons saat ada proses loading
    final isAnyLoading = _isDeleting || _isCompletingBimbingan;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundWidget(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomTopbar(
              leading: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoadingProfile)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF74ADDF)),
              ),
            )
          else if (_errorMessageProfile != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessageProfile ?? 'Terjadi kesalahan',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF677BE6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Card Profile
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFfff2cb),
                                Colors.white,
                                Color(0xFFC6E2CB),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Avatar
                                    (_profileData?.photoUrl != null &&
                                        _profileData!.photoUrl!.isNotEmpty)
                                        ? Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        child: Image.network(
                                          _profileData!.photoUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    100),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/avatar.png"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                BorderRadius.circular(
                                                    100),
                                              ),
                                              child: Center(
                                                child:
                                                CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  value: loadingProgress
                                                      .expectedTotalBytes !=
                                                      null
                                                      ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                        : Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/avatar.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _profileData?.nama ?? '-',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            _profileData?.userId ?? '-',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      _profileData?.judul ??
                                          'Judul belum ditentukan',
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${_countOfflineBimbingan()}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const Text(
                                        "Bimbingan",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const Text(
                                        "Offline",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${_countOnlineBimbingan()}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const Text(
                                        "Bimbingan",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const Text(
                                        "Online",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),

                        // JUDUL REQUEST CARD
                        _buildJudulRequestCard(),

                        // Buttons - Hanya tampil jika status bimbingan bukan 'done'
                        if (_profileData?.isBimbinganDone != true) ...[
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isAnyLoading ? null : _hapusDariBimbingan,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: BorderSide(
                                        color: isAnyLoading ? Colors.grey : Colors.red,
                                        width: 1.5),
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: _isDeleting
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                    ),
                                  )
                                      : const Text(
                                    'Hapus dari bimbingan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isAnyLoading ? null : _bimbinganSelesai,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isAnyLoading ? Colors.grey : Colors.green,
                                    foregroundColor: Colors.white,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: _isCompletingBimbingan
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : const Text(
                                    'Bimbingan selesai',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],

                        // Badge status jika bimbingan sudah selesai
                        if (_profileData?.isBimbinganDone == true) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE8F5E9),
                                  Color(0xFFC8E6C9),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.shade300,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade700,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Bimbingan Selesai',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Riwayat bimbingan",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRiwayatSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}