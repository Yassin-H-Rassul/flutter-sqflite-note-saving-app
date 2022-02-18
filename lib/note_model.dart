import 'dart:convert';

import 'package:intl/intl.dart';

class Note {
  int? id;
  String noteContent;
  String selectedDate;
  Note({
    this.id,
    required this.noteContent,
    required this.selectedDate,
  });

  Note copyWith({
    int? id,
    String? noteContent,
    String? selectedDate,
  }) {
    return Note(
      id: id ?? this.id,
      noteContent: noteContent ?? this.noteContent,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noteContent': noteContent,
      'selectedDate': selectedDate,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toInt(),
      noteContent: map['noteContent'] ?? '',
      selectedDate: map['selectedDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() =>
      'Note(id: $id, noteContent: $noteContent, selectedDate: $selectedDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.noteContent == noteContent &&
        other.selectedDate == selectedDate;
  }

  @override
  int get hashCode =>
      id.hashCode ^ noteContent.hashCode ^ selectedDate.hashCode;
}
