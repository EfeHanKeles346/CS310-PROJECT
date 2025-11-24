import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_radius.dart';
import '../../services/user_data_service.dart';
import '../../services/calculation_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToPlanner;
  
  const HomeScreen({super.key, this.onNavigateToPlanner});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    // Listen to changes in user data
    _userDataService.addListener(_onUserDataChanged);
  }

  @override
  void dispose() {
    _userDataService.removeListener(_onUserDataChanged);
    super.dispose();
  }

  void _onUserDataChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userData = _userDataService.userData;
    
    // Debug: Print user data to verify it's loading correctly
    if (userData != null) {
      debugPrint('HomeScreen - Weight: ${userData.weight}kg, Initial: ${userData.initialWeight}kg, Target: ${userData.targetWeight}kg, Goal: ${userData.primaryGoal}');
    }
    
    if (userData == null) {
      return Scaffold(
        backgroundColor: AppColors.gray100,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.fitness_center, size: 24, color: AppColors.gray900),
              const SizedBox(width: 8),
              const Text('Home'),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text(
            'Please complete registration to see your data',
            style: AppTextStyles.body,
          ),
        ),
      );
    }
    
    // Calculate values
    final tdee = CalculationService.calculateTDEE(userData);
    final targetCalories = CalculationService.calculateTargetCalories(userData);
    final macros = CalculationService.calculateMacros(userData);
    final progress = CalculationService.calculateProgressPercentage(userData);
    final workoutProgram = CalculationService.getWorkoutProgram(userData);
    
    String goalText = _getGoalText(userData.primaryGoal);
    
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.fitness_center, size: 24, color: AppColors.gray900),
            const SizedBox(width: 8),
            const Text('Home'),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Weight', '${userData.weight.toStringAsFixed(1)} kg'),
                    _buildStatItem('Body Fat', 
                      userData.bodyFatPercentage != null 
                        ? '${userData.bodyFatPercentage!.toStringAsFixed(1)}%' 
                        : 'N/A'),
                    _buildStatItem('Muscle', 
                      userData.muscleMass != null 
                        ? '${userData.muscleMass!.toStringAsFixed(1)} kg' 
                        : 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            
            // Daily Targets Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daily Targets', style: AppTextStyles.subtitle),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getGoalColor(userData.primaryGoal).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.chip),
                          ),
                          child: Text(
                            goalText,
                            style: AppTextStyles.caption.copyWith(
                              color: _getGoalColor(userData.primaryGoal),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spacing16),
                    Text(
                      '${targetCalories.toStringAsFixed(0)} kcal',
                      style: AppTextStyles.largeTitle,
                    ),
                    const SizedBox(height: AppSpacing.spacing12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMacroItem('Protein', '${macros.protein.toStringAsFixed(0)}g', Colors.blue),
                        _buildMacroItem('Carbs', '${macros.carbs.toStringAsFixed(0)}g', Colors.orange),
                        _buildMacroItem('Fats', '${macros.fats.toStringAsFixed(0)}g', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            
            // Goal Progress Card
            if (userData.targetWeight != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Goal Progress', style: AppTextStyles.subtitle),
                      const SizedBox(height: AppSpacing.spacing12),
                      Text(
                        '${progress.toStringAsFixed(0)}% to target (${userData.targetWeight!.toStringAsFixed(1)}kg)',
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: AppSpacing.spacing8),
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: AppColors.gray300,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue500),
                        minHeight: 8,
                      ),
                      const SizedBox(height: AppSpacing.spacing8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Current: ${userData.weight.toStringAsFixed(1)}kg', style: AppTextStyles.caption),
                          Text('Target: ${userData.targetWeight!.toStringAsFixed(1)}kg', style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            
            if (userData.targetWeight != null)
              const SizedBox(height: AppSpacing.spacing16),
            const SizedBox(height: AppSpacing.spacing16),
            
            // Measurement Reminder
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing12),
              decoration: BoxDecoration(
                color: AppColors.blue100,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.blue500),
                  const SizedBox(width: AppSpacing.spacing12),
                  Expanded(
                    child: Text(
                      'Next measurement due Nov 18 (14 days)',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.addMeasurement);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Measurement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gray900,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // If callback is provided (from MainScaffold), use it to switch tab
                      // Otherwise, navigate to planner route
                      if (widget.onNavigateToPlanner != null) {
                        widget.onNavigateToPlanner!();
                      } else {
                        Navigator.pushNamed(context, AppRoutes.planner);
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Planner'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.subtitle),
      ],
    );
  }

  Widget _buildMacroItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.subtitle),
      ],
    );
  }
  
  String _getGoalText(String goal) {
    switch (goal) {
      case 'lose_weight':
        return 'Weight Loss';
      case 'build_muscle':
        return 'Muscle Gain';
      default:
        return 'Maintain';
    }
  }
  
  Color _getGoalColor(String goal) {
    switch (goal) {
      case 'lose_weight':
        return AppColors.orange500;
      case 'build_muscle':
        return AppColors.green500;
      default:
        return AppColors.blue500;
    }
  }
}
