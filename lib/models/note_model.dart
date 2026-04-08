class Note {
  int? id;
  String? title;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Constructor
  Note({this.id, this.title, this.content, this.createdAt, this.updatedAt});

  // Object → Map (for database insert)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  // Map → Object (for database fetch)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      title: map["title"],
      content: map["content"],
      createdAt: map["created_at"] != null
          ? DateTime.parse(map["created_at"])
          : null,
      updatedAt: map["updated_at"] != null
          ? DateTime.parse(map["updated_at"])
          : null,
    );
  }

  // ✅ CORRECT PLACE
  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content)';
  }
}