import 'package:card_flow/models/card_model.dart';

class RecommendationResult {
  final CreditCard? card;
  final bool isBestChoice;
  final int daysUntilNextWindow;

  RecommendationResult({
    this.card,
    this.isBestChoice = false,
    this.daysUntilNextWindow = 0,
  });
}
