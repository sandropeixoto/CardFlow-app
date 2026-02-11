import 'package:flutter/material.dart';
import 'package:card_flow/services/auth_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CardFlow',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              const Text(
                'A maneira mais simples de gerenciar seus cartões e pagamentos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 48),
              const Text(
                'Recursos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Gerencie todos os seus cartões em um só lugar.'),
              ),
              const ListTile(
                leading: Icon(Icons.payment),
                title: Text('Acompanhe seus pagamentos e despesas.'),
              ),
              const ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Receba notificações de vencimento de faturas.'),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () async {
                  final authService = AuthService();
                  try {
                    await authService.signInWithGoogle();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao fazer login. Tente novamente.'),
                      ),
                    );
                  }
                },
                child: const Text('Entrar com o Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
