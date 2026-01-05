import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../models/workout_program_model.dart';
import '../../models/exercise_model.dart';
import '../../services/workout_log_service.dart';

class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({super.key});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  WorkoutDay? _workoutDay;
  final WorkoutLogService _workoutLogService = WorkoutLogService();
  
  // Track sets for each exercise: exerciseId -> list of sets
  Map<String, List<ExerciseSet>> _exerciseSets = {};
  
  final Map<String, TextEditingController> _rpeControllers = {};
  final Map<String, TextEditingController> _notesControllers = {};
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get workout day from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is WorkoutDay && _workoutDay == null) {
      _workoutDay = args;
      _loadPreviousWorkout();
    }
  }
  
  void _loadPreviousWorkout() {
    if (_workoutDay == null) return;
    
    // Load previous workout log if exists
    final previousLog = _workoutLogService.getWorkoutLog(_workoutDay!.id);
    
    for (var exercise in _workoutDay!.exercises) {
      // Check if we have previous data for this exercise
      final previousExercise = previousLog?.exercises.firstWhere(
        (e) => e.exerciseId == exercise.id,
        orElse: () => ExerciseLog(
          exerciseId: exercise.id,
          exerciseName: exercise.name,
          sets: [],
        ),
      );
      
      if (previousExercise != null && previousExercise.sets.isNotEmpty) {
        // Load previous sets
        _exerciseSets[exercise.id] = previousExercise.sets.map((setLog) {
          return ExerciseSet(
            setNumber: setLog.setNumber,
            weight: setLog.weight,
            reps: setLog.reps,
            completed: setLog.completed,
          );
        }).toList();
        
        // Load notes
        _notesControllers[exercise.id] = TextEditingController(
          text: previousExercise.notes ?? '',
        );
      } else {
        // No previous data, initialize with default sets
        _exerciseSets[exercise.id] = List.generate(
          exercise.sets,
          (index) => ExerciseSet(setNumber: index + 1),
        );
        _notesControllers[exercise.id] = TextEditingController();
      }
      
      _rpeControllers[exercise.id] = TextEditingController();
    }
    
    setState(() {});
  }
  
  void _updateSet(int exerciseIndex, int setIndex, double? weight, int? reps) {
    final exerciseId = _workoutDay!.exercises[exerciseIndex].id;
    if (_exerciseSets[exerciseId] != null && setIndex < _exerciseSets[exerciseId]!.length) {
      setState(() {
        _exerciseSets[exerciseId]![setIndex].weight = weight;
        _exerciseSets[exerciseId]![setIndex].reps = reps;
        _exerciseSets[exerciseId]![setIndex].completed = weight != null && reps != null;
      });
      _saveWorkoutProgress();
    }
  }
  
  void _addSet(String exerciseId) {
    if (_exerciseSets[exerciseId] != null) {
      setState(() {
        final newSetNumber = _exerciseSets[exerciseId]!.length + 1;
        _exerciseSets[exerciseId]!.add(ExerciseSet(setNumber: newSetNumber));
      });
    }
  }
  
  void _removeSet(String exerciseId, int setIndex) {
    if (_exerciseSets[exerciseId] != null && _exerciseSets[exerciseId]!.length > 1) {
      setState(() {
        _exerciseSets[exerciseId]!.removeAt(setIndex);
        // Renumber remaining sets
        for (int i = 0; i < _exerciseSets[exerciseId]!.length; i++) {
          _exerciseSets[exerciseId]![i].setNumber = i + 1;
        }
      });
      _saveWorkoutProgress();
    }
  }
  
  Future<void> _saveWorkoutProgress() async {
    if (_workoutDay == null) return;
    
    // Convert current state to WorkoutLog
    final exerciseLogs = _workoutDay!.exercises.map((exercise) {
      final sets = _exerciseSets[exercise.id]?.map((set) {
        return ExerciseSetLog(
          setNumber: set.setNumber,
          weight: set.weight,
          reps: set.reps,
          completed: set.completed,
        );
      }).toList() ?? [];
      
      return ExerciseLog(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        sets: sets,
        notes: _notesControllers[exercise.id]?.text,
      );
    }).toList();
    
    final workoutLog = WorkoutLog(
      workoutDayId: _workoutDay!.id,
      workoutName: _workoutDay!.name,
      exercises: exerciseLogs,
      lastPerformed: DateTime.now(),
    );
    
    await _workoutLogService.saveWorkoutLog(workoutLog);
  }
  
  bool _isWorkoutComplete() {
    if (_workoutDay == null) return false;
    
    for (var exercise in _workoutDay!.exercises) {
      final sets = _exerciseSets[exercise.id];
      if (sets == null) return false;
      
      for (var set in sets) {
        if (!set.completed) return false;
      }
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_workoutDay == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: const Center(child: Text('Workout not found')),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: Text(_workoutDay!.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Row(
                      children: [
                        Icon(Icons.fitness_center, color: AppColors.blue500),
                        const SizedBox(width: 8),
                    Text(
                      '${_workoutDay!.exercises.length} exercises • Est. ${_workoutDay!.estimatedDuration} min',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            
            // Exercises list
            ..._workoutDay!.exercises.asMap().entries.map((entry) {
              final exerciseIndex = entry.key;
                  final exercise = entry.value;
              final sets = _exerciseSets[exercise.id] ?? [];
              
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.spacing16),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      // Exercise header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.name,
                                  style: AppTextStyles.subtitle,
                                ),
                                const SizedBox(height: AppSpacing.spacing4),
                                Text(
                                  '${exercise.sets} sets × ${exercise.reps} reps • ${exercise.restSeconds}s rest',
                                  style: AppTextStyles.body,
                                ),
                                if (exercise.rpe != null)
                                  Text(
                                    'RPE: ${exercise.rpe}',
                                    style: AppTextStyles.caption,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing12),
                      
                      // Sets input
                      ...sets.asMap().entries.map((setEntry) {
                        final setIndex = setEntry.key;
                        final exerciseSet = setEntry.value;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                          padding: const EdgeInsets.all(AppSpacing.spacing12),
                          decoration: BoxDecoration(
                            color: exerciseSet.completed 
                                ? AppColors.green500.withOpacity(0.1)
                                : AppColors.gray100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: exerciseSet.completed 
                                  ? AppColors.green500
                                  : AppColors.gray300,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Set number
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: exerciseSet.completed 
                                      ? AppColors.green500
                                      : AppColors.gray300,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${exerciseSet.setNumber}',
                                    style: TextStyle(
                                      color: exerciseSet.completed 
                                          ? Colors.white
                                          : AppColors.gray700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.spacing12),
                              
                              // Weight input
                              Expanded(
                                child: TextField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Weight (kg)',
                                    hintText: '0.0',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    final weight = double.tryParse(value);
                                    _updateSet(exerciseIndex, setIndex, weight, exerciseSet.reps);
                                  },
                                  controller: TextEditingController(
                                    text: exerciseSet.weight != null 
                                        ? exerciseSet.weight!.toStringAsFixed(1) 
                                        : '',
                                  )..selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: exerciseSet.weight != null 
                                            ? exerciseSet.weight!.toStringAsFixed(1).length 
                                            : 0,
                                      ),
                                    ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.spacing8),
                              
                              // Reps input
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Reps',
                                    hintText: '0',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    final reps = int.tryParse(value);
                                    _updateSet(exerciseIndex, setIndex, exerciseSet.weight, reps);
                                  },
                                  controller: TextEditingController(
                                    text: exerciseSet.reps != null 
                                        ? exerciseSet.reps.toString() 
                                        : '',
                                  )..selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: exerciseSet.reps != null 
                                            ? exerciseSet.reps.toString().length 
                                            : 0,
                                      ),
                                    ),
                                ),
                              ),
                              
                              // Checkbox
                              Checkbox(
                                value: exerciseSet.completed,
                                onChanged: (value) {
                                  setState(() {
                                    exerciseSet.completed = value ?? false;
                                  });
                                  _saveWorkoutProgress();
                                },
                                activeColor: AppColors.green500,
                              ),
                              
                              // Delete set button
                              if (sets.length > 1)
                                IconButton(
                                  icon: Icon(Icons.close, size: 18, color: AppColors.red500),
                                  onPressed: () => _removeSet(exercise.id, setIndex),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                  ],
                ),
                        );
                      }),
                      
                      // Add Set button
                      const SizedBox(height: AppSpacing.spacing8),
                      OutlinedButton.icon(
                        onPressed: () => _addSet(exercise.id),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Set'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.blue500,
                          side: BorderSide(color: AppColors.blue500),
                          minimumSize: const Size(double.infinity, 36),
                        ),
                      ),
                      
                      // Exercise notes
                      const SizedBox(height: AppSpacing.spacing8),
                      TextField(
                        controller: _notesControllers[exercise.id],
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Notes for ${exercise.name}...',
                          isDense: true,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.note, size: 20),
                        ),
                        onChanged: (value) {
                          _saveWorkoutProgress();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            const SizedBox(height: AppSpacing.spacing24),
            
            // Complete workout button
            ElevatedButton(
              onPressed: _isWorkoutComplete()
                  ? () async {
                      await _saveWorkoutProgress();
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Workout completed! 🎉'),
                            backgroundColor: AppColors.green500,
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green500,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                _isWorkoutComplete() 
                    ? 'Complete Workout'
                    : 'Complete all sets to finish',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    for (var controller in _rpeControllers.values) {
      controller.dispose();
    }
    for (var controller in _notesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
