import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';

part 'event_dao.g.dart';

@DriftAccessor(tables: [Events])
class EventDao extends DatabaseAccessor<AppDatabase>
    with _$EventDaoMixin {
  EventDao(AppDatabase db) : super(db);

  Future<List<Event>> getAllEvents() {
    return select(events).get();
  }

  Future<List<Event>> getEventsByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    return (select(events)
      ..where(
            (e) =>
        e.date.isBiggerOrEqualValue(start.toIso8601String()) &
        e.date.isSmallerThanValue(end.toIso8601String()),
      ))
        .get();
  }

  Future<Event?> getEventById(int id) {
    return (select(events)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertEvent(EventsCompanion event) {
    return into(events).insert(event);
  }

  Future<bool> updateEvent(EventsCompanion event) async {
    final rowsUpdated = await (update(events)
      ..where((e) => e.id.equals(event.id.value)))
        .write(
      EventsCompanion(
        title: event.title,
        date: event.date,
        createdAt: event.createdAt,
        updatedAt: event.updatedAt,
      ),
    );

    return rowsUpdated > 0;
  }

  Future<int> deleteEvent(int id) {
    return (delete(events)..where((e) => e.id.equals(id))).go();
  }

  Future<List<Event>> searchEvents(String query) {
    return (select(events)..where((e) => e.title.contains(query))).get();
  }
}