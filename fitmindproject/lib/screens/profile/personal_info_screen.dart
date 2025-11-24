import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/user_data_service.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final UserDataService _userDataService = UserDataService();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String _selectedGender = 'Male';
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Listen to changes in user data
    _userDataService.addListener(_onUserDataChanged);
  }
  
  void _loadUserData() {
    final userData = _userDataService.userData;
    _nameController = TextEditingController(text: userData?.name ?? '');
    _ageController = TextEditingController(text: userData?.age.toString() ?? '');
    _heightController = TextEditingController(text: userData?.height.toString() ?? '');
    _weightController = TextEditingController(text: userData?.weight.toString() ?? '');
    _selectedGender = userData?.gender ?? 'Male';
  }
  
  void _onUserDataChanged() {
    // Update controllers when data changes externally (e.g., from home screen)
    final userData = _userDataService.userData;
    if (userData != null && mounted) {
      setState(() {
        _nameController.text = userData.name;
        _ageController.text = userData.age.toString();
        _heightController.text = userData.height.toString();
        _weightController.text = userData.weight.toString();
        _selectedGender = userData.gender;
      });
    }
  }
  
  @override
  void dispose() {
    _userDataService.removeListener(_onUserDataChanged);
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
  
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    
    final userData = _userDataService.userData;
    if (userData == null) return;
    
    final updatedData = userData.copyWith(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? userData.age,
      height: double.tryParse(_heightController.text) ?? userData.height,
      weight: double.tryParse(_weightController.text) ?? userData.weight,
      gender: _selectedGender,
    );
    
    await _userDataService.updateUserData(updatedData);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personal info updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Personal Info'),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              Text('Age', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your age',
                  suffixText: 'years',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Age is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              Text('Height', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your height',
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Height is required';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              Text('Weight', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your weight',
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
              Text('Gender', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.wc),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => _selectedGender = value!),
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

