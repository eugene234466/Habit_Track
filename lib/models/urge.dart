class Urge {
  final int? id;
  final int? habitId;
  final DateTime timestamp;
  final int? intensity;
  final String? triggerNote;
  
  Urge({this.id, this.habitId, required this.timestamp, this.intensity, this.triggerNote});
  
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'habit_id': habitId,
      'timestamp': timestamp.toIso8601String(),
      'intensity': intensity,
      'trigger_note': triggerNote,
    };
  }
  factory Urge.fromMap(Map<String, dynamic> map){
    return Urge(
      id: map['id'] as int?,
      habitId: map['habit_id'] as int?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      intensity: map['intensity'] as int?,
      triggerNote: map['trigger_note'] as String?,
    );
  }
  
}