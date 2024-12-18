import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/local_database_controller.dart';
import '../utils/user_manager.dart';

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
  /////////////////////////////////////////FIRESTORE/////////////////////////////////////////
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

  void publishEvent() async {
    await FirebaseFirestore.instance
    .collection('events')
    .doc(this.eventId)
    .set(this.toFirestore());
  }

  static Future<List<EventModel>> getEventsByUser(String userId) async {
    // If the user is the current user, get the events from the local database
    if(userId == UserManager.currentUserId){
      return await DatabaseController.getEventsByUser(userId);
    }
    // Else if the user is not the current user, get the events from the firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
  }
  

  static Future<int> getEventsCountByUser(String userId) async {
    // If the user is the current user, get the events count from the local database
    if(userId == UserManager.currentUserId){
      return await DatabaseController.getEventsCountByUser(userId);
    }
    // Else if the user is not the current user, get the events count from the firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .get();

    return querySnapshot.docs.length;
  }

  /////////////////////////////////////////SQLITE/////////////////////////////////////////
  
  // Map for SQLite Database
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'name': name,
      'category': category,
      'date': date.seconds, // Convert Timestamp to seconds
      'status': status,
      'location': location,
      'createdAt': createdAt.seconds, // Convert Timestamp to seconds
    };
  }

  // Map from SQLite Database
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventId: map['eventId'],
      userId: map['userId'],
      name: map['name'],
      category: map['category'],
      date: Timestamp.fromMillisecondsSinceEpoch(map['date']),
      status: map['status'],
      location: map['location'],
      createdAt: Timestamp.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  static Future<void> createEvent(EventModel event) async {
    // await FirebaseFirestore.instance.collection('events').doc(event.eventId).set(event.toFirestore());
    await DatabaseController.upsertEvent(event);
  }

  // Update an existing event in the local database
  static Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    await DatabaseController.updateEvent(eventId, data);
  }

  // Delete event from the local database
  static Future<void> deleteEvent(String eventId) async {
    await DatabaseController.deleteEvent(eventId);
  }

  // Generate a new event ID locally
  static String generateEventId() {
    return DatabaseController.generateId();
  }

}
