import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _workoutReminders = true;
  bool _mealReminders = true;
  bool _measurementReminders = true;
  bool _progressUpdates = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('Reminders', style: AppTextStyles.subtitle),
          const SizedBox(height: 16),
          
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Workout Reminders', style: AppTextStyles.body),
                  subtitle: Text('Get notified about scheduled workouts', style: AppTextStyles.caption),
                  value: _workoutReminders,
                  onChanged: (value) => setState(() => _workoutReminders = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text('Meal Reminders', style: AppTextStyles.body),
                  subtitle: Text('Track your daily nutrition', style: AppTextStyles.caption),
                  value: _mealReminders,
                  onChanged: (value) => setState(() => _mealReminders = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text('Measurement Reminders', style: AppTextStyles.body),
                  subtitle: Text('Regular body measurement check-ins', style: AppTextStyles.caption),
                  value: _measurementReminders,
                  onChanged: (value) => setState(() => _measurementReminders = value),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Text('Updates', style: AppTextStyles.subtitle),
          const SizedBox(height: 16),
          
          Card(
            child: SwitchListTile(
              title: Text('Progress Updates', style: AppTextStyles.body),
              subtitle: Text('Weekly progress summaries', style: AppTextStyles.caption),
              value: _progressUpdates,
              onChanged: (value) => setState(() => _progressUpdates = value),
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
                    'Notifications work offline using local reminders',
                    style: AppTextStyles.caption.copyWith(color: AppColors.blue500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

