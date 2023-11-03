const String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, title, description, color, date, time, isComplete,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String color = 'color';
  static const String date = 'date';
  static const String time = 'time';
  static const String isComplete = 'isComplete'; //TODO 0=false, 1=true
}

class Note {
  final int? id;
  final String title;
  final String description;
  final String color;
  final String date;
  final String time;
  String isComplete;

  Note(
      {this.id,
      required this.title,
      required this.description,
      required this.color,
      required this.date,
      required this.time,
      required this.isComplete});

  copywith(
          {int? id,
          String? title,
          String? description,
          String? color,
          String? date,
          String? time,
          String? isComplete}) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          color: color ?? this.color,
          date: date ?? this.date,
          time: time ?? this.time,
          isComplete: isComplete ?? this.isComplete);

  static Note fromJson(Map<String, Object?> json) => Note(
      id: json[NoteFields.id] as int?,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      color: json[NoteFields.color] as String,
      date: json[NoteFields.date] as String,
      time: json[NoteFields.time] as String,
      isComplete: json[NoteFields.isComplete] as String);

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.color: color,
        NoteFields.date: date,
        NoteFields.time: time,
        NoteFields.isComplete: isComplete
      };
}
