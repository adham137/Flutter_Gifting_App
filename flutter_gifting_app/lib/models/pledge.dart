import 'package:cloud_firestore/cloud_firestore.dart';

class PledgeModel {
  String pledgeId;
  String giftId;
  String eventId;
  String pledgedBy; // User ID of the person pledging
  Timestamp pledgedAt;

  PledgeModel({
    required this.pledgeId,
    required this.giftId,
    required this.eventId,
    required this.pledgedBy,
    required this.pledgedAt,
  });

  // Convert Firestore document to PledgeModel
  factory PledgeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PledgeModel(
      pledgeId: doc.id,
      giftId: data['gift_id'],
      eventId: data['event_id'],
      pledgedBy: data['pledged_by'],
      pledgedAt: data['pledged_at'],
    );
  }

  // Convert PledgeModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'gift_id': giftId,
      'event_id': eventId,
      'pledged_by': pledgedBy,
      'pledged_at': pledgedAt,
    };
  }

  // CRUD Methods
  static Future<void> createPledge(PledgeModel pledge) async {
    await FirebaseFirestore.instance.collection('pledges').doc(pledge.pledgeId).set(pledge.toFirestore());
  }

  static Future<PledgeModel?> getPledge(String pledgeId) async {
    final doc = await FirebaseFirestore.instance.collection('pledges').doc(pledgeId).get();
    return doc.exists ? PledgeModel.fromFirestore(doc) : null;
  }

  static Future<List<PledgeModel>> getPledgesByGift(String giftId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('pledges')
        .where('gift_id', isEqualTo: giftId)
        .get();
    return querySnapshot.docs.map((doc) => PledgeModel.fromFirestore(doc)).toList();
  }

  static Future<void> deletePledge(String pledgeId) async {
    await FirebaseFirestore.instance.collection('pledges').doc(pledgeId).delete();
  }
}
