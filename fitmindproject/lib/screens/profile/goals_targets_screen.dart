import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/user_data_service.dart';
import '../../services/calculation_service.dart';

class GoalsTargetsScreen extends StatefulWidget {
  const GoalsTargetsScreen({super.key});

  @override
  State<GoalsTargetsScreen> createState() => _GoalsTargetsScreenState();
}

class _GoalsTargetsScreenState extends State<GoalsTargetsScreen> {
  final UserDataService _userDataService = UserDataService();
  final _targetWeightController = TextEditingController();
  
  String _selectedGoal = 'lose_weight';
  String _selectedExperience = 'intermediate';
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Listen to changes in user data
    _userDataService.addListener(_onUserDataChanged);
  }
  
  void _loadUserData() {
    final userData = _userDataService.userData;
    if (userData != null) {
      _selectedGoal = userData.primaryGoal;
      _selectedExperience = userData.trainingExperience;
      _targetWeightController.text = userData.targetWeight?.toString() ?? '';
    }
  }
  
  void _onUserDataChanged() {
    // Update UI when data changes externally
    final userData = _userDataService.userData;
    if (userData != null && mounted) {
      setState(() {
        _selectedGoal = userData.primaryGoal;
        _selectedExperience = userData.trainingExperience;
        _targetWeightController.text = userData.targetWeight?.toString() ?? '';
      });
    }
  }
  
  @override
  void dispose() {
    _userDataService.removeListener(_onUserDataChanged);
    _targetWeightController.dispose();
    super.dispose();
  }
  
  Future<void> _saveChanges() async {
    final userData = _userDataService.userData;
    if (userData == null) return;
    
    final updatedData = userData.copyWith(
      primaryGoal: _selectedGoal,
      targetWeight: _targetWeightController.text.isNotEmpty 
          ? double.tryParse(_targetWeightController.text) 
          : null,
      trainingExperience: _selectedExperience,
    );
    
    await _userDataService.updateUserData(updatedData);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goals updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Always get fresh data from service
    final userData = _userDataService.userData;
    
    // Recalculate based on current selections
    final tempUserData = userData?.copyWith(
      primaryGoal: _selectedGoal,
      targetWeight: _targetWeightController.text.isNotEmpty 
          ? double.tryParse(_targetWeightController.text) 
          : userData.targetWeight,
      trainingExperience: _selectedExperience,
    );
    
    final targetCalories = tempUserData != null 
        ? CalculationService.calculateTargetCalories(tempUserData) 
        : 0;
    final macros = tempUserData != null 
        ? CalculationService.calculateMacros(tempUserData) 
        : null;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Goals & Targets'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary Goal', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            _buildGoalOption('lose_weight', 'Lose Weight', 'Burn fat and slim down', Icons.trending_down),
            const SizedBox(height: 12),
            _buildGoalOption('build_muscle', 'Build Muscle', 'Gain strength and mass', Icons.trending_up),
            
            const SizedBox(height: 24),
            Text('Target Weight', style: AppTextStyles.formLabel),
            const SizedBox(height: 8),
            TextFormField(
              controller: _targetWeightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Your goal weight',
                suffixText: 'kg',
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Training Experience', style: AppTextStyles.formLabel),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedExperience,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fitness_center),
              ),
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner (0-6 months)')),
                DropdownMenuItem(value: 'intermediate', child: Text('Intermediate (6 months - 2 years)')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced (2+ years)')),
              ],
              onChanged: (value) => setState(() => _selectedExperience = value!),
            ),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blue100.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blue500),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.blue500),
                      const SizedBox(width: 8),
                      Text('Current Targets:', style: AppTextStyles.subtitle),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Daily Calories: ${targetCalories.toStringAsFixed(0)} kcal', 
                    style: AppTextStyles.body),
                  if (macros != null)
                    Text('Macros: ${macros.protein.toStringAsFixed(0)}g P • ${macros.carbs.toStringAsFixed(0)}g C • ${macros.fats.toStringAsFixed(0)}g F', 
                      style: AppTextStyles.body.copyWith(color: AppColors.blue500)),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGoalOption(String value, String title, String subtitle, IconData icon) {
    final isSelected = _selectedGoal == value;
    return InkWell(
      onTap: () => setState(() => _selectedGoal = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.blue500 : AppColors.gray300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.blue100.withOpacity(0.3) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.blue500 : AppColors.gray500),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitle),
                  Text(subtitle, style: AppTextStyles.body),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedGoal,
              onChanged: (v) => setState(() => _selectedGoal = v!),
              activeColor: AppColors.blue500,
            ),
          ],
        ),
      ),
    );
  }
}

