import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../routes.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  String _selectedRange = 'Week';
  
  // Sample sleep data
  final Map<String, double> _sleepData = {
    'Monday': 7.5,
    'Tuesday': 8.0,
    'Wednesday': 7.0,
    'Thursday': 7.5,
    'Friday': 6.5,
    'Saturday': 9.0,
    'Sunday': 8.5,
  };
  
  double get _averageSleep => _sleepData.values.reduce((a, b) => a + b) / _sleepData.length;
  double get _targetSleep => 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.bedtime, size: 24, color: AppColors.gray900),
            const SizedBox(width: 8),
            const Text('Sleep'),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            // Sleep Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sleep Overview', style: AppTextStyles.subtitle),
                        DropdownButton<String>(
                          value: _selectedRange,
                          items: ['Week', 'Month', 'Year'].map((range) {
                            return DropdownMenuItem(
                              value: range,
                              child: Text(range),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedRange = value);
                            }
                          },
                          underline: Container(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spacing24),
                    // Average sleep hours
                    Text(
                      '${_averageSleep.toStringAsFixed(1)}h',
                      style: AppTextStyles.largeTitle.copyWith(
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Text(
                      'Average sleep this ${_selectedRange.toLowerCase()}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacing24),
                    // Target vs Actual
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSleepStat('Target', '${_targetSleep.toStringAsFixed(1)}h', AppColors.blue500),
                        _buildSleepStat('Average', '${_averageSleep.toStringAsFixed(1)}h', 
                          _averageSleep >= _targetSleep ? AppColors.green500 : AppColors.orange500),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            
            // Weekly Sleep Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This Week', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppSpacing.spacing16),
                    ..._sleepData.entries.map((entry) {
                      return _buildSleepBar(entry.key, entry.value);
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            
            // Add Sleep Entry Button
            Card(
              child: ListTile(
                leading: Icon(Icons.add_circle_outline, color: AppColors.blue500),
                title: Text('Add Sleep Entry', style: AppTextStyles.subtitle),
                subtitle: Text('Record your sleep hours', style: AppTextStyles.body),
                trailing: Icon(Icons.chevron_right, color: AppColors.gray500),
                onTap: () {
                  _showAddSleepDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.subtitle.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildSleepBar(String day, double hours) {
    final percentage = hours / 10.0; // Max 10 hours for visualization
    final isGood = hours >= 7 && hours <= 9;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day, style: AppTextStyles.body),
              Text(
                '${hours.toStringAsFixed(1)}h',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isGood ? AppColors.green500 : AppColors.orange500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.gray300,
              valueColor: AlwaysStoppedAnimation<Color>(
                isGood ? AppColors.green500 : AppColors.orange500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSleepDialog(BuildContext context) {
    final sleepController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Sleep Entry', style: AppTextStyles.subtitle),
        content: TextField(
          controller: sleepController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Sleep hours',
            hintText: 'e.g. 8.5',
            suffixText: 'hours',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.gray700)),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save sleep entry
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sleep entry added'),
                  backgroundColor: AppColors.green500,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

