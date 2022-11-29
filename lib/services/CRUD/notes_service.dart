import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentDirectoryException implements Exception {}

class DBisNotOpenException implements Exception {}

class NotesService {
  Database? _db;

  Database _getDbOrThrow() {
    final db = _db;
    if (db == null) {
      throw DBisNotOpenException();
    } else {
      return db;
    }
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
  // TODO: implement hashCode
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
  // TODO: implement hashCode
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
