import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';

part 'note_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NoteDao extends DatabaseAccessor<AppDatabase>
    with _$NoteDaoMixin {
  NoteDao(AppDatabase db) : super(db);

  Future<List<Note>> getAllNotes() {
    return (select(notes)
      ..orderBy([
            (n) => OrderingTerm(
          expression: n.createdAt,
          mode: OrderingMode.desc,
        ),
      ]))
        .get();
  }

  Future<Note?> getNoteById(int id) {
    return (select(notes)..where((n) => n.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertNote(NotesCompanion note) {
    return into(notes).insert(note);
  }

  Future<bool> updateNote(NotesCompanion note) async {
    final rowsUpdated = await update(notes).write(note);
    return rowsUpdated > 0;
  }

  Future<int> deleteNote(int id) {
    return (delete(notes)..where((n) => n.id.equals(id))).go();
  }

  Future<List<Note>> searchNotes(String query) {
    return (select(notes)
      ..where(
            (n) =>
        n.title.contains(query) |
        n.content.contains(query),
      ))
        .get();
  }
}