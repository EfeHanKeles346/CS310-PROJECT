import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/user_data_service.dart';
import '../../services/workout_log_service.dart';
import '../../services/workout_program_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDataService _userDataService = UserDataService();
  final WorkoutLogService _workoutLogService = WorkoutLogService();
  final WorkoutProgramService _workoutProgramService = WorkoutProgramService();

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will delete all your data including measurements, goals, and progress. This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red500),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Clear all data
      await _userDataService.clearUserData();
      await _workoutLogService.clearAllLogs();
      await _workoutProgramService.clearWorkoutProgram();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.getStarted, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = _userDataService.userData;
    final userName = userData?.name ?? 'User';
    final userInitials = userName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase();
    
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person, size: 24),
            const SizedBox(width: 8),
            const Text('Profile'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.blue100,
                      child: Text(userInitials, style: AppTextStyles.largeTitle.copyWith(
                        color: AppColors.blue500,
                      )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userName, style: AppTextStyles.subtitle),
                          Text(userData != null 
                            ? '${userData.age} years • ${userData.gender}' 
                            : 'No data available', 
                            style: AppTextStyles.body),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Account', style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedText,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                  _buildMenuItem('Personal Info', Icons.person_outline, () {
                    Navigator.pushNamed(context, AppRoutes.personalInfo);
                  }),
                  _buildMenuItem('Goals & Targets', Icons.flag_outlined, () {
                    Navigator.pushNamed(context, AppRoutes.goalsTargets);
                  }),
                  _buildMenuItem('Body Measurements', Icons.straighten, () {
                    Navigator.pushNamed(context, AppRoutes.bodyMeasurements);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('App Settings', style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedText,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                  _buildMenuItem('Units & Preferences', Icons.settings_outlined, () {
                    Navigator.pushNamed(context, AppRoutes.unitsPreferences);
                  }),
                  _buildMenuItem('Notifications', Icons.notifications_outlined, () {
                    Navigator.pushNamed(context, AppRoutes.notifications);
                  }),
                  _buildMenuItem('Data & Privacy', Icons.lock_outline, () {
                    Navigator.pushNamed(context, AppRoutes.dataPrivacy);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('About', style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedText,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                  _buildMenuItem('App Info', Icons.info_outline, () {
                    Navigator.pushNamed(context, AppRoutes.about);
                  }),
                  _buildMenuItem('Privacy Policy', Icons.privacy_tip_outlined, () {
                    Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _clearAllData,
              icon: const Icon(Icons.delete_outline, color: AppColors.orange500),
              label: Text('Clear All Data', style: TextStyle(color: AppColors.orange500)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.orange500),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (route) => false);
              },
              icon: const Icon(Icons.logout, color: AppColors.red500),
              label: Text('Logout', style: TextStyle(color: AppColors.red500)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.red500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gray700),
      title: Text(title, style: AppTextStyles.body),
      trailing: Icon(Icons.chevron_right, color: AppColors.gray500),
      onTap: onTap,
    );
  }
}
