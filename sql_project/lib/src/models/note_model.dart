import 'dart:convert';

class NoteModel {
  final int? id;
  final String note;
  final String date;
  NoteModel({
    this.id,
    required this.note,
    required this.date,
  });

  NoteModel copyWith({
    int? id,
    String? note,
    String? date,
  }) {
    return NoteModel(
      id: id ?? this.id,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'date': date,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id']?.toInt() ?? 0,
      note: map['note'] ?? '',
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source));

  @override
  String toString() => 'NoteModel(id: $id, note: $note, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteModel &&
        other.id == id &&
        other.note == note &&
        other.date == date;
  }

  @override
  int get hashCode => id.hashCode ^ note.hashCode ^ date.hashCode;
}
