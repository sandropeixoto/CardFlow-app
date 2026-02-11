import 'package:card_flow/models/card_model.dart';
import 'package:card_flow/pages/add_card_page.dart';
import 'package:card_flow/services/card_logic.dart';
import 'package:card_flow/services/card_service.dart';
import 'package:card_flow/widgets/card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CardService _cardService = CardService();
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _userId == null
          ? Center(
              child: Text(
              'Faça login para ver seus cartões.',
              style: theme.textTheme.titleMedium,
            ))
          : StreamBuilder<QuerySnapshot<CreditCard>>(
              stream: _cardService.getCardsStream(_userId!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}', style: theme.textTheme.titleMedium));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allCards = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];

                if (allCards.isEmpty) {
                  return _buildEmptyState();
                }

                final bestCard = CardLogic.findBestCard(allCards);
                final otherCards = allCards.where((card) => card.id != bestCard?.id).toList();

                final pfCards = otherCards.where((card) => card.type == CardType.PF).toList();
                final pjCards = otherCards.where((card) => card.type == CardType.PJ).toList();

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      pinned: true,
                      centerTitle: true,
                      title: Text(
                        'CardFlow',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 24
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () => FirebaseAuth.instance.signOut(),
                          tooltip: 'Sair',
                        ),
                      ],
                    ),

                    // Highlighted Card Section or Warning
                    if (bestCard != null)
                      _buildHighlightedCardSection('🔥 Use Hoje!', bestCard)
                    else
                      _buildNoBestCardWarning(),

                    if (pfCards.isNotEmpty)
                      _buildCardSection('Pessoal', pfCards),
                      
                    if (pjCards.isNotEmpty)
                      _buildCardSection('Empresarial', pjCards),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100), // Space for FAB
                    )
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCardPage()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Adicionar Cartão', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white)),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
  
  Widget _buildNoBestCardWarning() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.5))
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Nenhum cartão está no período ideal de compra hoje.",
                  style: GoogleFonts.poppins(color: Colors.orangeAccent, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedCardSection(String title, CreditCard card) {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFFACC15), // Yellow for highlighted
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 16.0),
              child: Text(title, style: titleStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: CardWidget(card: card, isHighlighted: true),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.credit_card_off_rounded, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Nenhum cartão encontrado',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
           Text(
            'Adicione um novo cartão para começar.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(String title, List<CreditCard> cards) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 16.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color
                ),
              ),
            ),
            ...cards.map((card) {
               return Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10.0),
                 child: CardWidget(card: card),
               );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
