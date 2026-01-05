import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo - using Icon as placeholder for actual logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: AppColors.gray900,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'FM',
                    style: AppTextStyles.largeTitle.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            Text(
              'FitMind',
              style: AppTextStyles.largeTitle,
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              'Your offline fitness & nutrition\ncompanion',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing48),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.getStarted);
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
