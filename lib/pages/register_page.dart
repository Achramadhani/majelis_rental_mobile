import 'package:flutter/material.dart';

import '../models/registered_user.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: const Color(0xFF4E3124),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4E3124),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFD9C3B0), Color(0xFF8A5F4B)],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 160,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1200&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'TERRA RIDGE',
                            style: TextStyle(
                              color: Color(0xFFF3E8DF),
                              fontSize: 10,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Mulai Petualangan Anda.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              height: 1.08,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF3E2C25),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lengkapi detail di bawah untuk bergabung dengan komunitas eksklusif pendaki kami.',
                style: TextStyle(color: Color(0xFF77635D), height: 1.5),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                      label: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      controller: _fullNameController,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      label: 'Email',
                      hintText: 'nama@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      label: 'Nomor Telepon',
                      hintText: '+62 812 3456 7890',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      label: 'Alamat Lengkap',
                      hintText: 'Alamat pengiriman peralatan',
                      controller: _addressController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      label: 'Kata Sandi',
                      hintText: '••••••••',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      label: 'Konfirmasi Kata Sandi',
                      hintText: '••••••••',
                      controller: _confirmController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4E3124),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'DAFTAR SEKARANG',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(color: Color(0xFF7B645D)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFF4E3124),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6F5C55),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3EEEA),
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Field tidak boleh kosong.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF9A8E88)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
    });

    final user = RegisteredUser(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );

    final error = AuthService.register(user, _confirmController.text);
    if (error != null) {
      _showMessage(error, isError: true);
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    _showMessage('Registrasi berhasil. Silakan masuk.', isError: false);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.pop(context, user);
    });
  }

  void _showMessage(String message, {required bool isError}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? const Color(0xFF8B1E1E)
              : const Color(0xFF3E5A44),
          duration: const Duration(milliseconds: 1600),
        ),
      );
  }
}
