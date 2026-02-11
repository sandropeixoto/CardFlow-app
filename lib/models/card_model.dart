enum CardType { pf, pj }

class CreditCard {
  final String id;
  final String nickname;
  final CardType type;
  final String brand;
  final int dueDay;
  final int bestDay;
  final bool isAutoPay;
  final String lastFourDigits;
  final String cvv;

  CreditCard({
    required this.id,
    required this.nickname,
    required this.type,
    required this.brand,
    required this.dueDay,
    required this.bestDay,
    this.isAutoPay = false,
    required this.lastFourDigits,
    required this.cvv,
  });
}
