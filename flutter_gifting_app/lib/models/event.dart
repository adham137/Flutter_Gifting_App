import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String eventId;
  String userId;
  String name;
  String category;
  Timestamp date;
  String status;
  String? location;
  Timestamp createdAt;

  EventModel({
    required this.eventId,
    required this.userId,
    required this.name,
    required this.category,
    required this.date,
    required this.status,
    this.location,
    required this.createdAt,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      eventId: doc.id,
      userId: data['user_id'],
      name: data['name'],
      category: data['category'],
      date: data['date'],
      status: data['status'],
      location: data['location'],
      createdAt: data['created_at'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'name': name,
      'category': category,
      'date': date,
      'status': status,
      'location': location,
      'created_at': createdAt,
    };
  }

  static Future<void> createEvent(EventModel event) async {
    await FirebaseFirestore.instance.collection('events').doc(event.eventId).set(event.toFirestore());
  }

  static Future<EventModel?> getEvent(String eventId) async {
    final doc = await FirebaseFirestore.instance.collection('events').doc(eventId).get();
    return doc.exists ? EventModel.fromFirestore(doc) : null;
  }

  static Future<List<EventModel>> getEventsByUser(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
  }
  

  static Future<int> getEventsCountByUser(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .get();

    return querySnapshot.docs.length;
  }

  static Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('events').doc(eventId).update(data);
  }

  static Future<void> deleteEvent(String eventId) async {
    await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
  }
  static String generateEventId() {
    return FirebaseFirestore.instance.collection('events').doc().id;
  }
}
