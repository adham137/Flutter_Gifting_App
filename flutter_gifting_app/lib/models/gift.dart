import 'package:cloud_firestore/cloud_firestore.dart';

class GiftModel {
  String giftId;
  String eventId;
  String name;
  String description;
  String category;
  double price;
  String? imageUrl;
  String status;
  String? pledgedBy;

  GiftModel({
    required this.giftId,
    required this.eventId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.status,
    this.pledgedBy,
  });

  factory GiftModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GiftModel(
      giftId: doc.id,
      eventId: data['event_id'],
      name: data['name'],
      description: data['description'],
      category: data['category'],
      price: data['price'],
      imageUrl: data['image_url'],
      status: data['status'],
      pledgedBy: data['pledged_by'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'event_id': eventId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image_url': imageUrl,
      'status': status,
      'pledged_by': pledgedBy,
    };
  }

  static Future<void> createGift(GiftModel gift) async {
    await FirebaseFirestore.instance.collection('gifts').doc(gift.giftId).set(gift.toFirestore());
  }

  static Future<List<GiftModel>> getGiftsByEvent(String eventId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('gifts')
        .where('event_id', isEqualTo: eventId)
        .get();
    return querySnapshot.docs.map((doc) => GiftModel.fromFirestore(doc)).toList();
  }

  static Future<void> updateGift(String giftId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('gifts').doc(giftId).update(data);
  }

  static Future<void> deleteGift(String giftId) async {
    await FirebaseFirestore.instance.collection('gifts').doc(giftId).delete();
  }
}
