import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<EventModel>> fetchMyEvents(String userId) async {
    return EventModel.getEventsByUser(userId);
  }

  Future<List<EventModel>> fetchFriendsEvents(String userId) async {
    final querySnapshot = await _firestore
        .collection('events')
        .where('user_id', isNotEqualTo: userId) // Fetching friends' events
        .get();
    return querySnapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
  }
}
