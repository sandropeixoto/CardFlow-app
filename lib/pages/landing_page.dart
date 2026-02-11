import 'package:card_flow/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _handleLogin(BuildContext context) async {
    try {
      final user = await AuthService().signInWithGoogle();

      if (user != null) {
        // Success is handled by the StreamBuilder in main.dart
      } 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha no login. Tente novamente.', style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);
    const backgroundColor = Color(0xFF1A1B26);
    const textColor = Color(0xFFA0A0B0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Column(
                children: [
                  const Icon(Icons.credit_card_rounded, color: primaryColor, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    'Bem-vindo ao CardFlow',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sua vida financeira, simplificada e segura.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // Features Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeature(Icons.check_circle_outline, 'Gerenciamento centralizado de cartões'),
                  const SizedBox(height: 16),
                  _buildFeature(Icons.check_circle_outline, 'Acompanhamento de despesas em tempo real'),
                  const SizedBox(height: 16),
                  _buildFeature(Icons.check_circle_outline, 'Segurança com autenticação biométrica'),
                ],
              ),

              // Login Button Section
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: -10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _handleLogin(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0, // Shadow is handled by the container
                  ),
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                  label: Text(
                    'Entrar com Google',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: const Color(0xFFA0A0B0),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
