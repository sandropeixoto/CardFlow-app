
import 'package:cloud_firestore/cloud_firestore.dart';

// Enum for card type (Personal or Business)
// The values correspond to the "PF" and "PJ" strings in Firestore.
enum CardType { PF, PJ }

// Enum for card status
enum CardStatus { active, archived }

class CreditCard {
  final String id; // Firestore document ID
  final String userId; // Owner user ID
  final String alias; // Custom card name (e.g., "Itaú Black")
  final CardType type; // PF (Personal) or PJ (Business)
  final String brand; // Brand (e.g., "Mastercard", "Visa")
  final int dueDay; // Invoice due day
  final int bestDay; // Best day for purchases
  final bool isAutoPay; // Is auto-pay enabled?
  final CardStatus status; // "active" or "archived"
  final String lastFourDigits; // Last four digits of the card
  final String cvv; // Security code

  CreditCard({
    required this.id,
    required this.userId,
    required this.alias,
    required this.type,
    required this.brand,
    required this.dueDay,
    required this.bestDay,
    required this.isAutoPay,
    required this.status,
    required this.lastFourDigits,
    required this.cvv,
  });

  // Factory constructor to create a CreditCard from a Firestore document
  factory CreditCard.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final sensitiveData = data['sensitiveData'] as Map<String, dynamic>? ?? {};

    return CreditCard(
      id: doc.id,
      userId: data['userId'] ?? '',
      alias: data['alias'] ?? 'N/A',
      type: (data['type'] == 'PJ') ? CardType.PJ : CardType.PF,
      brand: data['brand'] ?? 'N/A',
      dueDay: data['dueDay'] ?? 0,
      bestDay: data['bestDay'] ?? 0,
      isAutoPay: data['isAutoPay'] ?? false,
      status: (data['status'] == 'archived') ? CardStatus.archived : CardStatus.active,
      // Nested sensitive data
      lastFourDigits: sensitiveData['lastFourDigits'] ?? '0000',
      cvv: sensitiveData['cvv'] ?? '000',
    );
  }

  // Method to convert the CreditCard object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'alias': alias,
      'type': type == CardType.PJ ? 'PJ' : 'PF',
      'brand': brand,
      'dueDay': dueDay,
      'bestDay': bestDay,
      'isAutoPay': isAutoPay,
      'status': status == CardStatus.archived ? 'archived' : 'active',
      'sensitiveData': {
        'lastFourDigits': lastFourDigits,
        'cvv': cvv,
      },
    };
  }
}
