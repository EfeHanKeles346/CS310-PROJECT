import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../models/user_data.dart';
import '../../services/user_data_service.dart';
import '../../services/calculation_service.dart';
import '../../services/workout_program_service.dart';
import '../../providers/auth_provider.dart'; // Step 3: Provider for Firebase Auth

class RegisterStep3Screen extends StatefulWidget {
  const RegisterStep3Screen({super.key});

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  final _bodyFatController = TextEditingController();
  final _muscleMassController = TextEditingController();
  
  // Store data from previous steps
  Map<String, dynamic>? _userData;
  final UserDataService _userDataService = UserDataService();
  final WorkoutProgramService _workoutProgramService = WorkoutProgramService();
  
  // Calculated values
  double? _bmr;
  double? _tdee;
  double? _targetCalories;
  MacroNutrients? _macros;
  String? _workoutProgram;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (_userData != null) {
      _calculateProgram();
    }
  }
  
  void _calculateProgram() {
    if (_userData == null) return;
    
    // Create temporary UserData for calculation
    UserData tempUser = UserData(
      name: _userData!['name'] ?? '',
      age: _userData!['age'] ?? 0,
      height: _userData!['height']?.toDouble() ?? 0.0,
      weight: _userData!['weight']?.toDouble() ?? 0.0,
      gender: _userData!['gender'] ?? 'Male',
      primaryGoal: _userData!['primaryGoal'] ?? 'lose_weight',
      targetWeight: _userData!['targetWeight']?.toDouble(),
      trainingExperience: _userData!['trainingExperience'] ?? 'intermediate',
    );
    
    setState(() {
      _bmr = CalculationService.calculateBMR(tempUser);
      _tdee = CalculationService.calculateTDEE(tempUser);
      _targetCalories = CalculationService.calculateTargetCalories(tempUser);
      _macros = CalculationService.calculateMacros(tempUser);
      _workoutProgram = CalculationService.getWorkoutProgram(tempUser);
    });
  }
  
  /// Step 3: Save user data and register with Firebase Authentication
  Future<bool> _saveUserData(BuildContext context) async {
    if (_userData == null) return false;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Step 3: Sign up with Firebase Authentication
    bool success = await authProvider.signUp(
      email: _userData!['email'] ?? '',
      password: _userData!['password'] ?? '',
      displayName: _userData!['name'] ?? '',
      age: _userData!['age'],
      gender: _userData!['gender'],
      height: _userData!['height']?.toDouble(),
      weight: _userData!['weight']?.toDouble(),
      fitnessGoal: _userData!['primaryGoal'],
      activityLevel: _userData!['trainingExperience'],
    );
    
    if (!success) {
      return false;
    }
    
    // Also save to local storage for offline access
    double currentWeight = _userData!['weight']?.toDouble() ?? 0.0;
    
    UserData finalUserData = UserData(
      name: _userData!['name'] ?? '',
      age: _userData!['age'] ?? 0,
      height: _userData!['height']?.toDouble() ?? 0.0,
      weight: currentWeight,
      initialWeight: currentWeight,
      gender: _userData!['gender'] ?? 'Male',
      primaryGoal: _userData!['primaryGoal'] ?? 'lose_weight',
      targetWeight: _userData!['targetWeight']?.toDouble(),
      trainingExperience: _userData!['trainingExperience'] ?? 'intermediate',
      bodyFatPercentage: _bodyFatController.text.isNotEmpty 
          ? double.tryParse(_bodyFatController.text) 
          : null,
      muscleMass: _muscleMassController.text.isNotEmpty 
          ? double.tryParse(_muscleMassController.text) 
          : null,
    );
    
    await _userDataService.saveUserData(finalUserData);
    await _workoutProgramService.generateAndSaveProgram(finalUserData);
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Body Composition')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStepIndicator(false, '1'),
                  Expanded(child: Container(height: 2, color: AppColors.blue500)),
                  _buildStepIndicator(false, '2'),
                  Expanded(child: Container(height: 2, color: AppColors.blue500)),
                  _buildStepIndicator(true, '3'),
                ],
              ),
              const SizedBox(height: 32),
              Text('Body Composition', style: AppTextStyles.largeTitle),
              const SizedBox(height: 8),
              Text('From gym/dietitian measurement', style: AppTextStyles.body),
              const SizedBox(height: 32),
              
              Text('Body Fat %', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyFatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter percentage',
                  suffixText: '%',
                ),
              ),
              const SizedBox(height: 8),
              Text('From DEXA, InBody, or caliper', style: AppTextStyles.caption),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Ranges (Male): Athletic 6-13% • Fitness 14-17%', 
                  style: AppTextStyles.caption),
              ),
              
              const SizedBox(height: 24),
              Text('Muscle Mass', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _muscleMassController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter muscle mass',
                  suffixText: 'kg',
                ),
              ),
              const SizedBox(height: 8),
              Text('Total lean muscle (kg)', style: AppTextStyles.caption),
              
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.green500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green500),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.celebration, color: AppColors.green500),
                        const SizedBox(width: 8),
                        Text('Your Personalized Program:', style: AppTextStyles.subtitle),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_bmr != null)
                      Text('BMR (Mifflin-St Jeor): ${_bmr!.toStringAsFixed(0)} kcal', 
                        style: AppTextStyles.body),
                    if (_tdee != null)
                      Text('TDEE (${_userData?['trainingExperience'] ?? 'Moderate'} Active): ${_tdee!.toStringAsFixed(0)} kcal', 
                        style: AppTextStyles.body),
                    if (_targetCalories != null)
                      Text('Target (${_getGoalText()}): ${_targetCalories!.toStringAsFixed(0)} kcal', 
                        style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    if (_macros != null)
                      Text('Macros: ${_macros!.protein.toStringAsFixed(0)}g P • ${_macros!.carbs.toStringAsFixed(0)}g C • ${_macros!.fats.toStringAsFixed(0)}g F', 
                        style: AppTextStyles.subtitle.copyWith(color: AppColors.green500)),
                    const SizedBox(height: 8),
                    if (_workoutProgram != null)
                      Text('Program: $_workoutProgram', style: AppTextStyles.body),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              // Step 3: Register button with loading state from Provider
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: authProvider.isLoading ? null : () => Navigator.pop(context),
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  bool success = await _saveUserData(context);
                                  if (!mounted) return;
                                  
                                  if (success) {
                                    // Step 3: Registration successful
                                    Navigator.pushNamedAndRemoveUntil(
                                      context, AppRoutes.mainScaffold, (route) => false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Welcome to FitMind!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    // Step 3: Show error message
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Registration Failed'),
                                        content: Text(authProvider.errorMessage ?? 'An error occurred'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.green500),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Calculate My Program'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isActive, String number) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.gray900 : AppColors.gray300,
      ),
      child: Center(
        child: Text(number, style: TextStyle(
          color: isActive ? Colors.white : AppColors.gray700,
          fontWeight: FontWeight.bold,
        )),
      ),
    );
  }

  String _getGoalText() {
    String goal = _userData?['primaryGoal'] ?? 'lose_weight';
    switch (goal) {
      case 'lose_weight':
        return 'Weight Loss';
      case 'build_muscle':
        return 'Muscle Gain';
      default:
        return 'Maintain';
    }
  }
  
  @override
  void dispose() {
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    super.dispose();
  }
}
