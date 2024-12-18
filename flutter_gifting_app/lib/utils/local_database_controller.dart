import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For Timestamp to DateTime conversion
import 'package:uuid/uuid.dart';
import '../models/event.dart';

class DatabaseController {
  static Database? _database;

  // Initialize the SQLite Database
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // Initialize the database
    _database = await openDatabase(
      join(await getDatabasesPath(), 'local_storage.db'),
      onCreate: (db, version) {
        return db.execute(
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
      },
      version: 1,
    );
    return _database!;
  }

  // Method to initialize the database explicitly
  static Future<void> initialize() async {
    await database; // This will trigger the database creation if it hasn't been done yet
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
    final maps = await db.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return EventModel.fromMap(maps[i]);
    });
  }

  // Upload local data to Firestore
  static Future<void> uploadLocalDataToFirestore() async {
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
  static Future<void> syncFirestoreDataToLocal(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('user_id', isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      EventModel event = EventModel.fromFirestore(doc);
      await upsertEvent(event);
    }
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

  // Delete event from the local database
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

  // Generate a new ID locally (UUID)
  static String generateId() {
    return Uuid().v4();
  }

  // Get the count of events by user from the local database
  static Future<int> getEventsCountByUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.length;
  }


  // Delets documents from firestore
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

}