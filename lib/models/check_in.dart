class CheckIn {
  final int? id;
  final int? habitId;
  final String status;
  final DateTime createdAt;

  CheckIn(
      {this.id, this.habitId, required this.status, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CheckIn.fromMap(Map<String, dynamic> map){
    return CheckIn(
      id: map['id'] as int?,
      habitId: map['habit_id'] as int?,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

}