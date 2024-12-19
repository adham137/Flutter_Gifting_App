import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For Timestamp to DateTime conversion
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../models/gift.dart';

class DatabaseController {
  static Database? _database;

  // Initialize the SQLite Database
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await openDatabase(
      join(await getDatabasesPath(), 'local_storage.db'),
      onCreate: (db, version) async {
        // Creating 'events' table
        await db.execute(
          '''
          CREATE TABLE events(
            eventId TEXT PRIMARY KEY,
            userId TEXT,
            name TEXT,
            category TEXT,
            date INTEGER,
            status TEXT,
            location TEXT,
            createdAt INTEGER
          )
          ''',
        );

        // Creating 'gifts' table
        await db.execute(
          '''
          CREATE TABLE gifts(
            giftId TEXT PRIMARY KEY,
            eventId TEXT,
            creatorId TEXT,
            name TEXT,
            description TEXT,
            category TEXT,
            price REAL,
            imageUrl TEXT,
            status TEXT,
            pledgedBy TEXT,
            FOREIGN KEY (eventId) REFERENCES events(eventId)
          )
          ''',
        );
      },
      version: 1,
    );
    return _database!;
  }


  // Method to initialize the database explicitly
  static Future<void> initialize() async {
    await database; // This will trigger the database creation if it hasn't been done yet
  }


  // Upload local data to Firestore
  static Future<void> uploadLocalDataToFirestore() async {
    await uploadLocalEventsToFirestore();
    await uploadLocalGiftsToFirestore();
  }


  // Upload local events to Firestore
  static Future<void> syncFirestoreDataToLocal(String userId) async {
    await syncFirestoreEventsToLocal(userId);
    await syncFirestoreGiftsToLocal(userId);
  }


  // Delets document from firestore
  static Future<void> deleteDocumentById(String documentId, String collection) async {
    // Reference to the Firestore collection
    final collectionRef = FirebaseFirestore.instance.collection(collection);

    // Get the document by its documentId
    final doc = await collectionRef.doc(documentId).get();

    // Check if the document exists
    if (doc.exists) {
      // If document exists, delete it
      await doc.reference.delete();
      print('Document with ID $documentId has been deleted from collection $collection.');
    } else {
      // If document does not exist, do nothing
      print('Document with ID $documentId not found in collection $collection.');
    }
  }


  // Generate a new ID locally (UUID)
  static String generateId() {
    return Uuid().v4();
  }


  /////////////////////////////////////// EVENTS FUNCTIONALITIES ///////////////////////////////////////


  // Get event from local database
  static Future<EventModel?> getEvent(String eventId) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );

    if (maps.isNotEmpty) {
      return EventModel.fromMap(maps.first);
    } else {
      return null;
    }
  }


  // Get all events by userId from local database
  static Future<List<EventModel>> getEventsByUser(String userId) async {
    final db = await database;
    try {
      // Query the database for events related to the userId
      final maps = await db.query(
        'events',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      // Return the list of events if there are any
      return List.generate(maps.length, (i) {
        return EventModel.fromMap(maps[i]);
      });
    } catch (e) {
      // Log the error to the console for debugging
      print('Error fetching events for userId $userId: $e');

      // Return an empty list in case of an error
      return [];
    }
  }


  // Upload local data to Firestore
  static Future<void> uploadLocalEventsToFirestore() async {
    final db = await database;
    final maps = await db.query('events');

    for (var map in maps) {
      EventModel event = EventModel.fromMap(map);
      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.eventId)
          .set(event.toFirestore());
    }
  }


  // Sync Firestore data to local SQLite database
  static Future<void> syncFirestoreEventsToLocal(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      EventModel event = EventModel.fromFirestore(doc);
      await upsertEvent(event);
    }
  }


  // Insert or Update event in the local database
  static Future<void> upsertEvent(EventModel event) async {
    final db = await database;

    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  // Update an existing event in the local database
  static Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    final db = await database;
    try {
      await db.update(
      'events',
      data,
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    } catch (e) {
      print('Error updating event: $e');
    }

  }


  // Delete event from the local database //////////////////////////////////////////// <-- YOU NEED TO DELETE THE GIFTS ASSOCIATED WITH THE EVENT
  static Future<void> deleteEvent(String eventId) async {
    final db = await database;
    try {
      await db.delete(
      'events',
      where: 'eventId = ?',
      whereArgs: [eventId],
      );
      // Delete the event from Firestore
      deleteDocumentById(eventId, 'events');
      // YOU NEED TO DELETE THE GIFTS ASSOCIATED WITH THE EVENT FROM THE SQLITE AND FIRESTORE
    } catch (e) {
      print('Error deleting event: $e');
    }

  }


  // Get the count of events by userId from the local database
  static Future<int> getEventsCountByUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.length;
  }


  /////////////////////////////////////// GIFTS FUNCTIONALITIES ///////////////////////////////////////


  // Update the status of a gift, Called when notified about a change in status  
  static void updateGiftStatus(String giftId, String status) async {
    final db = await database;
    try {
      await db.update(
        'gifts',
        {'status': status},
        where: 'giftId = ?',
        whereArgs: [giftId],
      );
    } catch (e) {
      print('Error updating gift status: $e');
    }
  }


  // Fetch gifts by eventId
  static Future<List<GiftModel>> getGiftsByEventId(String eventId) async {
    final db = await database;
    final maps = await db.query(
      'gifts',
      where: 'eventId = ?',
      whereArgs: [eventId],
    );

    // If there are gifts related to the event, map them to GiftModel
    return List.generate(maps.length, (i) {
      return GiftModel.fromMap(maps[i]);
    });
  }


  // Fetch gifts by creatorId
  static Future<List<GiftModel>> getGiftsByUserId(String creatorId) async {
    final db = await database;
    final maps = await db.query(
      'gifts',
      where: 'creatorId = ?',
      whereArgs: [creatorId],
    );

    // If there are gifts related to the creator, map them to GiftModel
    return List.generate(maps.length, (i) {
      return GiftModel.fromMap(maps[i]);
    });
  }
 
 
  // Delete a gift from the database
  static Future<void> deleteGift(String giftId) async {
    final db = await database;
    try {
      await db.delete(
        'gifts',
        where: 'giftId = ?',
        whereArgs: [giftId],
      );
      // Also delete the gift from Firestore
      deleteDocumentById(giftId, 'gifts');
    } catch (e) {
      print('Error deleting gift: $e');
    }
  }
  
  
  // Update an existing gift in the database
  static Future<void> updateGift(String giftId, Map<String, dynamic> data) async {
    final db = await database;
    try {
      await db.update(
        'gifts',
        data,
        where: 'giftId = ?',
        whereArgs: [giftId],
      );
    } catch (e) {
      print('Error updating gift: $e');
    }
  }
  
  
  // Insert or Update a gift in the database
  static Future<void> upsertGift(GiftModel gift) async {
    final db = await database;

    await db.insert(
      'gifts',
      gift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Will replace if the giftId exists
    );
  }


  // Upload local gifts data to Firestore
  static Future<void> uploadLocalGiftsToFirestore() async {
    final db = await database;
    final maps = await db.query('gifts');

    for (var map in maps) {
      GiftModel gift = GiftModel.fromMap(map);
      await FirebaseFirestore.instance
          .collection('gifts')
          .doc(gift.giftId)
          .set(gift.toFirestore());
    }
  }


  // Sync Firestore gifts data to local SQLite database
  static Future<void> syncFirestoreGiftsToLocal(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('gifts')
        .where('creator_id', isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      GiftModel gift = GiftModel.fromFirestore(doc);
      await upsertGift(gift);
    }
  }


}