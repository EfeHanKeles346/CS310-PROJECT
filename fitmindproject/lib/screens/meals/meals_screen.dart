import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_radius.dart';
import '../../services/meal_tracking_service.dart';
import '../../services/user_data_service.dart';
import '../../services/calculation_service.dart';
import '../../services/firestore_service.dart';
import '../../models/meal_log_model.dart';
import '../../providers/auth_provider.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealTrackingService _mealService = MealTrackingService();
  final UserDataService _userDataService = UserDataService();
  DateTime _selectedDate = DateTime.now();

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
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.uid;
    
    // Calculate targets
    double? targetCalories;
    MacroNutrients? targetMacros;
    
    if (userData != null) {
      targetCalories = CalculationService.calculateTargetCalories(userData);
      targetMacros = CalculationService.calculateMacros(userData);
    }
    
    if (userId == null) {
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
        ),
        body: Center(
          child: Text('Please sign in to view meals', style: AppTextStyles.body),
        ),
      );
    }
    
    // Step 3 Requirement: StreamBuilder for real-time Firestore data with loading/error states
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
      body: StreamBuilder<List<MealLogModel>>(
        stream: FirestoreService().getMealLogsByDate(userId, _selectedDate),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.blue500),
                  const SizedBox(height: 16),
                  Text('Loading meals...', style: AppTextStyles.body),
                ],
              ),
            );
          }
          
          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.red500),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading meals',
                    style: AppTextStyles.subtitle.copyWith(color: AppColors.red500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {}); // Trigger rebuild to retry
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          // Success state
          final allMeals = snapshot.data ?? [];
          
          // Calculate today's data from stream
          final todayCalories = allMeals.fold(0.0, (sum, meal) => sum + meal.calories);
          final todayProtein = allMeals.fold(0.0, (sum, meal) => sum + meal.protein);
          final todayCarbs = allMeals.fold(0.0, (sum, meal) => sum + meal.carbs);
          final todayFats = allMeals.fold(0.0, (sum, meal) => sum + meal.fats);
          final remainingCalories = (targetCalories ?? 0) - todayCalories;
          
          // Group meals by type
          final breakfastMeals = allMeals.where((m) => m.mealType == 'Breakfast').toList();
          final lunchMeals = allMeals.where((m) => m.mealType == 'Lunch').toList();
          final dinnerMeals = allMeals.where((m) => m.mealType == 'Dinner').toList();
          final snacksMeals = allMeals.where((m) => m.mealType == 'Snack').toList();
          
          // Calculate meal calories
          final breakfastCalories = breakfastMeals.fold(0.0, (sum, e) => sum + e.calories);
          final lunchCalories = lunchMeals.fold(0.0, (sum, e) => sum + e.calories);
          final dinnerCalories = dinnerMeals.fold(0.0, (sum, e) => sum + e.calories);
          final snacksCalories = snacksMeals.fold(0.0, (sum, e) => sum + e.calories);
          
          return SingleChildScrollView(
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
                              todayProtein,
                              targetMacros?.protein ?? 0,
                              Colors.blue,
                            ),
                            _buildMacroRing(
                              'Carbs',
                              todayCarbs,
                              targetMacros?.carbs ?? 0,
                              Colors.orange,
                            ),
                            _buildMacroRing(
                              'Fats',
                              todayFats,
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
          );
        },
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

  /// Step 3: DELETE operation - Delete meal from Firestore
  Future<void> _deleteMeal(MealLogModel meal) async {
    try {
      await FirestoreService().deleteMealLog(meal.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${meal.mealName} deleted'),
            backgroundColor: AppColors.green500,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () async {
                // Restore the meal
                await FirestoreService().addMealLog(meal);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: AppColors.red500,
          ),
        );
      }
    }
  }

  Widget _buildMealCard(
    String mealType,
    List<MealLogModel> meals,
    double totalCalories,
    BuildContext context,
  ) {
    final hasItems = meals.isNotEmpty;
    final itemCount = meals.length;
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(mealType, style: AppTextStyles.subtitle),
          subtitle: hasItems
              ? Text(
                  '${totalCalories.toStringAsFixed(0)} kcal • $itemCount item${itemCount > 1 ? 's' : ''}',
                  style: AppTextStyles.body,
                )
              : Text('No items yet', style: AppTextStyles.caption),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasItems)
                Icon(Icons.expand_more, color: AppColors.gray500),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.addFood,
                    arguments: mealType,
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blue500,
                ),
              ),
            ],
          ),
          children: hasItems
              ? meals.map((meal) {
                  return Dismissible(
                    key: Key(meal.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: AppColors.red500,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Meal'),
                          content: Text('Delete "${meal.mealName}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.red500,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ) ?? false;
                    },
                    onDismissed: (direction) => _deleteMeal(meal),
                    child: ListTile(
                      title: Text(meal.mealName, style: AppTextStyles.body),
                      subtitle: Text(
                        '${meal.calories.toStringAsFixed(0)} kcal • P: ${meal.protein.toStringAsFixed(0)}g C: ${meal.carbs.toStringAsFixed(0)}g F: ${meal.fats.toStringAsFixed(0)}g',
                        style: AppTextStyles.caption,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: AppColors.red500, size: 20),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Meal'),
                              content: Text('Delete "${meal.mealName}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.red500,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            _deleteMeal(meal);
                          }
                        },
                      ),
                    ),
                  );
                }).toList()
              : [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Tap "Add" to log your $mealType',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
