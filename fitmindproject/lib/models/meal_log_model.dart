import 'package:cloud_firestore/cloud_firestore.dart';

/// Meal Log model for tracking food intake
/// Step 3 requirement: id, createdBy, createdAt fields + app-specific fields
class MealLogModel {
  final String id;
  final String mealName;
  final String mealType; // "Breakfast", "Lunch", "Dinner", "Snack"
  final double calories;
  final double protein; // grams
  final double carbs; // grams
  final double fats; // grams
  final String createdBy; // user ID (Step 3 requirement)
  final DateTime createdAt; // timestamp (Step 3 requirement)
  final String? notes;
  final List<FoodItem>? foods;

  MealLogModel({
    required this.id,
    required this.mealName,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.createdBy,
    required this.createdAt,
    this.notes,
    this.foods,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mealName': mealName,
      'mealType': mealType,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'createdBy': createdBy, // Step 3 requirement
      'createdAt': Timestamp.fromDate(createdAt), // Step 3 requirement
      'notes': notes,
      'foods': foods?.map((f) => f.toMap()).toList(),
    };
  }

  /// Create from Firestore Map
  factory MealLogModel.fromMap(Map<String, dynamic> map) {
    return MealLogModel(
      id: map['id'] ?? '',
      mealName: map['mealName'] ?? '',
      mealType: map['mealType'] ?? '',
      calories: (map['calories'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fats: (map['fats'] ?? 0).toDouble(),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
      foods: (map['foods'] as List?)
          ?.map((f) => FoodItem.fromMap(f as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Create from Firestore DocumentSnapshot
  factory MealLogModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MealLogModel.fromMap(data);
  }

  MealLogModel copyWith({
    String? id,
    String? mealName,
    String? mealType,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    String? createdBy,
    DateTime? createdAt,
    String? notes,
    List<FoodItem>? foods,
  }) {
    return MealLogModel(
      id: id ?? this.id,
      mealName: mealName ?? this.mealName,
      mealType: mealType ?? this.mealType,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      foods: foods ?? this.foods,
    );
  }
}

/// Individual food item in a meal
class FoodItem {
  final String foodName;
  final double servingSize;
  final String servingUnit; // "g", "ml", "pieces", etc.
  final double calories;

  FoodItem({
    required this.foodName,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'calories': calories,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      foodName: map['foodName'] ?? '',
      servingSize: (map['servingSize'] ?? 0).toDouble(),
      servingUnit: map['servingUnit'] ?? '',
      calories: (map['calories'] ?? 0).toDouble(),
    );
  }
}



