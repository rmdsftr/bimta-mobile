import 'package:bimta/services/auth/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn) {
      final userData = await _authService.getCurrentUser();
      final role = userData['role'] ?? '';

      _navigateBasedOnRole(role);
    } else {
      Navigator.pushReplacementNamed(context, '/landing');
    }
  }

  void _navigateBasedOnRole(String role) {
    switch (role.toLowerCase()) {
      case 'mahasiswa':
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 'dosen':
        Navigator.pushReplacementNamed(context, '/dosen/home');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8DAD93), Colors.white70],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo-bimta.png"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "BIMTA",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color(0xFF407549),
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4D81E7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}