class Task {
  int? id;
  String? title;
  String? description;
  DateTime? date;
  int? isCompleted;
  DateTime? createdat;
  DateTime? updatedat;

  // Constructor
  Task({
    this.id,
    this.title,
    this.description,
    this.date,
    this.isCompleted,
    this.createdat,
    this.updatedat,
  });

  // Object → Map (for DB insert)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date?.toIso8601String(),
      "iscompleted": isCompleted,
      "createdat": createdat?.toIso8601String(),
      "updatedat": updatedat?.toIso8601String(),
    };
  }

  // Map → Object (for DB fetch)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      date: map["date"] != null ? DateTime.parse(map["date"]) : null,
      isCompleted: map["iscompleted"],
      createdat: map["createdat"] != null
          ? DateTime.parse(map["createdat"])
          : null,
      updatedat: map["updatedat"] != null
          ? DateTime.parse(map["updatedat"])
          : null,
    );
  }
}
