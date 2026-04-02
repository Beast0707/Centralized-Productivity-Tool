class Event {
  int? id;
  String? title;
  DateTime? date;
  DateTime? createdat;
  DateTime? updatedat;

  // Constructor
  Event({this.id, this.title, this.date, this.createdat, this.updatedat});

  // Object → Map (for DB insert)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "date": date?.toIso8601String(),
      "createdat": createdat?.toIso8601String(),
      "updatedat": updatedat?.toIso8601String(),
    };
  }

  // Map → Object (for DB fetch)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map["id"],
      title: map["title"],
      date: map["date"] != null ? DateTime.parse(map["date"]) : null,
      createdat: map["createdat"] != null
          ? DateTime.parse(map["createdat"])
          : null,
      updatedat: map["updatedat"] != null
          ? DateTime.parse(map["updatedat"])
          : null,
    );
  }
}
