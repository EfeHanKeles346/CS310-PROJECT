import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(); // Step 3: Email for Firebase Auth
  final _passwordController = TextEditingController(); // Step 3: Password for Firebase Auth
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedGender = 'Male';
  bool _isPasswordVisible = false; // For password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                Row(
                  children: [
                    _buildStepIndicator(true, '1'),
                    Expanded(child: Container(height: 2, color: AppColors.gray300)),
                    _buildStepIndicator(false, '2'),
                    Expanded(child: Container(height: 2, color: AppColors.gray300)),
                    _buildStepIndicator(false, '3'),
                  ],
                ),
                const SizedBox(height: AppSpacing.spacing32),
                
                Text('Basic Information', style: AppTextStyles.largeTitle),
                const SizedBox(height: AppSpacing.spacing8),
                Text("Let's get to know you", style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.spacing32),
                
                // Full Name
                Text('Full Name', style: AppTextStyles.formLabel),
                const SizedBox(height: AppSpacing.spacing8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    // Check if name contains only letters and spaces
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Name should only contain letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing20),
                
                // Email (Step 3: Required for Firebase Authentication)
                Text('Email', style: AppTextStyles.formLabel),
                const SizedBox(height: AppSpacing.spacing8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing20),
                
                // Password (Step 3: Required for Firebase Authentication)
                Text('Password', style: AppTextStyles.formLabel),
                const SizedBox(height: AppSpacing.spacing8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing20),
                
                // Age
                Text('Age', style: AppTextStyles.formLabel),
                const SizedBox(height: AppSpacing.spacing8),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter your age',
                    suffixText: 'years',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null) {
                      return 'Age must be a number';
                    }
                    if (age < 13 || age > 120) {
                      return 'Please enter a valid age (13-120)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing20),
                
                // Height
                Text('Height', style: AppTextStyles.formLabel),
                const SizedBox(height: AppSpacing.spacing8),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter height',
                    suffixText: 'cm',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null) {
                      return 'Height must be a number';
                    }
                    if (height < 50 || height > 300) {
                      return 'Please enter a valid height (50-300 cm)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing20),
                
                // Gender
                Text('Gender', style: AppTextStyles.formLabel),
                const SizedBox(height: AppSpacing.spacing8),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.wc),
                  ),
                  items: ['Male', 'Female', 'Other'].map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.spacing20),
                
                // Current Weight
                Text('Current Weight', style: AppTextStyles.formLabel),
                const SizedBox(height: AppSpacing.spacing8),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter weight',
                    suffixText: 'kg',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null) {
                      return 'Weight must be a number';
                    }
                    if (weight < 20 || weight > 500) {
                      return 'Please enter a valid weight (20-500 kg)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing32),
                
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Pass data to next screen via arguments (Step 3: Include email & password)
                      Navigator.pushNamed(
                        context, 
                        AppRoutes.register2,
                        arguments: {
                          'name': _nameController.text,
                          'email': _emailController.text.trim(), // Step 3: Email for Firebase
                          'password': _passwordController.text, // Step 3: Password for Firebase
                          'age': int.parse(_ageController.text),
                          'height': double.parse(_heightController.text),
                          'weight': double.parse(_weightController.text),
                          'gender': _selectedGender,
                        },
                      );
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
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
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.gray700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose(); // Step 3
    _passwordController.dispose(); // Step 3
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
