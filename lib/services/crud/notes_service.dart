// import 'dart:async';

// import 'package:notester/extensions/list/filter.dart';
// import 'package:notester/services/crud/crud_exceptions.dart';
// import 'package:notester/services/crud/local_storage_constants.dart';
// import 'package:flutter/widgets.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class NotesService {
//   Database? _db;

//   List<DatabaseNote> _notes = [];

//   DatabaseUser? _user;

//   // Creating a singleton
//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(onListen: () {
//       _notesStreamController.sink.add(_notes);
//     });
//   }
//   factory NotesService() => _shared;
//   // late final _notesStreamController = StreamController<List<DatabaseNote>>.broadcast();
//   late final StreamController<List<DatabaseNote>> _notesStreamController;

//   // Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;
//   Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });

//   Future<void> _ensureDbisOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty
//     }
//   }

//   Future<DatabaseUser> getOrCreateuser({required String email, bool setAsCurrentUser = true}) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createduser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createduser;
//       }
//       return createduser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();

//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Database _getDatabaseorThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getDatabasesPath();
//       final dbPath = join(docsPath, dbName);

//       final db = await openDatabase(dbPath);
//       _db = db;
//       debugPrint("$_db");
//       // Create user table
//       await db.execute(createUserTable);
//       // Create note table
//       await db.execute(createNoteTable);

//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();

//     final results = await db.query(userTable, limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DatabaseUser(id: userId, email: email);
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();

//     final results = await db.query(userTable, limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);
//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       // print(results[0]["email"]);
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();
//     final deleteCount = await db.delete(userTable, where: 'email = ?', whereArgs: [email.toLowerCase()]);
//     if (deleteCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   // Notes
//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();

//     // Make sure owner exits in the database with the correct id
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }

//     // Create the note
//     const text = '';
//     final noteId = await db.insert(noteTable, {userIdColumn: owner.id, textColumn: text, isSyncedWithCloudColumn: 1});
//     final note = DatabaseNote(id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);

//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();

//     final notes = await db.query(noteTable, limit: 1, where: 'id = ?', whereArgs: [id]);
//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();
//     final notes = await db.query(noteTable);
//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();
//     final deleteCount = await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
//     if (deleteCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNote> updateNote({required DatabaseNote note, required String text}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();

//     // Make sure notes exists
//     await getNote(id: note.id);

//     // Update db
//     final updateCount = await db.update(
//       noteTable,
//       {textColumn: text, isSyncedWithCloudColumn: 0},
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );

//     if (updateCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseorThrow();
//     final numberOfDeletions = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletions;
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       _db = null;
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({required this.id, required this.email});

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   const DatabaseNote({required this.id, required this.userId, required this.text, required this.isSyncedWithCloud});

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() => 'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }
