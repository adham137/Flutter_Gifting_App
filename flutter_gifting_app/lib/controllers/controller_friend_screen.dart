import '../models/event.dart';
import '../models/gift.dart';

class EventsAndGiftsController {
  Future<List<EventModel>> fetchEvents(String userId) async {
    try {
      return await EventModel.getEventsByUser(userId);
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<List<GiftModel>> fetchGifts(String userId) async {
    try {
      return await GiftModel.getGiftsByUser(userId); // Assuming a similar model method exists
    } catch (e) {
      print('Error fetching gifts: $e');
      return [];
    }
  }

  List<EventModel> filterEvents(List<EventModel> events, String query) {
    return events
        .where((event) => event.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<GiftModel> filterGifts(List<GiftModel> gifts, String query) {
    return gifts
        .where((gift) => gift.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<EventModel> sortEventsByDate(List<EventModel> events) {
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  List<GiftModel> sortGiftsByName(List<GiftModel> gifts) {
    gifts.sort((a, b) => a.name.compareTo(b.name));
    return gifts;
  }
}
