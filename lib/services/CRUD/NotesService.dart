import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_codebootcamp/services/CRUD/NoteExcptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class NotesService {
  Database? _db;

  Future<DatabaseNote> UpdateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDbOrThrow();
    await getNote(noteId: note.id);
    final updateCount = await db.update(
      noteTableName,
      {textColumn: text, isSyncedColumn: 0},
    );
    if (updateCount == 0) {
      throw CoundNotUpdateNoteExcption();
    } else {
      return getNote(noteId: note.id);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote({required int userId}) async {
    final db = _getDbOrThrow();
    final notes = await db.query(
      noteTableName,
    );

    final result = notes.map((noteRow) => DatabaseNote.fromRow(noteRow));

    if (notes.isNotEmpty) {
      throw CouldNotFoundNoteExcption();
    } else {
      return result;
    }
  }

  Future<DatabaseNote> getNote({required int noteId}) async {
    final db = _getDbOrThrow();
    final notes = await db.query(
      noteTableName,
      limit: 1,
      where: 'id = ?',
      whereArgs: [noteId],
    );

    if (notes.isNotEmpty) {
      throw CouldNotFoundNoteExcption();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<int> deleteAllNote({required int userid}) async {
    final db = _getDbOrThrow();
    final int deleteNoteCount = await db.delete(
      noteTableName,
      where: 'user_id = ?',
      whereArgs: [userid],
    );
    return deleteNoteCount;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDbOrThrow();
    final int deletedCount = await db.delete(
      noteTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CoundNoteDeleteNoteException();
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final Database db = _getDbOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw UserNotFoundException();
    }
    const String text = '';
    final int noteId = await db.insert(noteTableName, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedColumn: 1,
    });

    final DatabaseNote note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSynced: true,
    );
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDbOrThrow();
    final List<Map<String, Object?>> result = await db.query(
      userTableName,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (!result.isNotEmpty) {
      throw UserNotFoundException();
    } else {
      return DatabaseUser.fromRow(
        result.first,
      );
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final Database db = _getDbOrThrow();
    final List<Map<String, Object?>> result = await db.query(
      userTableName,
      where: 'email = ?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw UserAlreadyExistException();
    }
    final int userId = await db.insert(
      userTableName,
      {emailColumn: email.toLowerCase()},
    );

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DBisNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final Directory docsPath = await getApplicationDocumentsDirectory();
      final String dbPath = join(docsPath.path, dbName);
      final Database db = await openDatabase(dbPath);

      //Create user Talbe
      await db.execute(createUserTable);
      //Create Note Table
      await db.execute(createNoteTable);

      _db = db;
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }

  Future<void> deleteUser({required String email}) async {
    final Database db = _getDbOrThrow();
    final int deleteCount = await db.delete(
      userTableName,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount == 0) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDbOrThrow() {
    final db = _db;
    if (db == null) {
      throw DBisNotOpenException();
    } else {
      return db;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Pesron,id = $id , email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynced;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSynced,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSynced = (map[isSyncedColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note,id = $id , userId = $userId, text = $text ,isSynced = $isSynced';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'note.db';
const userTableName = 'user';
const noteTableName = 'note';

const textColumn = 'text';
const userIdColumn = 'user_id';
const idColumn = 'id';
const emailColumn = 'email';
const isSyncedColumn = 'is_synced';

//Create User Table
const String createUserTable = '''
      CREATE TABLE IF NOTE EXIST "user"  (
      	"id"	INTEGER NOT NULL UNIQUE,
      	"email"	TEXT NOT NULL UNIQUE,
      	PRIMARY KEY("id" AUTOINCREMENT)
      );''';

//Create Notes Table
const String createNoteTable = '''
      CREATE TABLE IF NOTE EXIST "note" (
      	"id"	INTEGER NOT NULL UNIQUE,
      	"user_id"	INTEGER NOT NULL,
      	"text"	TEXT,
      	"is_synced"	INTEGER NOT NULL DEFAULT 0,
      	PRIMARY KEY("id" AUTOINCREMENT),
      	FOREIGN KEY("user_id") REFERENCES "user"("id")
      );
      ''';
