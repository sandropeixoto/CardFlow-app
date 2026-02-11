import 'package:flutter/material.dart';
import 'package:card_flow/models/card_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSensitiveData = false;

  // Sample data
  final List<CreditCard> _cards = [
    CreditCard(
      id: '1',
      nickname: 'Meu Cartão Pessoal',
      type: CardType.PF,
      brand: 'Visa',
      dueDay: 10,
      bestDay: 1,
      lastFourDigits: '1234',
      cvv: '123',
    ),
    CreditCard(
      id: '2',
      nickname: 'Cartão da Empresa',
      type: CardType.PJ,
      brand: 'Mastercard',
      dueDay: 25,
      bestDay: 15,
      lastFourDigits: '5678',
      cvv: '456',
      isAutoPay: true,
    ),
  ];

  void _toggleSensitiveData() {
    setState(() {
      _showSensitiveData = !_showSensitiveData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pfCards = _cards.where((card) => card.type == CardType.PF).toList();
    final pjCards = _cards.where((card) => card.type == CardType.PJ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CardFlow'),
        actions: [
          IconButton(
            icon: Icon(
              _showSensitiveData ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: _toggleSensitiveData,
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildCardSection('Pessoa Física', pfCards, Colors.blue),
          _buildCardSection('Pessoa Jurídica', pjCards, Colors.green),
        ],
      ),
    );
  }

  Widget _buildCardSection(
      String title, List<CreditCard> cards, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                title: Text(card.nickname),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Marca: ${card.brand}'),
                    Text(
                      'Final: ${_showSensitiveData ? card.lastFourDigits : '****'}',
                    ),
                    Text('CVV: ${_showSensitiveData ? card.cvv : '***'}'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
