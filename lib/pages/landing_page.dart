import 'package:flutter/material.dart';
import 'package:card_flow/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
                  final User? user = await authService.signInWithGoogle();
                  if (user != null) {
                    // Navegar para a próxima página após o login
                    print('Login bem-sucedido: ${user.displayName}');
                  } else {
                    // Lidar com falha no login
                    print('Falha no login');
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
