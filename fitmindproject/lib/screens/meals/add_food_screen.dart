import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/food_database_service.dart';
import '../../services/firestore_service.dart';
import '../../models/food_model.dart';
import '../../models/meal_log_model.dart' show MealLogModel;
import '../../providers/auth_provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String? _selectedMealType; // Breakfast, Lunch, Dinner, Snacks
  
  final FoodDatabaseService _foodDatabase = FoodDatabaseService();
  final FirestoreService _firestoreService = FirestoreService();
  
  List<FoodItem> _filteredFoods = [];
  Set<String> _selectedFoodIds = {}; // Track selected foods
  bool _isLoading = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get meal type from arguments if provided
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _selectedMealType = args;
    }
    _filterFoods();
  }
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFoods);
    _filteredFoods = _foodDatabase.getAllFoods();
  }
  
  void _filterFoods() {
    setState(() {
      _filteredFoods = _foodDatabase.searchFoods(
        _searchController.text,
        _selectedCategory,
      );
    });
  }
  
  void _toggleFoodSelection(String foodId) {
    setState(() {
      if (_selectedFoodIds.contains(foodId)) {
        _selectedFoodIds.remove(foodId);
      } else {
        _selectedFoodIds.add(foodId);
      }
    });
  }
  
  Future<void> _saveSelectedFoods() async {
    if (_selectedFoodIds.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.uid;
    
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to add foods'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    final selectedFoods = _filteredFoods.where(
      (food) => _selectedFoodIds.contains(food.id),
    ).toList();
    
    // Default meal type to Breakfast if not specified
    final mealType = _selectedMealType ?? 'Breakfast';
    
    try {
      for (var food in selectedFoods) {
        // Step 3: Create MealLogModel for Firestore
        final mealLog = MealLogModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + food.id,
          mealName: food.name,
          mealType: mealType,
          calories: food.calories,
          protein: food.protein,
          carbs: food.carbs,
          fats: food.fats,
          createdBy: userId, // Step 3 requirement
          createdAt: DateTime.now(), // Step 3 requirement
        );
        
        // Step 3: Save to Firestore (CREATE operation)
        await _firestoreService.addMealLog(mealLog);
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${selectedFoods.length} food item(s) to $mealType'),
            backgroundColor: AppColors.green500,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding food: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: const Text('Add Food'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveSelectedFoods,
            child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search foods...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.gray100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Protein', 'Carbs', 'Fats', 'Veggies'].map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = cat;
                              _filterFoods();
                            });
                          },
                          selectedColor: AppColors.gray900,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.gray700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Recent label
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent',
                style: AppTextStyles.subtitle,
              ),
            ),
          ),
          
          // Food list
          Expanded(
            child: _filteredFoods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.gray300,
                        ),
                        const SizedBox(height: AppSpacing.spacing16),
                        Text(
                          'No foods found',
                          style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];
                      final isSelected = _selectedFoodIds.contains(food.id);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                        child: ListTile(
                          title: Text(
                            food.name,
                            style: AppTextStyles.subtitle,
                          ),
                          subtitle: Text(
                            '${food.calories.toStringAsFixed(0)} kcal • ${food.protein.toStringAsFixed(0)}g P • ${food.carbs.toStringAsFixed(0)}g C • ${food.fats.toStringAsFixed(1)}g F',
                            style: AppTextStyles.body,
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              _toggleFoodSelection(food.id);
                            },
                            activeColor: AppColors.blue500,
                          ),
                          onTap: () {
                            _toggleFoodSelection(food.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
