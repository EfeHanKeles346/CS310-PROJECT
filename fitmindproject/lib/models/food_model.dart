class FoodItem {
  final String id;
  final String name;
  final double calories; // per 100g or specified serving
  final double protein; // grams
  final double carbs; // grams
  final double fats; // grams
  final double servingSize; // grams or ml
  final String category; // Protein, Carbs, Fats, Veggies
  
  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.servingSize,
    required this.category,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'servingSize': servingSize,
      'category': category,
    };
  }
  
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      calories: map['calories']?.toDouble() ?? 0.0,
      protein: map['protein']?.toDouble() ?? 0.0,
      carbs: map['carbs']?.toDouble() ?? 0.0,
      fats: map['fats']?.toDouble() ?? 0.0,
      servingSize: map['servingSize']?.toDouble() ?? 100.0,
      category: map['category'] ?? 'All',
    );
  }
}

class MealEntry {
  final String id;
  final String foodId;
  final String foodName;
  final String mealType; // Breakfast, Lunch, Dinner, Snacks
  final double quantity; // grams or servings
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final DateTime date;
  
  MealEntry({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.mealType,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.date,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodId': foodId,
      'foodName': foodName,
      'mealType': mealType,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'date': date.toIso8601String(),
    };
  }
  
  factory MealEntry.fromMap(Map<String, dynamic> map) {
    return MealEntry(
      id: map['id'],
      foodId: map['foodId'],
      foodName: map['foodName'],
      mealType: map['mealType'],
      quantity: map['quantity']?.toDouble() ?? 0.0,
      calories: map['calories']?.toDouble() ?? 0.0,
      protein: map['protein']?.toDouble() ?? 0.0,
      carbs: map['carbs']?.toDouble() ?? 0.0,
      fats: map['fats']?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date']),
    );
  }
}

