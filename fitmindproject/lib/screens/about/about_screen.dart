import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About FitMind'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 48, color: AppColors.gray900),
                  const SizedBox(height: 8),
                  Text('FM', style: AppTextStyles.largeTitle.copyWith(
                    fontWeight: FontWeight.w900,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('FitMind', style: AppTextStyles.largeTitle),
            const SizedBox(height: 8),
            Text('Offline Fitness & Nutrition Companion', 
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('Version 1.0.0', style: AppTextStyles.caption),
            const SizedBox(height: 32),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About This App', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                    Text(
                      'FitMind is a measurement-based fitness and nutrition tracking app that works 100% offline. All your data stays on your device.',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Privacy & Data', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                    Text(
                      'All data stored locally using SQLite. No cloud sync, no tracking, complete privacy.',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Features', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                    _buildFeature('• Personalized calorie & macro targets'),
                    _buildFeature('• Weekly workout & meal planning'),
                    _buildFeature('• Body measurement tracking'),
                    _buildFeature('• Editable food database'),
                    _buildFeature('• Progress charts & analytics'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Team', style: AppTextStyles.subtitle),
                    const SizedBox(height: 12),
                    Text('CS310 Group 6', style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    Text('Mobile Application Development', style: AppTextStyles.body),
                    Text('November 2025', style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Network image from URL - satisfies Phase 2.2 requirement
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.gray100,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.blue500,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, 
                            size: 48, 
                            color: AppColors.gray500),
                          const SizedBox(height: 8),
                          Text('Network image placeholder', 
                            style: AppTextStyles.caption),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: AppTextStyles.body),
    );
  }
}
