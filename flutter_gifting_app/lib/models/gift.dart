import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/local_database_controller.dart';
import '../utils/user_manager.dart';
import 'user.dart';

class GiftModel {
  String giftId;
  String eventId;
  String creatorId;
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
    required this.creatorId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.status,
    this.pledgedBy,
  });
  ///////////////////////////// FIRESTORE /////////////////////////////
  factory GiftModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GiftModel(
      giftId: doc.id,
      eventId: data['event_id'],
      creatorId: data['creator_id'],
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
      'creator_id': creatorId,
      'description': description,
      'category': category,
      'price': price,
      'image_url': imageUrl,
      'status': status,
      'pledged_by': pledgedBy,
    };
  }

  Future<bool?> publishGift() async {
    try{
      await FirebaseFirestore.instance
          .collection('gifts')
          .doc(this.giftId)
          .set(this.toFirestore());
      return true;  
    } catch (e) {
      print('Error publishing gift: $e');
      return false;
    }
  }

  static Future<List<GiftModel>> getGiftsByEvent(String eventId) async {
    // If it is my event, get the gifts from the local database
    if(DatabaseController.getEvent(eventId) != null){
      return await DatabaseController.getGiftsByEventId(eventId);
    }
    // Else if it is not my event, get the gifts from the firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('gifts')
        .where('event_id', isEqualTo: eventId)
        .get();
    return querySnapshot.docs.map((doc) => GiftModel.fromFirestore(doc)).toList();
  }

  static Future<List<GiftModel>> getGiftsByUser(String creatorId) async {
    // If it is my gifts, get the gifts from the local database
    if(UserManager.currentUserId == creatorId){
      return await DatabaseController.getGiftsByUserId(creatorId);
    }
    // Else if it is not my gifts, get the gifts from the firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('gifts')
        .where('creator_id', isEqualTo: creatorId)
        .get();
    return querySnapshot.docs.map((doc) => GiftModel.fromFirestore(doc)).toList();
  }

   // Pledge the gift
  Future<void> pledgeGift() async {
    String currentUserId = UserManager.currentUserId ?? '';
    if (status == 'Available' && creatorId != currentUserId) {
      status = 'Pledged';
      pledgedBy = currentUserId;
      await FirebaseFirestore.instance.collection('gifts').doc(giftId).update(toFirestore());

      var pledgerName = await UserModel.getUser(UserManager.currentUserId!).then((user) => user?.name) ?? 'a Friend';

      // Notifying the creator of the gift
      String? fcmToken = await UserModel.getFcmToken(creatorId);
      await UserManager.fcmService!.sendNotification(
        fcmToken: fcmToken!,
        title: 'Gift Pledged by $pledgerName !',
        body: '''$pledgerName has pledged your gift '$name' ! 🎉''',
        data: {
          'giftId': giftId,
          'status': status,
        }
      );
      print('########################### Sentt');
    }
  }

  // Unpledge the gift
  Future<void> unpledgeGift() async {
    if (status == 'Pledged' && pledgedBy == UserManager.currentUserId) {
      status = 'Available';
      pledgedBy = null;
      await FirebaseFirestore.instance.collection('gifts').doc(giftId).update(toFirestore());
    }

    var pledgerName = await UserModel.getUser(UserManager.currentUserId!).then((user) => user?.name) ?? 'a Friend';

    // Notifying the creator of the gift
    String? fcmToken = await UserModel.getFcmToken(creatorId);
    await UserManager.fcmService!.sendNotification(
      fcmToken: fcmToken!,
      title: 'Gift Un-Pledged by $pledgerName !',
      body: '''$pledgerName has un-pledged your gift '$name' ! 😢''',
      data: {
        'giftId': giftId,
        'status': status,
      }
    );
    print('########################### Sentt');
  }

  static Future<List<GiftModel>> getMyPledgedGifts() async {
    final userId = UserManager.currentUserId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('gifts')
        .where('pledged_by', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) => GiftModel.fromFirestore(doc)).toList();
  }



  ///////////////////////////// SQLITE /////////////////////////////
  Map<String, dynamic> toMap() {
    return {
      'giftId': giftId,
      'eventId': eventId,
      'creatorId': creatorId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'status': status,
      'pledgedBy': pledgedBy,
    };
  }

  factory GiftModel.fromMap(Map<String, dynamic> map) {
    return GiftModel(
      giftId: map['giftId'],
      eventId: map['eventId'],
      creatorId: map['creatorId'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      pledgedBy: map['pledgedBy'],
    );
  }

  static Future<void> createGift(GiftModel gift) async {
    await DatabaseController.upsertGift(gift);
  }

  static Future<void> updateGift(String giftId, Map<String, dynamic> data) async {
    await DatabaseController.updateGift(giftId, data);
  }

  static Future<void> deleteGift(String giftId) async {
    await DatabaseController.deleteGift(giftId);
  }

  static String generateGiftId() {
    return DatabaseController.generateId();
  }

}
