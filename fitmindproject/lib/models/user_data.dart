class UserData {
  // Basic Info (Step 1)
  String name;
  int age;
  double height; // cm
  double weight; // kg
  double? initialWeight; // Starting weight for progress tracking
  String gender; // Male, Female, Other
  
  // Goals (Step 2)
  String primaryGoal; // lose_weight, build_muscle, maintain
  double? targetWeight;
  String trainingExperience; // beginner, intermediate, advanced
  
  // Body Composition (Step 3)
  double? bodyFatPercentage;
  double? muscleMass; // kg
  
  UserData({
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    this.initialWeight,
    required this.gender,
    this.primaryGoal = 'lose_weight',
    this.targetWeight,
    this.trainingExperience = 'intermediate',
    this.bodyFatPercentage,
    this.muscleMass,
  });
  
  // Convert to/from Map for persistence
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'initialWeight': initialWeight,
      'gender': gender,
      'primaryGoal': primaryGoal,
      'targetWeight': targetWeight,
      'trainingExperience': trainingExperience,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
    };
  }
  
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      height: map['height']?.toDouble() ?? 0.0,
      weight: map['weight']?.toDouble() ?? 0.0,
      initialWeight: map['initialWeight']?.toDouble(),
      gender: map['gender'] ?? 'Male',
      primaryGoal: map['primaryGoal'] ?? 'lose_weight',
      targetWeight: map['targetWeight']?.toDouble(),
      trainingExperience: map['trainingExperience'] ?? 'intermediate',
      bodyFatPercentage: map['bodyFatPercentage']?.toDouble(),
      muscleMass: map['muscleMass']?.toDouble(),
    );
  }
  
  UserData copyWith({
    String? name,
    int? age,
    double? height,
    double? weight,
    double? initialWeight,
    String? gender,
    String? primaryGoal,
    double? targetWeight,
    String? trainingExperience,
    double? bodyFatPercentage,
    double? muscleMass,
  }) {
    return UserData(
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      initialWeight: initialWeight ?? this.initialWeight,
      gender: gender ?? this.gender,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      targetWeight: targetWeight ?? this.targetWeight,
      trainingExperience: trainingExperience ?? this.trainingExperience,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
    );
  }
}
