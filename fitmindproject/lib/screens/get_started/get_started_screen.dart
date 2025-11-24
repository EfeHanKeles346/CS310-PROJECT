import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/app_radius.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive design - adapt to different screen sizes (Phase 2.2 requirement)
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenHeight < 700;
    final imageHeight = isTablet ? 300.0 : (isSmallScreen ? 150.0 : 200.0);
    final horizontalPadding = isTablet ? AppSpacing.spacing32 : AppSpacing.screenPadding;
    final verticalSpacing = isSmallScreen ? AppSpacing.spacing8 : AppSpacing.spacing16;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSpacing.spacing16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 600 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.spacing16),
                  // Local asset image - satisfies Phase 2.2 requirement
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: Image.asset(
                      'assets/images/fitness_image.jpg',
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: imageHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 48,
                                color: AppColors.gray900,
                              ),
                              const SizedBox(height: AppSpacing.spacing8),
                              Text(
                                'FitMind',
                                style: AppTextStyles.largeTitle,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  Text(
                    'Welcome to FitMind',
                    style: AppTextStyles.largeTitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: verticalSpacing * 1.5),
                  _buildFeatureCard(
                    icon: Icons.show_chart,
                    title: 'Track Progress',
                    description: 'Monitor body measurements offline',
                  ),
                  SizedBox(height: verticalSpacing),
                  _buildFeatureCard(
                    icon: Icons.calendar_today,
                    title: 'Weekly Planning',
                    description: 'Plan workouts, meals, sleep',
                  ),
                  SizedBox(height: verticalSpacing),
                  _buildFeatureCard(
                    icon: Icons.restaurant_menu,
                    title: 'Nutrition Database',
                    description: 'Editable local food database',
                  ),
                  SizedBox(height: verticalSpacing * 2),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register1);
                    },
                    child: const Text('Continue'),
                  ),
                  const SizedBox(height: AppSpacing.spacing12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.blue500,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.blue100,
              borderRadius: BorderRadius.circular(AppRadius.radius12),
            ),
            child: Icon(icon, color: AppColors.blue500),
          ),
          const SizedBox(width: AppSpacing.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitle),
                const SizedBox(height: AppSpacing.spacing4),
                Text(description, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
