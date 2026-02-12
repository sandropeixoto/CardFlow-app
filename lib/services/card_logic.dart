import 'package:card_flow/models/card_model.dart';
import 'package:card_flow/models/recommendation_result.dart';

class CardLogic {
  static RecommendationResult findBestCard(List<CreditCard> cards) {
    if (cards.isEmpty) {
      return RecommendationResult(); // Retorna um resultado vazio se não houver cartões
    }

    final now = DateTime.now();

    // 1. FILTRAR por "Melhor Escolha": hoje >= melhorDia
    var eligibleCards = cards.where((card) {
      return now.day >= card.bestDay;
    }).toList();

    // Se tivermos pelo menos um cartão de "melhor escolha"
    if (eligibleCards.isNotEmpty) {
      // 2. ORDENAR: Encontrar o cartão com a data de vencimento mais distante
      eligibleCards.sort((a, b) {
        final daysA = calculateDaysUntilDue(a, now);
        final daysB = calculateDaysUntilDue(b, now);
        return daysB.compareTo(daysA); // Ordem decrescente para ter mais dias
      });

      final bestCard = eligibleCards.first;
      final daysToPay = calculateDaysUntilDue(bestCard, now);

      // Retornar como a melhor escolha
      return RecommendationResult(
        card: bestCard,
        isBestChoice: true,
        daysUntilNextWindow: daysToPay, // Neste contexto, são os dias para pagar
      );
    }
    // ----- LÓGICA DE FALLBACK: "Próxima Janela de Oportunidade" -----
    else {
      // Ordenar todos os cartões pelo melhor dia para encontrar o mais próximo no futuro
      cards.sort((a, b) => a.bestDay.compareTo(b.bestDay));

      // Encontrar o primeiro cartão cujo melhor dia é depois do dia de hoje
      var nextCard = cards.firstWhere(
        (c) => c.bestDay > now.day,
        orElse: () => cards.first, // Se nenhum, a próxima janela é no próximo mês com o menor melhor dia
      );

      int daysRemaining;

      // Se o próximo melhor dia for no mês atual
      if (nextCard.bestDay > now.day) {
        daysRemaining = nextCard.bestDay - now.day;
      }
      // Caso contrário, é no próximo mês
      else {
        // Dias restantes no mês atual
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        final remainingInThisMonth = daysInMonth - now.day;

        // Dias até o melhor dia no próximo mês
        daysRemaining = remainingInThisMonth + nextCard.bestDay;
      }

      return RecommendationResult(
        card: nextCard,
        isBestChoice: false,
        daysUntilNextWindow: daysRemaining,
      );
    }
  }

  /// Calcula quantos dias faltam para pagar a fatura se a compra for feita HOJE.
  static int calculateDaysUntilDue(CreditCard card, DateTime purchaseDate) {
    // A lógica assume que purchaseDate.day >= card.bestDay
    int targetMonth = purchaseDate.month + 1;
    int targetYear = purchaseDate.year;

    if (targetMonth > 12) {
      targetMonth = 1;
      targetYear += 1;
    }

    final dueDate = DateTime(targetYear, targetMonth, card.dueDay);
    return dueDate.difference(purchaseDate).inDays;
  }
}
