import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  String _selectedGoal = 'lose_weight';
  final _targetWeightController = TextEditingController();
  String _selectedExperience = 'intermediate';
  
  // Store data from previous step
  Map<String, dynamic>? _previousData;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get arguments from previous screen
    _previousData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Your Goals')),
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
                  _buildStepIndicator(true, '2'),
                  Expanded(child: Container(height: 2, color: AppColors.gray300)),
                  _buildStepIndicator(false, '3'),
                ],
              ),
              const SizedBox(height: 32),
              Text('Your Fitness Goals', style: AppTextStyles.largeTitle),
              const SizedBox(height: 8),
              Text('Create your personalized program', style: AppTextStyles.body),
              const SizedBox(height: 32),
              
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
                isExpanded: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.fitness_center),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'beginner',
                    child: Text(
                      'Beginner (0-6 months)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'intermediate',
                    child: Text(
                      'Intermediate (6 months - 2 years)',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'advanced',
                    child: Text(
                      'Advanced (2+ years)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _selectedExperience = value!),
              ),
              
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_previousData != null) {
                          // Pass all data to next screen
                          Map<String, dynamic> data = Map.from(_previousData!);
                          data['primaryGoal'] = _selectedGoal;
                          data['targetWeight'] = _targetWeightController.text.isNotEmpty 
                              ? double.tryParse(_targetWeightController.text) 
                              : null;
                          data['trainingExperience'] = _selectedExperience;
                          
                          Navigator.pushNamed(
                            context, 
                            AppRoutes.register3,
                            arguments: data,
                          );
                        }
                      },
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  @override
  void dispose() {
    _targetWeightController.dispose();
    super.dispose();
  }
}
