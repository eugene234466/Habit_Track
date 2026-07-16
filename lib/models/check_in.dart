class CheckIn {
  final int? id;
  final int? habitId;
  final String status;
  final DateTime createdAt;
  final String? note;

  CheckIn(
      {this.id, this.habitId, required this.status, required this.createdAt, this.note});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'status': status,
      'note': note,
      'date': createdAt.toIso8601String(),
    };
  }

  factory CheckIn.fromMap(Map<String, dynamic> map){
    return CheckIn(
      id: map['id'] as int?,
      habitId: map['habit_id'] as int?,
      status: map['status'] as String,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['date'] as String),
    );
  }

}