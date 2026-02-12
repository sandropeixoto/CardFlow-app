import 'package:card_flow/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoading = false;

  void _handleLogin(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final user = await AuthService().signInWithGoogle();
      // O redirecionamento é feito automaticamente pelo StreamBuilder no main.dart
      if (user == null && mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Falha no login. Tente novamente.',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Paleta de Cores Premium
    const backgroundColor = Color(0xFF181920); // Dark Charcoal
    const primaryAccent = Color(0xFF6C63FF);   // Roxo Neon
    const successColor = Color(0xFF00D09C);    // Verde Menta (Dinheiro/Prazo)
    const textColor = Colors.white;
    const subTextColor = Color(0xFFA0A0B0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. HEADER & LOGO
              // A logo dá a identidade imediata do app
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  'assets/images/logo-cardflow-no-background.png',
                  height: 60, // Tamanho controlado para não estourar
                  fit: BoxFit.contain,
                ),
              ),

              // 2. CONTEÚDO CENTRAL (A DOR E A SOLUÇÃO)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gatilho da Dor (Headline)
                  Text(
                    'Cansado de perder dinheiro com seus cartões?',
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // A Solução (Subheadline)
                  Text(
                    'Pare de pagar juros e comece a ganhar tempo. O CardFlow escolhe o melhor cartão para hoje, garantindo até 40 dias de fôlego no seu bolso.',
                    style: GoogleFonts.poppins(
                      color: subTextColor,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Benefícios Visuais (Bullet Points)
                  _buildBenefit(
                    icon: Icons.calendar_today_rounded,
                    color: successColor,
                    text: 'Saiba qual cartão usar em 1 segundo',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefit(
                    icon: Icons.shield_outlined,
                    color: primaryAccent,
                    text: 'Evite juros de atraso com alertas',
                  ),
                ],
              ),

              // 3. CTA (CHAMADA PARA AÇÃO)
              Column(
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator(color: primaryAccent)
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _handleLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Contraste máximo
                          foregroundColor: Colors.black87,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Tenta usar um ícone que lembre o Google ou o padrão de login
                            const Icon(Icons.login, color: Colors.black87), 
                            const SizedBox(width: 12),
                            Text(
                              'Entrar com o Google',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Seguro e sem senhas extras.',
                    style: GoogleFonts.poppins(
                      color: Colors.white24,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Auxiliar para os Benefícios
  Widget _buildBenefit({required IconData icon, required Color color, required String text}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}