class Note {
  int? id;
  String? title;
  String? content;
  DateTime? createdat;
  DateTime? updatedat;

  // Constructor
  Note({this.id, this.title, this.content, this.createdat, this.updatedat});

  // Object → Map (for database insert)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "createdat": createdat?.toIso8601String(),
      "updatedat": updatedat?.toIso8601String(),
    };
  }

  // Map → Object (for database fetch)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      title: map["title"],
      content: map["content"],
      createdat: map["createdat"] != null
          ? DateTime.parse(map["createdat"])
          : null,
      updatedat: map["updated_at"] != null
          ? DateTime.parse(map["updated_at"])
          : null,
    );
  }
}
