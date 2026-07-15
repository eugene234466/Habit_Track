class Habit {
  final int? id;
  final String name;
  final DateTime createdAt;
  
  Habit({this.id, required this.name, required this.createdAt});
  
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  factory Habit.fromMap(Map<String, dynamic> map){
    return Habit(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

