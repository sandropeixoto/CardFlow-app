import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';

class CardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<CreditCard> _cardsRef;

  CardService() {
    _cardsRef = _firestore.collection('cards').withConverter<CreditCard>(
          fromFirestore: (snapshot, _) => CreditCard.fromFirestore(snapshot),
          toFirestore: (card, _) => card.toFirestore(),
        );
  }

  // Get a stream of cards for a specific user
  Stream<QuerySnapshot<CreditCard>> getCardsStream(String userId) {
    return _cardsRef.where('userId', isEqualTo: userId).snapshots();
  }

  // Add a new card
  Future<DocumentReference<CreditCard>> addCard(CreditCard card) {
    return _cardsRef.add(card);
  }

  // Update an existing card
  Future<void> updateCard(String cardId, CreditCard card) {
    return _cardsRef.doc(cardId).set(card, SetOptions(merge: true));
  }

  // Delete a card
  Future<void> deleteCard(String cardId) {
    return _cardsRef.doc(cardId).delete();
  }

  // Toggle the archive status of a card
  Future<void> toggleCardArchiveStatus(String cardId, CardStatus currentStatus) {
    final newStatus = currentStatus == CardStatus.active ? CardStatus.archived : CardStatus.active;
    return _cardsRef.doc(cardId).update({'status': newStatus.name});
  }
}
