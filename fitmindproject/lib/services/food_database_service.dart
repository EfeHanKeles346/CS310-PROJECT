import '../models/food_model.dart';

class FoodDatabaseService {
  static final FoodDatabaseService _instance = FoodDatabaseService._internal();
  factory FoodDatabaseService() => _instance;
  FoodDatabaseService._internal() {
    _initializeDatabase();
  }
  
  List<FoodItem> _foodDatabase = [];
  
  // Initialize with default food items (local SQLite equivalent)
  void _initializeDatabase() {
    _foodDatabase = [
      // Protein
      FoodItem(
        id: '1',
        name: 'Chicken Breast (100g)',
        calories: 165,
        protein: 31,
        carbs: 0,
        fats: 3.6,
        servingSize: 100,
        category: 'Protein',
      ),
      FoodItem(
        id: '2',
        name: 'Eggs (2 large)',
        calories: 144,
        protein: 12,
        carbs: 1,
        fats: 10,
        servingSize: 100,
        category: 'Protein',
      ),
      FoodItem(
        id: '3',
        name: 'Greek Yogurt (150g)',
        calories: 90,
        protein: 15,
        carbs: 6,
        fats: 0,
        servingSize: 150,
        category: 'Protein',
      ),
      FoodItem(
        id: '4',
        name: 'Salmon (100g)',
        calories: 208,
        protein: 20,
        carbs: 0,
        fats: 12,
        servingSize: 100,
        category: 'Protein',
      ),
      FoodItem(
        id: '5',
        name: 'Tuna (100g)',
        calories: 144,
        protein: 30,
        carbs: 0,
        fats: 1,
        servingSize: 100,
        category: 'Protein',
      ),
      
      // Carbs
      FoodItem(
        id: '6',
        name: 'Brown Rice (150g)',
        calories: 165,
        protein: 3,
        carbs: 35,
        fats: 1.5,
        servingSize: 150,
        category: 'Carbs',
      ),
      FoodItem(
        id: '7',
        name: 'Oatmeal (50g dry)',
        calories: 185,
        protein: 7,
        carbs: 33,
        fats: 4,
        servingSize: 50,
        category: 'Carbs',
      ),
      FoodItem(
        id: '8',
        name: 'Sweet Potato (200g)',
        calories: 180,
        protein: 4,
        carbs: 41,
        fats: 0.3,
        servingSize: 200,
        category: 'Carbs',
      ),
      FoodItem(
        id: '9',
        name: 'Whole Wheat Bread (2 slices)',
        calories: 160,
        protein: 8,
        carbs: 28,
        fats: 2,
        servingSize: 60,
        category: 'Carbs',
      ),
      
      // Fats
      FoodItem(
        id: '10',
        name: 'Avocado (100g)',
        calories: 160,
        protein: 2,
        carbs: 9,
        fats: 15,
        servingSize: 100,
        category: 'Fats',
      ),
      FoodItem(
        id: '11',
        name: 'Almonds (30g)',
        calories: 180,
        protein: 6,
        carbs: 6,
        fats: 15,
        servingSize: 30,
        category: 'Fats',
      ),
      FoodItem(
        id: '12',
        name: 'Olive Oil (1 tbsp)',
        calories: 120,
        protein: 0,
        carbs: 0,
        fats: 14,
        servingSize: 15,
        category: 'Fats',
      ),
      
      // Veggies
      FoodItem(
        id: '13',
        name: 'Broccoli (80g)',
        calories: 27,
        protein: 2,
        carbs: 6,
        fats: 0.3,
        servingSize: 80,
        category: 'Veggies',
      ),
      FoodItem(
        id: '14',
        name: 'Spinach (100g)',
        calories: 23,
        protein: 3,
        carbs: 4,
        fats: 0.4,
        servingSize: 100,
        category: 'Veggies',
      ),
      FoodItem(
        id: '15',
        name: 'Bell Peppers (150g)',
        calories: 31,
        protein: 1,
        carbs: 7,
        fats: 0.3,
        servingSize: 150,
        category: 'Veggies',
      ),
      FoodItem(
        id: '16',
        name: 'Carrots (100g)',
        calories: 41,
        protein: 1,
        carbs: 10,
        fats: 0.2,
        servingSize: 100,
        category: 'Veggies',
      ),
    ];
  }
  
  // Search foods by name or category
  List<FoodItem> searchFoods(String query, String category) {
    List<FoodItem> results = _foodDatabase;
    
    // Filter by category
    if (category != 'All') {
      results = results.where((food) => food.category == category).toList();
    }
    
    // Filter by search query
    if (query.isNotEmpty) {
      results = results.where((food) => 
        food.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    
    return results;
  }
  
  // Get all foods
  List<FoodItem> getAllFoods() => _foodDatabase;
  
  // Get foods by category
  List<FoodItem> getFoodsByCategory(String category) {
    if (category == 'All') return _foodDatabase;
    return _foodDatabase.where((food) => food.category == category).toList();
  }
  
  // Get recent foods (for now, return all)
  List<FoodItem> getRecentFoods() {
    return _foodDatabase.take(10).toList();
  }
}

