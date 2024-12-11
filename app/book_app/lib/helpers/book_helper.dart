import 'package:book_app/models/book_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE books (id INTEGER PRIMARY KEY, title TEXT, author TEXT, year INTEGER)',
        );
      },
    );
  }

  // Operações CRUD
  Future<int> insertBook(Book book) async {
    Database db = await database;
    return await db.insert('books', book.toMap());
  }

  Future<List<Book>> getBooks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<int> updateBook(Book book) async {
    Database db = await database;
    return await db.update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> deleteBook(int id) async {
    Database db = await database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}