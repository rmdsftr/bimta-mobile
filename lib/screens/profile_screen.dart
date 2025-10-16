import 'dart:io';
import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/services/auth/mahasiswaInfo.dart';
import 'package:bimta/services/auth/token_storage.dart';
import 'package:bimta/services/auth/logout.dart';
import 'package:bimta/services/profile/ganti_foto.dart';
import 'package:bimta/widgets/photo_corner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bimta/widgets/background.dart';
import 'package:bimta/widgets/logo_corner.dart';
import 'package:bimta/layouts/card_profile.dart';
import 'package:bimta/layouts/card_profileInformation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? nama;
  String? role;
  String? photoUrl;
  String? judulTugasAkhir;
  String? noWhatsapp;
  File? _selectedImage;
  final GlobalKey<PhotoCornerState> _photoCornerKey = GlobalKey<PhotoCornerState>();

  final LogoutService _logoutService = LogoutService();
  final ProfilePhotoService _profilePhotoService = ProfilePhotoService();
  final MahasiswaInfoService _mahasiswaInfoService = MahasiswaInfoService();

  bool _isLoggingOut = false;
  bool _isUploadingPhoto = false;
  bool _isLoadingMahasiswaInfo = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final userData = await TokenStorage().getUserData();
    setState(() {
      nama = userData['nama'];
      role = userData['role'];
    });

    // Load info mahasiswa jika role adalah mahasiswa
    if (role?.toLowerCase() == 'mahasiswa') {
      loadMahasiswaInfo();
    }
  }

  Future<void> loadMahasiswaInfo() async {
    setState(() {
      _isLoadingMahasiswaInfo = true;
    });

    try {
      final response = await _mahasiswaInfoService.getMyInfo();

      if (!mounted) return;

      if (response.success && response.data != null) {
        setState(() {
          judulTugasAkhir = response.data!.judul;
          noWhatsapp = response.data!.noWhatsapp;
          _isLoadingMahasiswaInfo = false;
        });
      } else {
        setState(() {
          _isLoadingMahasiswaInfo = false;
        });

        // Optional: Uncomment jika ingin menampilkan error
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       response.message,
        //       style: const TextStyle(fontFamily: 'Poppins'),
        //     ),
        //     backgroundColor: Colors.orange,
        //   ),
        // );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingMahasiswaInfo = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await _picker.pickImage(source: ImageSource.gallery),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await _picker.pickImage(source: ImageSource.camera),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isUploadingPhoto = true;
      });

      final response = await _profilePhotoService.changePhoto(_selectedImage!);

      if (!mounted) return;

      setState(() {
        _isUploadingPhoto = false;
      });

      if (response.success) {
        setState(() {
          photoUrl = response.photoUrl;
        });

        _photoCornerKey.currentState?.refreshPhoto();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _selectedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Logout',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Batal',
                style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Ya, Keluar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE74C3C),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      final response = await _logoutService.logout();

      if (!mounted) return;

      if (response.success) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/landing',
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
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
          _isLoggingOut = false;
        });
      }
    }
  }

  ImageProvider _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      return NetworkImage(photoUrl!);
    } else {
      return const AssetImage("assets/images/avatar.png");
    }
  }

  Widget _buildMahasiswaInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Informasi Mahasiswa',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_isLoadingMahasiswaInfo)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black54,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.book_outlined,
            label: '',
            value: judulTugasAkhir ?? 'Belum diisi',
            isLoading: _isLoadingMahasiswaInfo,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: '',
            value: noWhatsapp ?? 'Belum diisi',
            isLoading: _isLoadingMahasiswaInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLoading = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Container(
                height: 14,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              )
                  : Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundWidget(),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 100),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: _selectedImage != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    _selectedImage!,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : PhotoCorner(
                                  key: _photoCornerKey,
                                  height: 160,
                                  width: 160,
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: _isUploadingPhoto ? null : _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: _isUploadingPhoto
                                        ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black54,
                                      ),
                                    )
                                        : const Icon(
                                      Icons.camera_alt,
                                      size: 22,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            nama ?? 'Memuat...',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            role ?? '',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Card Informasi Mahasiswa (hanya untuk role mahasiswa)
                      if (role?.toLowerCase() == 'mahasiswa') ...[
                        _buildMahasiswaInfoCard(),
                        const SizedBox(height: 20),
                      ],

                      if (role != null) ProfileInformationCard(role: role!),
                      const SizedBox(height: 30),

                      const ProfileCard(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoggingOut ? null : _handleLogout,
                  icon: _isLoggingOut
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.logout,
                      color: Colors.white, size: 22),
                  label: Text(
                    _isLoggingOut ? "Logging Out..." : "Logout",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFE74C3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor:
                    const Color(0xFFE74C3C).withOpacity(0.6),
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