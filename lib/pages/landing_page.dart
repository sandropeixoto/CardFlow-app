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
      if (user == null && mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha no login. Tente novamente.', 
            style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF181920);
    const primaryAccent = Color(0xFF6C63FF);
    const successColor = Color(0xFF00D09C);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView( // Permite rolagem em telas menores
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: Column(
              children: [
                // 1. LOGO
                Image.asset(
                  'assets/images/logo-cardflow-no-background.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 50),

                // 2. HERO SECTION
                Text(
                  'Use seus cartões de crédito com Inteligência Financiera.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Cansado de perder dinheiro com seus cartões de crédito? Pare de pagar juros e começe a ganhar tempo.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFA0A0B0),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),                const SizedBox(height: 16),
                Text(
                  'O CardFlow escolhe o cartão certo para cada compra, garantindo o máximo de prazo e zero juros por esquecimento.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFA0A0B0),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // 3. SEÇÃO DE BENEFÍCIOS (Ajustada para a realidade do MVP)

                // CARD 1: O FOCO NO PRAZO (O "Aha! Moment")
                _buildValueCard(
                  icon: Icons.auto_awesome,
                  title: 'Máximo de Prazo',
                  subtitle: 'O CardFlow identifica qual cartão está no ciclo ideal para você ganhar até 40 dias de fôlego.',
                  accentColor: successColor,
                ),

                // CARD 2: ORGANIZAÇÃO SEM MISTURA (Ajustado conforme seu feedback)
                _buildValueCard(
                  icon: Icons.account_tree_outlined,
                  title: 'Inteligência PF e PJ',
                  subtitle: 'Organize seus cartões pessoais e da empresa. Saiba qual é a melhor escolha para cada perfil sem confusão.',
                  accentColor: primaryAccent,
                ),

                // CARD 3: SEGURANÇA E PRIVACIDADE (Novo focado nos 4 dígitos)
                _buildValueCard(
                  icon: Icons.lock_outline_rounded,
                  title: 'Privacidade Total',
                  subtitle: 'Segurança por design: identifique seus cartões apenas pelos últimos 4 dígitos. Nunca pedimos o número completo.',
                  accentColor: Colors.blueAccent,
                ),
                
                const SizedBox(height: 40),

                // 4. CTA SECTION
                if (_isLoading)
                  const CircularProgressIndicator(color: primaryAccent)
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () => _handleLogin(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: primaryAccent.withValues(alpha: 0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.g_mobiledata_rounded, size: 32),
                              const SizedBox(width: 8),
                              Text(
                                'Entrar com Google',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Acesso instantâneo. Sem formulários.',
                        style: GoogleFonts.poppins(
                          color: Colors.white30,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para os Cards de Benefício
  Widget _buildValueCard({
    required IconData icon, 
    required String title, 
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF252634),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFA0A0B0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}