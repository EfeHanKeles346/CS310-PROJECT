import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Simulate login validation
      if (_emailController.text != 'user@example.com' || 
          _passwordController.text != 'password123') {
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Credentials'),
            content: const Text('Please check email and password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show success dialog (Phase 2.2 requirement)
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('Welcome back to FitMind!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to main app
                  Navigator.pushReplacementNamed(context, AppRoutes.mainScaffold);
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive design - adapt to different screen sizes (Phase 2.2 requirement)
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? AppSpacing.spacing32 : AppSpacing.screenPadding;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const SizedBox(height: AppSpacing.spacing24),
                Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing32),
                Text(
                  'Welcome Back',
                  style: AppTextStyles.largeTitle,
                ),
                const SizedBox(height: AppSpacing.spacing8),
                Text(
                  'Sign in to access your offline data',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.spacing32),
                
                // Email field
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
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing20),
                
                // Password field
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
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacing8),
                Text(
                  'Demo: use user@example.com / password123',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.spacing32),
                
                // Login button
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Login'),
                ),
                const SizedBox(height: AppSpacing.spacing16),
                
                // Register link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register1);
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.blue500,
                      ),
                    ),
                  ),
                ),
                    ],
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
