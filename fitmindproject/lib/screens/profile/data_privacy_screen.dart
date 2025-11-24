import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class DataPrivacyScreen extends StatelessWidget {
  const DataPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Data & Privacy'),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.green500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.green500),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_user, color: AppColors.green500, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('100% Offline', style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.green500,
                        )),
                        Text('All your data stays on your device', 
                          style: AppTextStyles.body),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Data Storage', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDataRow(Icons.phone_android, 'Local Storage', 'All data stored on device'),
                    const SizedBox(height: 12),
                    _buildDataRow(Icons.cloud_off, 'No Cloud Sync', 'No data sent to servers'),
                    const SizedBox(height: 12),
                    _buildDataRow(Icons.security, 'Encrypted', 'Data protected by device security'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('What We Store', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Personal information (name, age, height)', style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    Text('• Body measurements and progress', style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    Text('• Workout and meal plans', style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    Text('• Food database entries', style: AppTextStyles.body),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Your Rights', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.delete_outline, color: AppColors.gray700),
                    title: Text('Delete All Data', style: AppTextStyles.body),
                    subtitle: Text('Remove all your data from the app', style: AppTextStyles.caption),
                    trailing: Icon(Icons.chevron_right, color: AppColors.gray500),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Use "Clear All Data" from Profile')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.file_download_outlined, color: AppColors.gray700),
                    title: Text('Export Data', style: AppTextStyles.body),
                    subtitle: Text('Download your data (coming soon)', style: AppTextStyles.caption),
                    trailing: Icon(Icons.chevron_right, color: AppColors.gray500),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Export feature coming soon')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blue100.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.blue500, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'FitMind does not collect, share, or sell your data',
                      style: AppTextStyles.caption.copyWith(color: AppColors.blue500),
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
  
  Widget _buildDataRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.gray700, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              )),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

