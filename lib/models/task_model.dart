class Task {
  int? id;
  String? title;
  String? description;
  DateTime? date;
  int? isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Constructor
  Task({
    this.id,
    this.title,
    this.description,
    this.date,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
  });

  // Object → Map (for DB insert)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date?.toIso8601String(),
      "is_completed": isCompleted ?? 0,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  // Map → Object (for DB fetch)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      date: map["date"] != null ? DateTime.parse(map["date"]) : null,
      isCompleted: map["is_completed"],
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
    return 'Task(id: $id, title: $title, desc: $description, completed: $isCompleted, date: $date)';
  }
}