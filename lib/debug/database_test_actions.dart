import '../models/event_model.dart';
import '../models/note_model.dart';
import '../models/task_model.dart';
import '../services/db_service.dart';

/// Development-only database smoke tests.
///
/// Keep these out of production screen state so temporary CRUD testing
/// does not become part of the HomeScreen's permanent UI/business logic.
class DatabaseTestActions {
  final DBService _db = DBService.instance;

  Future<void> insertTestTask() async {
    final now = DateTime.now();

    final task = Task(
      title: 'test task2',
      description: 'test task2',
      date: now,
      isCompleted: 0,
      createdAt: now,
      updatedAt: now,
    );

    final id = await _db.insertTask(task);
    print('Inserted Task ID: $id');
  }

  Future<void> testToggleTask() async {
    final tasks = await _db.getTasksByDate(DateTime.now());

    if (tasks.isEmpty) {
      print('No tasks found to toggle');
      return;
    }

    final task = tasks.first;

    print('Before Toggle: ${task.isCompleted}');

    await _db.toggleTaskCompletion(task);

    final updatedTasks = await _db.getTasksByDate(DateTime.now());

    if (updatedTasks.isNotEmpty) {
      print('After Toggle: ${updatedTasks.first.isCompleted}');
    }
  }

  Future<void> testGetTasksByDate() async {
    final tasks = await _db.getTasksByDate(DateTime.now());

    print(
      tasks.isEmpty
          ? 'No tasks found for today'
          : 'Tasks for today: $tasks',
    );
  }

  Future<void> testUpdateTask() async {
    final tasks = await _db.getTasksByDate(DateTime.now());

    if (tasks.isEmpty) {
      print('No tasks found to update');
      return;
    }

    final task = tasks.first;

    task.title = 'UPDATED TITLE';
    task.description = 'UPDATED DESC';
    task.updatedAt = DateTime.now();

    await _db.updateTask(task);

    final updatedTasks = await _db.getTasksByDate(DateTime.now());

    print('Updated Task: $updatedTasks');
  }

  Future<void> testDeleteTask() async {
    final tasks = await _db.getTasksByDate(DateTime.now());

    if (tasks.isEmpty) {
      print('No tasks to delete');
      return;
    }

    final task = tasks.first;

    if (task.id == null) return;

    print('Deleting Task ID: ${task.id}');

    await _db.deleteTask(task.id!);

    final updatedTasks = await _db.getTasksByDate(DateTime.now());

    print('Remaining Tasks: $updatedTasks');
  }

  Future<void> testInsertNote() async {
    final now = DateTime.now();

    final note = Note(
      title: 'Test Note',
      content: 'This is a test note',
      createdAt: now,
      updatedAt: now,
    );

    final id = await _db.insertNote(note);

    print('Inserted Note ID: $id');
  }

  Future<void> testGetNotes() async {
    final notes = await _db.getAllNotes();

    print('Notes: $notes');
  }

  Future<void> testUpdateNote() async {
    final notes = await _db.getAllNotes();

    if (notes.isEmpty) {
      print('No notes to update');
      return;
    }

    final note = notes.first;

    note.title = 'UPDATED NOTE';
    note.content = 'UPDATED CONTENT';
    note.updatedAt = DateTime.now();

    await _db.updateNote(note);

    final updated = await _db.getAllNotes();

    print('Updated Notes: $updated');
  }

  Future<void> testDeleteNote() async {
    final notes = await _db.getAllNotes();

    if (notes.isEmpty) {
      print('No notes to delete');
      return;
    }

    final note = notes.first;

    if (note.id == null) return;

    print('Deleting Note ID: ${note.id}');

    await _db.deleteNote(note.id!);

    final updated = await _db.getAllNotes();

    print('Remaining Notes: $updated');
  }

  Future<void> testInsertEvent() async {
    final now = DateTime.now();

    final event = Event(
      title: 'Test Event2',
      date: now,
      createdAt: now,
      updatedAt: now,
    );

    final id = await _db.insertEvent(event);

    print('Inserted Event ID: $id');
  }

  Future<void> testGetEvents() async {
    final events = await _db.getEventsByDate(DateTime.now());

    print('Events: $events');
  }

  Future<void> testUpdateEvent() async {
    final events = await _db.getEventsByDate(DateTime.now());

    if (events.isEmpty) {
      print('No events to update');
      return;
    }

    final event = events.first;

    event.title = 'UPDATED EVENT';
    event.updatedAt = DateTime.now();

    await _db.updateEvent(event);

    final updated = await _db.getEventsByDate(DateTime.now());

    print('Updated Events: $updated');
  }

  Future<void> testDeleteEvent() async {
    final events = await _db.getEventsByDate(DateTime.now());

    if (events.isEmpty) {
      print('No events to delete');
      return;
    }

    final event = events.first;

    if (event.id == null) return;

    print('Deleting Event ID: ${event.id}');

    await _db.deleteEvent(event.id!);

    final updated = await _db.getEventsByDate(DateTime.now());

    print('Remaining Events: $updated');
  }
}