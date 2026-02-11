import 'package:card_flow/models/card_model.dart';

class CardLogic {
  /// Returns the best card to use TODAY.
  /// Returns null if no card is in the optimal buying period.
  static CreditCard? findBestCard(List<CreditCard> cards) {
    final now = DateTime.now();

    // 1. FILTER: Only cards where today >= bestDay
    // This ensures the purchase falls into the NEXT billing cycle.
    var eligibleCards = cards.where((card) {
      return now.day >= card.bestDay;
    }).toList();

    if (eligibleCards.isEmpty) {
      return null; // No card is in the "green zone" for purchases today.
    }

    // 2. SORT: Find the card with the furthest due date.
    eligibleCards.sort((a, b) {
      final daysA = calculateDaysUntilDue(a, now);
      final daysB = calculateDaysUntilDue(b, now);
      
      // We want the HIGHEST number of days (Descending Order).
      return daysB.compareTo(daysA); 
    });

    // The first card in the sorted list is the winner.
    return eligibleCards.first;
  }

  /// Calculates how many days are left to pay the bill if a purchase is made TODAY.
  static int calculateDaysUntilDue(CreditCard card, DateTime purchaseDate) {
    // If today >= bestDay, the due date is in the next month.
    
    int targetMonth = purchaseDate.month + 1;
    int targetYear = purchaseDate.year;

    // Adjust for December -> January of the next year.
    if (targetMonth > 12) {
      targetMonth = 1;
      targetYear += 1;
    }

    // Create the actual due date.
    final dueDate = DateTime(targetYear, targetMonth, card.dueDay);

    // Return the difference in days.
    return dueDate.difference(purchaseDate).inDays;
  }
}
