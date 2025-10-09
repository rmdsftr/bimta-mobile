import 'package:bimta/models/login.dart';
import 'package:bimta/services/auth/login.dart';
import 'package:flutter/material.dart';
import '../../widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _handleLogin() async {
    final userId = _nimController.text.trim();
    final password = _passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      showCustomSnackBar(context, "NIM/NIP dan password harus diisi");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = LoginRequest(
        userId: userId,
        password: password,
      );

      final response = await _authService.login(request);

      if (!mounted) return;

      if (response.success && response.data != null) {
        _navigateBasedOnRole(response.data!.role);
      } else {
        showCustomSnackBar(context, response.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
      body: Stack(
        children: [
          _buildBackground(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-login.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(color: Colors.white, width: 1),
          left: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.white, width: 1),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xFF8DAD93), Colors.white70],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(),
            const SizedBox(height: 10),
            _buildTitle(),
            const SizedBox(height: 20),
            _buildNimField(),
            const SizedBox(height: 15),
            _buildPasswordField(),
            _buildRememberAndForgot(),
            const SizedBox(height: 10),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 35,
      width: 35,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/logo-bimta.png"),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "LOGIN",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.black,
      ),
    );
  }

  Widget _buildNimField() {
    return TextFormField(
      controller: _nimController,
      enabled: !_isLoading,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        hintText: "NIM/NIP",
        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: Color(0xFF4D81E7),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      enabled: !_isLoading,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        hintText: "Password",
        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0xFF4D81E7),
          size: 20,
        ),
        suffixIcon: IconButton(
          onPressed: _isLoading
              ? null
              : () => setState(() => _obscurePassword = !_obscurePassword),
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF74ADDF),
            size: 20,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildRememberAndForgot() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: _isRememberMe,
                onChanged: _isLoading
                    ? null
                    : (value) => setState(() => _isRememberMe = value ?? false),
                side: const BorderSide(color: Color(0xFF4D81E7), width: 2),
                activeColor: const Color(0xFF74ADDF),
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Text(
                "Remember me",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11),
              ),
            ],
          ),
          TextButton(
            onPressed: _isLoading ? null : () {
              // Navigate to forgot password screen
              // Navigator.pushNamed(context, '/forgot-password');
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4D81E7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _isLoading ? Colors.grey : const Color(0xFF4D81E7),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _handleLogin,
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
          "LOGIN",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nimController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}