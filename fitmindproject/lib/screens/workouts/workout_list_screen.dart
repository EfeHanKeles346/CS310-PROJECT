import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_radius.dart';
import '../../models/workout_model.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Sample workout data - in real app, this would come from SQLite
  List<WorkoutModel> workouts = [
    WorkoutModel(
      id: '1',
      name: 'Push Day',
      exercises: 5,
      duration: 60,
      category: 'Push',
    ),
    WorkoutModel(
      id: '2',
      name: 'Pull Day',
      exercises: 5,
      duration: 60,
      category: 'Pull',
    ),
    WorkoutModel(
      id: '3',
      name: 'Leg Day',
      exercises: 5,
      duration: 60,
      category: 'Legs',
    ),
    WorkoutModel(
      id: '4',
      name: 'Upper Body',
      exercises: 4,
      duration: 45,
      category: 'Upper',
    ),
    WorkoutModel(
      id: '5',
      name: 'Core Workout',
      exercises: 6,
      duration: 30,
      category: 'Core',
    ),
  ];

  List<WorkoutModel> filteredWorkouts = [];

  @override
  void initState() {
    super.initState();
    filteredWorkouts = workouts;
  }

  void _filterWorkouts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWorkouts = workouts;
      } else {
        filteredWorkouts = workouts
            .where((workout) =>
                workout.name.toLowerCase().contains(query.toLowerCase()) ||
                workout.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _removeWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
      _filterWorkouts(_searchController.text);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workout removed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive design - adapt to different screen sizes (Phase 2.2 requirement)
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: const Text('Workouts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _filterWorkouts,
              decoration: InputDecoration(
                hintText: 'Search workouts...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.gray100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Workout list
          Expanded(
            child: filteredWorkouts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: AppColors.gray300,
                        ),
                        const SizedBox(height: AppSpacing.spacing16),
                        Text(
                          'No workouts found',
                          style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    itemCount: filteredWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return Dismissible(
                        key: Key(workout.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
                          decoration: BoxDecoration(
                            color: AppColors.red500,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: AppSpacing.spacing16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          _removeWorkout(workouts.indexOf(workout));
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.workoutDetail);
                            },
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.cardPadding),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.blue100,
                                      borderRadius: BorderRadius.circular(AppRadius.radius8),
                                    ),
                                    child: Icon(
                                      Icons.fitness_center,
                                      color: AppColors.blue500,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.spacing16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workout.name,
                                          style: AppTextStyles.subtitle,
                                        ),
                                        const SizedBox(height: AppSpacing.spacing4),
                                        Text(
                                          '${workout.exercises} exercises • ${workout.duration} min',
                                          style: AppTextStyles.body,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.gray100,
                                      borderRadius: BorderRadius.circular(AppRadius.chip),
                                    ),
                                    child: Text(
                                      workout.category,
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.spacing8),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.red500,
                                    ),
                                    onPressed: () {
                                      _removeWorkout(workouts.indexOf(workout));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Swipe hint
          if (filteredWorkouts.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.swipe_left, size: 20, color: AppColors.mutedText),
                  const SizedBox(width: AppSpacing.spacing8),
                  Text(
                    'Swipe left to remove',
                    style: AppTextStyles.caption,
                  ),
                ],
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
