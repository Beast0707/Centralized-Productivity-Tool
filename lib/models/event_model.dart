class Event {
  int? id;
  String? title;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Constructor
  Event({this.id, this.title, this.date, this.createdAt, this.updatedAt});

  // Object → Map (for DB insert)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "date": date?.toIso8601String(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  // Map → Object (for DB fetch)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map["id"],
      title: map["title"],
      date: map["date"] != null ? DateTime.parse(map["date"]) : null,
      createdAt: map["created_at"] != null
          ? DateTime.parse(map["created_at"])
          : null,
      updatedAt: map["updated_at"] != null
          ? DateTime.parse(map["updated_at"])
          : null,
    );
  }

  @override
  String toString() {
    return 'Event(id: $id, title: $title, date: $date)';
  }

}
