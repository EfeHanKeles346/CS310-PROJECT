import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/user_data_service.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key});

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _muscleMassController = TextEditingController();
  final _waistController = TextEditingController();
  final _chestController = TextEditingController();
  final _armsController = TextEditingController();
  final UserDataService _userDataService = UserDataService();

  Future<void> _saveMeasurement() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userData = _userDataService.userData;
    if (userData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User data not found. Please complete registration first.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Parse input values
    final weight = double.tryParse(_weightController.text);
    final bodyFat = double.tryParse(_bodyFatController.text);
    final muscleMass = _muscleMassController.text.isNotEmpty 
        ? double.tryParse(_muscleMassController.text) 
        : null;

    if (weight == null || bodyFat == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid numbers'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Update user data with new measurements
    final updatedData = userData.copyWith(
      weight: weight,
      bodyFatPercentage: bodyFat,
      muscleMass: muscleMass,
    );

    await _userDataService.updateUserData(updatedData);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Measurement saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Measurement'),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        leadingWidth: 80,
        actions: [
          TextButton(
            onPressed: _saveMeasurement,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Required Measurements', style: AppTextStyles.subtitle),
              const SizedBox(height: 16),
              
              Text('Weight', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter weight',
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Weight is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              Text('Body Fat %', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyFatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter percentage',
                  suffixText: '%',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Body fat percentage is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text('Acceptable: 14-24% (male fitness)', style: AppTextStyles.caption),
              
              const SizedBox(height: 20),
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
              Text('Optional Measurements', style: AppTextStyles.subtitle),
              const SizedBox(height: 16),
              
              Text('Waist', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _waistController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Circumference',
                  suffixText: 'cm',
                ),
              ),
              
              const SizedBox(height: 20),
              Text('Chest', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _chestController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Circumference',
                  suffixText: 'cm',
                ),
              ),
              
              const SizedBox(height: 20),
              Text('Arms', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _armsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Circumference',
                  suffixText: 'cm',
                ),
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveMeasurement,
                child: const Text('Save Measurement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    _waistController.dispose();
    _chestController.dispose();
    _armsController.dispose();
    super.dispose();
  }
}
