import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/workout_program_service.dart';
import '../../routes.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  String _selectedFilter = 'All';
  final WorkoutProgramService _workoutProgramService = WorkoutProgramService();
  
  // Current week dates
  late DateTime _weekStart;
  
  @override
  void initState() {
    super.initState();
    // Get current week start (Monday)
    _weekStart = _getWeekStart(DateTime.now());
    _workoutProgramService.addListener(_onProgramChanged);
  }
  
  @override
  void dispose() {
    _workoutProgramService.removeListener(_onProgramChanged);
    super.dispose();
  }
  
  void _onProgramChanged() {
    setState(() {});
  }
  
  DateTime _getWeekStart(DateTime date) {
    int daysFromMonday = date.weekday - 1;
    return date.subtract(Duration(days: daysFromMonday));
  }
  
  String _getWeekRange() {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'Week of ${months[_weekStart.month - 1]} ${_weekStart.day}-${weekEnd.day}';
  }
  
  String _getDayName(int index) {
    return ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
  }
  
  int _getDayOfMonth(int index) {
    return _weekStart.add(Duration(days: index)).day;
  }
  
  String _getDayOfWeek(int index) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[index];
  }

  @override
  Widget build(BuildContext context) {
    final workoutProgram = _workoutProgramService.workoutProgram;
    
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.calendar_month, size: 24),
            const SizedBox(width: 8),
            const Text('Planner'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                Text(_getWeekRange(), style: AppTextStyles.subtitle),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final day = _getDayOfMonth(index);
                    final dayName = _getDayName(index);
                    final isSelected = index == DateTime.now().weekday - 1 && 
                                      _weekStart.day <= DateTime.now().day && 
                                      _weekStart.add(Duration(days: 6)).day >= DateTime.now().day;
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.blue500 : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(dayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : AppColors.gray500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('$day',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Workouts', 'Meals', 'Sleep'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: AppColors.blue500,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.gray700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _buildContent(workoutProgram),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent(workoutProgram) {
    // Check if no workout program
    if (workoutProgram == null && _selectedFilter != 'Meals' && _selectedFilter != 'Sleep') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64, color: AppColors.gray300),
            const SizedBox(height: AppSpacing.spacing16),
            Text(
              'No workout program available',
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              'Complete registration to generate your program',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    // Build content based on selected filter
    List<Widget> allCards = [];
    
    // Add workout cards
    if (_selectedFilter == 'All' || _selectedFilter == 'Workouts') {
      if (workoutProgram != null) {
        for (var workoutDay in workoutProgram.workoutDays) {
          allCards.add(_buildWorkoutCard(workoutDay));
        }
      }
    }
    
    // Add meal cards (placeholder for now)
    if (_selectedFilter == 'All' || _selectedFilter == 'Meals') {
      allCards.add(_buildMealCard('Breakfast', '400 kcal', 'Monday'));
      allCards.add(_buildMealCard('Lunch', '600 kcal', 'Monday'));
      allCards.add(_buildMealCard('Dinner', '700 kcal', 'Monday'));
    }
    
    // Add sleep card (placeholder for now)
    if (_selectedFilter == 'All' || _selectedFilter == 'Sleep') {
      allCards.add(_buildSleepCard('Sleep Goal', '8 hours', 'Every day'));
    }
    
    if (allCards.isEmpty) {
      return Center(
        child: Text(
          'No items scheduled',
          style: AppTextStyles.body,
        ),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: allCards,
    );
  }
  
  Widget _buildWorkoutCard(workoutDay) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.workoutDetail,
            arguments: workoutDay,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.fitness_center,
                  color: AppColors.blue500,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workoutDay.name,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      '${workoutDay.exercises.length} exercises • ${workoutDay.estimatedDuration} min',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      workoutDay.dayOfWeek,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.workoutDetail,
                    arguments: workoutDay,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 36),
                  backgroundColor: AppColors.gray900,
                ),
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMealCard(String title, String calories, String day) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.meals);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.orange500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  color: AppColors.orange500,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      calories,
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      day,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.meals);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 36),
                  backgroundColor: AppColors.orange500,
                ),
                child: const Text('View'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSleepCard(String title, String duration, String day) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.sleep);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blue500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.bedtime,
                  color: AppColors.blue500,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      duration,
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      day,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.sleep);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 36),
                  backgroundColor: AppColors.blue500,
                ),
                child: const Text('Track'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
