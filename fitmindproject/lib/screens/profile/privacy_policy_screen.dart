import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FitMind Privacy Policy', style: AppTextStyles.largeTitle),
            const SizedBox(height: 8),
            Text('Last updated: November 2025', style: AppTextStyles.caption),
            const SizedBox(height: 24),
            
            _buildSection(
              'Overview',
              'FitMind is designed with privacy as a core principle. This app operates entirely offline, and all your data remains on your device.',
            ),
            
            _buildSection(
              'Data Collection',
              'FitMind does not collect, transmit, or share any personal data with third parties. All information you enter (measurements, meals, workouts, etc.) is stored locally on your device using SQLite.',
            ),
            
            _buildSection(
              'Data Storage',
              'Your data is stored locally using:\n\n• SharedPreferences for user settings\n• SQLite database for workout and meal data\n• Device-level encryption (if enabled on your device)',
            ),
            
            _buildSection(
              'No Internet Required',
              'FitMind works 100% offline. The app does not require an internet connection and does not communicate with any servers.',
            ),
            
            _buildSection(
              'Data Deletion',
              'You can delete all your data at any time from the Profile > Clear All Data option. This action is permanent and cannot be undone.',
            ),
            
            _buildSection(
              'Third-Party Services',
              'FitMind does not use any third-party analytics, advertising, or tracking services.',
            ),
            
            _buildSection(
              'Changes to Privacy Policy',
              'Any changes to this privacy policy will be reflected in app updates. Continued use of the app constitutes acceptance of the updated policy.',
            ),
            
            _buildSection(
              'Contact',
              'For questions about this privacy policy or data handling, please contact:\n\nCS310 Group 6\nMobile Application Development',
            ),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.green500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.green500),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.green500),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your privacy is protected. All data stays on your device.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.green500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          Text(content, style: AppTextStyles.body),
        ],
      ),
    );
  }
}

