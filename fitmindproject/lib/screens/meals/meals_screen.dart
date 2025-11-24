import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_radius.dart';
import '../../services/meal_tracking_service.dart';
import '../../services/user_data_service.dart';
import '../../services/calculation_service.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealTrackingService _mealService = MealTrackingService();
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _mealService.addListener(_onMealsChanged);
    _userDataService.addListener(_onUserDataChanged);
  }

  @override
  void dispose() {
    _mealService.removeListener(_onMealsChanged);
    _userDataService.removeListener(_onUserDataChanged);
    super.dispose();
  }

  void _onMealsChanged() {
    setState(() {});
  }

  void _onUserDataChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userData = _userDataService.userData;
    
    // Calculate targets
    double? targetCalories;
    MacroNutrients? targetMacros;
    
    if (userData != null) {
      targetCalories = CalculationService.calculateTargetCalories(userData);
      targetMacros = CalculationService.calculateMacros(userData);
    }
    
    // Get today's data
    final todayCalories = _mealService.getTodayCalories();
    final todayMacros = _mealService.getTodayMacros();
    final remainingCalories = (targetCalories ?? 0) - todayCalories;
    
    // Get meals by type
    final breakfastMeals = _mealService.getMealsByType('Breakfast');
    final lunchMeals = _mealService.getMealsByType('Lunch');
    final dinnerMeals = _mealService.getMealsByType('Dinner');
    final snacksMeals = _mealService.getMealsByType('Snacks');
    
    // Calculate meal calories
    final breakfastCalories = breakfastMeals.fold(0.0, (sum, e) => sum + e.calories);
    final lunchCalories = lunchMeals.fold(0.0, (sum, e) => sum + e.calories);
    final dinnerCalories = dinnerMeals.fold(0.0, (sum, e) => sum + e.calories);
    final snacksCalories = snacksMeals.fold(0.0, (sum, e) => sum + e.calories);
    
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.restaurant_menu, size: 24, color: AppColors.gray900),
            const SizedBox(width: 8),
            const Text('Meals'),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            // Calorie and Macro Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    // Calories
                    Text(
                      '${todayCalories.toStringAsFixed(0)} / ${targetCalories?.toStringAsFixed(0) ?? '0'} kcal',
                      style: AppTextStyles.largeTitle,
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Text(
                      remainingCalories >= 0 
                          ? '${remainingCalories.toStringAsFixed(0)} kcal remaining'
                          : '${(-remainingCalories).toStringAsFixed(0)} kcal over',
                      style: AppTextStyles.body.copyWith(
                        color: remainingCalories >= 0 
                            ? AppColors.green500 
                            : AppColors.red500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacing16),
                    
                    // Progress bar
                    LinearProgressIndicator(
                      value: targetCalories != null && targetCalories! > 0
                          ? (todayCalories / targetCalories!).clamp(0.0, 1.0)
                          : 0,
                      backgroundColor: AppColors.gray300,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue500),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: AppSpacing.spacing16),
                    
                    // Macro rings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroRing(
                          'Protein',
                          todayMacros.protein,
                          targetMacros?.protein ?? 0,
                          Colors.blue,
                        ),
                        _buildMacroRing(
                          'Carbs',
                          todayMacros.carbs,
                          targetMacros?.carbs ?? 0,
                          Colors.orange,
                        ),
                        _buildMacroRing(
                          'Fats',
                          todayMacros.fats,
                          targetMacros?.fats ?? 0,
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            
            // Meal Cards
            _buildMealCard(
              'Breakfast',
              breakfastMeals,
              breakfastCalories,
              context,
            ),
            _buildMealCard(
              'Lunch',
              lunchMeals,
              lunchCalories,
              context,
            ),
            _buildMealCard(
              'Dinner',
              dinnerMeals,
              dinnerCalories,
              context,
            ),
            _buildMealCard(
              'Snacks',
              snacksMeals,
              snacksCalories,
              context,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addFood);
        },
        backgroundColor: AppColors.blue500,
        icon: const Icon(Icons.add),
        label: const Text('Add Food'),
      ),
    );
  }

  Widget _buildMacroRing(String label, double current, double target, Color color) {
    final percentage = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4),
                ),
              ),
              // Progress circle
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 4,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    current.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    '/ ${target.toStringAsFixed(0)}g',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildMealCard(
    String mealType,
    List meals,
    double totalCalories,
    BuildContext context,
  ) {
    final hasItems = meals.isNotEmpty;
    final itemCount = meals.length;
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      child: ListTile(
        title: Text(mealType, style: AppTextStyles.subtitle),
        subtitle: hasItems
            ? Text(
                '${totalCalories.toStringAsFixed(0)} kcal • $itemCount item${itemCount > 1 ? 's' : ''}',
                style: AppTextStyles.body,
              )
            : null,
        trailing: TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.addFood,
              arguments: mealType,
            );
          },
          icon: const Icon(Icons.add, size: 18),
          label: Text(hasItems ? 'Add food' : '+ Add food'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.blue500,
          ),
        ),
      ),
    );
  }
}
