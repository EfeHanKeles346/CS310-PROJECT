import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_program_model.dart';
import '../models/user_data.dart';
import 'workout_program_generator.dart';

class WorkoutProgramService extends ChangeNotifier {
  static final WorkoutProgramService _instance = WorkoutProgramService._internal();
  factory WorkoutProgramService() => _instance;
  WorkoutProgramService._internal() {
    _loadWorkoutProgram();
  }
  
  WorkoutProgram? _workoutProgram;
  static const String _workoutProgramKey = 'workout_program';
  
  WorkoutProgram? get workoutProgram => _workoutProgram;
  
  bool get hasProgram => _workoutProgram != null;
  
  // Load workout program from SharedPreferences
  Future<void> _loadWorkoutProgram() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final programString = prefs.getString(_workoutProgramKey);
      
      if (programString != null) {
        final Map<String, dynamic> programMap = jsonDecode(programString);
        _workoutProgram = WorkoutProgram.fromMap(programMap);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading workout program: $e');
    }
  }
  
  // Generate and save workout program based on user data
  Future<void> generateAndSaveProgram(UserData userData) async {
    _workoutProgram = WorkoutProgramGenerator.generateProgram(userData);
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final programString = jsonEncode(_workoutProgram!.toMap());
      await prefs.setString(_workoutProgramKey, programString);
      debugPrint('Workout program saved successfully');
    } catch (e) {
      debugPrint('Error saving workout program: $e');
    }
  }
  
  // Save workout program
  Future<void> saveWorkoutProgram(WorkoutProgram program) async {
    _workoutProgram = program;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final programString = jsonEncode(program.toMap());
      await prefs.setString(_workoutProgramKey, programString);
    } catch (e) {
      debugPrint('Error saving workout program: $e');
    }
  }
  
  // Clear workout program
  Future<void> clearWorkoutProgram() async {
    _workoutProgram = null;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_workoutProgramKey);
    } catch (e) {
      debugPrint('Error clearing workout program: $e');
    }
  }
  
  // Refresh program from storage
  Future<void> refresh() async {
    await _loadWorkoutProgram();
  }
}

