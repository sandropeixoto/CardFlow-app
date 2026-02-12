import 'package:card_flow/models/card_model.dart';
import 'package:card_flow/models/recommendation_result.dart';
import 'package:card_flow/pages/add_card_page.dart';
import 'package:card_flow/pages/profile_page.dart'; // Import the new profile page
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
  final User? _user = FirebaseAuth.instance.currentUser;

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

                final recommendation = CardLogic.findBestCard(allCards);
                final otherCards = allCards.where((card) => card.id != recommendation.card?.id).toList();

                final pfCards = otherCards.where((card) => card.type == CardType.PF).toList();
                final pjCards = otherCards.where((card) => card.type == CardType.PJ).toList();

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      elevation: 0,
                      pinned: true,
                      centerTitle: true,
                      title: Image.asset(
                        'assets/images/logo-cardflow-name-no-background.png',
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.deepPurple, // Fallback color
                              backgroundImage: _user?.photoURL != null
                                  ? NetworkImage(_user!.photoURL!)
                                  : null,
                              child: _user?.photoURL == null
                                  ? const Icon(Icons.person, color: Colors.white, size: 22)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),

                    _buildRecommendationSection(recommendation),

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
  
  Widget _buildRecommendationSection(RecommendationResult recommendation) {
    if (recommendation.card == null) {
      return _buildEmptyState(); // No cards registered
    }

    if (recommendation.isBestChoice) {
      return _buildHighlightedCardSection(
        '🔥 Use Hoje!',
        recommendation.card!,
        "Use este cartão para ganhar ${recommendation.daysUntilNextWindow} dias de prazo",
      );
    } else {
      return _buildNextWindowWarning(
        recommendation.card!,
        recommendation.daysUntilNextWindow,
      );
    }
  }

  Widget _buildNextWindowWarning(CreditCard card, int daysUntil) {
    final cardName = card.alias;
    String message;
    if (daysUntil == 1) {
        message = "A próxima janela abre em 1 dia com o cartão $cardName.";
    } else {
        message = "A próxima janela abre em $daysUntil dias com o cartão $cardName.";
    }

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
              const Icon(Icons.info_outline_rounded, color: Colors.orangeAccent),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Nenhum cartão está no melhor dia hoje. $message",
                  style: GoogleFonts.poppins(color: Colors.orangeAccent, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedCardSection(String title, CreditCard card, String subtitle) {
    final titleStyle = GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.greenAccent,
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0, top: 16.0),
              child: Text(title, style: titleStyle),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
              child: Text(
                subtitle,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
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
