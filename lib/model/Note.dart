final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, title, description, color
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String color = 'color';
}

class Note {
  final int? id;
  final String title;
  final String description;
  final String color;

  const Note(
      {this.id,
      required this.title,
      required this.description,
      required this.color});

  Note copy({int? id, String? title, String? description, String? color}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        color: json[NoteFields.color] as String,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.color: color
      };
}
