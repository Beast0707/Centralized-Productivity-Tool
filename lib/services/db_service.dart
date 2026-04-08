import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
import '../models/note_model.dart';
import '../models/event_model.dart';

class DBService {
  static final DBService instance = DBService._init();

  static Database? _database;

  DBService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

//DB CREATION

  Future _createDB(Database db, int version) async {
    //tasks table creation 
    await db.execute('''
                          CREATE TABLE "tasks" (
                           "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                           "title" TEXT NOT NULL,
                           "description" TEXT,
                           "date" TEXT,
                           "is_completed" INTEGER DEFAULT 0,
                           "created_at" TEXT,
                           "updated_at" TEXT
                          )
                          ''');
    //note table creation
    await db.execute('''
                          CREATE TABLE "notes" (
                           "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                           "title" TEXT NOT NULL,
                           "content" TEXT,
                           "created_at" TEXT,
                           "updated_at" TEXT
                          )
                          ''');
    //events table creation
    await db.execute('''
                          CREATE TABLE "events" (
                           "id" INTEGER PRIMARY KEY AUTOINCREMENT,
                           "title" TEXT NOT NULL,
                           "date" TEXT,
                           "created_at" TEXT,
                           "updated_at" TEXT
                          )
                          ''');
  }

  //TASK CRUD

  Future<int> insertTask(Task task) async {
    final db = await instance.database;

    final map = task.toMap();
    map.remove('id');

    final id = await db.insert('tasks', map);

    return id;
  }

  Future<List<Task>> getTasksByDate(DateTime date) async {
    final db = await instance.database;

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final results = await db.query(
      'tasks',
      where: 'date >= ? AND date < ?',
      whereArgs: [
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
        ],
    );

    final tasks = results.map((map) => Task.fromMap(map)).toList();

    return tasks;
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;

    final map = task.toMap();
    map.remove('id');

    final result = await db.update(
      'tasks',
      map,
      where: 'id = ?',
      whereArgs: [task.id],
    );

    return result;
  }

  Future<int> toggleTaskCompletion(Task task) async {
    final db = await instance.database;

    int newStatus = (task.isCompleted == 1) ? 0 : 1;

    final result = await db.update(
      'tasks',
      {
        'is_completed': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );

    return result;
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;

    final result = await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  //NOTES CRUD

  Future<int> insertNote(Note note) async {
    final db = await instance.database;

    final map = note.toMap();
    map.remove('id');

    final id = await db.insert('notes', map);

    return id;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;

    final results = await db.query(
      'notes',
      orderBy: 'created_at DESC',
    );

    return results.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    final map = note.toMap();
    map.remove('id');

    final result = await db.update(
      'notes',
      map,
      where: 'id = ?',
      whereArgs: [note.id],
    );

    return result;
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    final result = await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  //EVENTS CRUD
  Future<int> insertEvent(Event event) async {
    final db = await instance.database;

    final map = event.toMap();
    map.remove('id');

    final id = await db.insert('events', map);

    return id;
  }

  Future<List<Event>> getEventsByDate(DateTime date) async {
    final db = await instance.database;

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final results = await db.query(
      'events',
      where: 'date >= ? AND date < ?',
      whereArgs: [
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
    );

    return results.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> updateEvent(Event event) async {
    final db = await instance.database;

    final map = event.toMap();
    map.remove('id');

    final result = await db.update(
      'events',
      map,
      where: 'id = ?',
      whereArgs: [event.id],
    );

    return result;
  }

  Future<int> deleteEvent(int id) async {
    final db = await instance.database;

    final result = await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }
}