import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/event_dao.dart';
import '../database/note_dao.dart';
import '../database/task_dao.dart';

import '../models/task_model.dart' as app_model;
import '../models/note_model.dart' as app_model;
import '../models/event_model.dart' as app_model;

class DBService {
  DBService._internal() {
    _database = AppDatabase();
    _taskDao = TaskDao(_database);
    _noteDao = NoteDao(_database);
    _eventDao = EventDao(_database);
  }

  static final DBService instance = DBService._internal();

  late final AppDatabase _database;
  late final TaskDao _taskDao;
  late final NoteDao _noteDao;
  late final EventDao _eventDao;

  // ============================================================
  // DATABASE
  // ============================================================

  AppDatabase get database => _database;

  Future<void> close() {
    return _database.close();
  }

  // ============================================================
  // TASKS
  // ============================================================

  Future<int> insertTask(app_model.Task task) {
    return _taskDao.insertTask(
      TasksCompanion(
        title: Value(task.title ?? ''),
        description: Value(task.description),
        date: Value(task.date?.toIso8601String()),
        isCompleted: Value(task.isCompleted ?? 0),
        createdAt: Value(task.createdAt?.toIso8601String()),
        updatedAt: Value(task.updatedAt?.toIso8601String()),
      ),
    );
  }

  Future<List<app_model.Task>> getAllTasks() async {
    final rows = await _taskDao.getAllTasks();
    return rows.map(_taskFromDrift).toList();
  }

  Future<List<app_model.Task>> getTasksByDate(DateTime date) async {
    final dateString = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();

    final rows = await _taskDao.getTasksByDate(date);

    return rows.map(_taskFromDrift).toList();
  }

  Future<int> updateTask(app_model.Task task) async {
    final result = await _taskDao.updateTask(
      TasksCompanion(
        id: Value(task.id!),
        title: Value(task.title ?? ''),
        description: Value(task.description),
        date: Value(task.date?.toIso8601String()),
        isCompleted: Value(task.isCompleted ?? 0),
        createdAt: Value(task.createdAt?.toIso8601String()),
        updatedAt: Value(task.updatedAt?.toIso8601String()),
      ),
    );

    return result ? 1 : 0;
  }

  Future<int> toggleTaskCompletion(app_model.Task task) async {
    final newStatus = (task.isCompleted ?? 0) == 1 ? 0 : 1;

    return _taskDao.toggleTaskCompletion(
      task.id!,
      newStatus == 1,
    );
  }

  Future<int> deleteTask(int id) {
    return _taskDao.deleteTask(id);
  }

  app_model.Task _taskFromDrift(dynamic row) {
    return app_model.Task(
      id: row.id,
      title: row.title,
      description: row.description,
      date: row.date == null ? null : DateTime.parse(row.date),
      isCompleted: row.isCompleted,
      createdAt: row.createdAt == null
          ? null
          : DateTime.parse(row.createdAt),
      updatedAt: row.updatedAt == null
          ? null
          : DateTime.parse(row.updatedAt),
    );
  }

  // ============================================================
  // NOTES
  // ============================================================

  Future<int> insertNote(app_model.Note note) {
    return _noteDao.insertNote(
      NotesCompanion(
        title: Value(note.title ?? ''),
        content: Value(note.content),
        createdAt: Value(note.createdAt?.toIso8601String()),
        updatedAt: Value(note.updatedAt?.toIso8601String()),
      ),
    );
  }

  Future<List<app_model.Note>> getAllNotes() async {
    final rows = await _noteDao.getAllNotes();
    return rows.map(_noteFromDrift).toList();
  }

  Future<app_model.Note?> getNoteById(int id) async {
    final row = await _noteDao.getNoteById(id);

    if (row == null) {
      return null;
    }

    return _noteFromDrift(row);
  }

  Future<int> updateNote(app_model.Note note) async {
    final result = await _noteDao.updateNote(
      NotesCompanion(
        id: Value(note.id!),
        title: Value(note.title ?? ''),
        content: Value(note.content),
        createdAt: Value(note.createdAt?.toIso8601String()),
        updatedAt: Value(note.updatedAt?.toIso8601String()),
      ),
    );

    return result ? 1 : 0;
  }

  Future<int> deleteNote(int id) {
    return _noteDao.deleteNote(id);
  }

  Future<List<app_model.Note>> searchNotes(String query) async {
    final rows = await _noteDao.searchNotes(query);
    return rows.map(_noteFromDrift).toList();
  }

  app_model.Note _noteFromDrift(dynamic row) {
    return app_model.Note(
      id: row.id,
      title: row.title,
      content: row.content,
      createdAt: row.createdAt == null
          ? null
          : DateTime.parse(row.createdAt),
      updatedAt: row.updatedAt == null
          ? null
          : DateTime.parse(row.updatedAt),
    );
  }

  // ============================================================
  // EVENTS
  // ============================================================

  Future<int> insertEvent(app_model.Event event) {
    return _eventDao.insertEvent(
      EventsCompanion(
        title: Value(event.title ?? ''),
        date: Value(event.date?.toIso8601String()),
        createdAt: Value(event.createdAt?.toIso8601String()),
        updatedAt: Value(event.updatedAt?.toIso8601String()),
      ),
    );
  }

  Future<List<app_model.Event>> getAllEvents() async {
    final rows = await _eventDao.getAllEvents();
    return rows.map(_eventFromDrift).toList();
  }

  Future<List<app_model.Event>> getEventsByDate(DateTime date) async {
    final dateString = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();

    final rows = await _eventDao.getEventsByDate(date);

    return rows.map(_eventFromDrift).toList();
  }

  Future<app_model.Event?> getEventById(int id) async {
    final row = await _eventDao.getEventById(id);

    if (row == null) {
      return null;
    }

    return _eventFromDrift(row);
  }

  Future<int> updateEvent(app_model.Event event) async {
    final result = await _eventDao.updateEvent(
      EventsCompanion(
        id: Value(event.id!),
        title: Value(event.title ?? ''),
        date: Value(event.date?.toIso8601String()),
        createdAt: Value(event.createdAt?.toIso8601String()),
        updatedAt: Value(event.updatedAt?.toIso8601String()),
      ),
    );

    return result ? 1 : 0;
  }

  Future<int> deleteEvent(int id) {
    return _eventDao.deleteEvent(id);
  }

  Future<List<app_model.Event>> searchEvents(String query) async {
    final rows = await _eventDao.searchEvents(query);
    return rows.map(_eventFromDrift).toList();
  }

  app_model.Event _eventFromDrift(dynamic row) {
    return app_model.Event(
      id: row.id,
      title: row.title,
      date: row.date == null
          ? null
          : DateTime.parse(row.date),
      createdAt: row.createdAt == null
          ? null
          : DateTime.parse(row.createdAt),
      updatedAt: row.updatedAt == null
          ? null
          : DateTime.parse(row.updatedAt),
    );
  }
}