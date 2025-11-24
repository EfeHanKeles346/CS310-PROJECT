class WorkoutModel {
  final String id;
  final String name;
  final int exercises;
  final int duration; // in minutes
  final String category;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.exercises,
    required this.duration,
    required this.category,
  });

  // For future SQLite integration
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises,
      'duration': duration,
      'category': category,
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'],
      name: map['name'],
      exercises: map['exercises'],
      duration: map['duration'],
      category: map['category'],
    );
  }
}
