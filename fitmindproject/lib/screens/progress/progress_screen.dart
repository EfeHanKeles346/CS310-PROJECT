import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/user_data_service.dart';
import '../../routes.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedRange = '30D';
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _userDataService.addListener(_onUserDataChanged);
  }

  @override
  void dispose() {
    _userDataService.removeListener(_onUserDataChanged);
    super.dispose();
  }

  void _onUserDataChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userData = _userDataService.userData;
    
    if (userData == null) {
      return Scaffold(
        backgroundColor: AppColors.gray100,
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.show_chart, size: 24),
              const SizedBox(width: 8),
              const Text('Progress'),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text(
            'Please complete registration to see your progress',
            style: AppTextStyles.body,
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.show_chart, size: 24),
            const SizedBox(width: 8),
            const Text('Progress'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['7D', '30D', '90D', 'All'].map((range) {
                final isSelected = _selectedRange == range;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(range),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedRange = range);
                    },
                    selectedColor: AppColors.gray900,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight Trend', style: AppTextStyles.subtitle),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(Icons.show_chart, size: 48, color: AppColors.blue500),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current', style: AppTextStyles.caption),
                              Text('${userData.weight.toStringAsFixed(1)} kg', style: AppTextStyles.subtitle),
                            ],
                          ),
                        ),
                        if (userData.targetWeight != null)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Target', style: AppTextStyles.caption),
                                Text('${userData.targetWeight!.toStringAsFixed(1)} kg', 
                                  style: AppTextStyles.subtitle.copyWith(
                                    color: AppColors.blue500,
                                  )),
                              ],
                            ),
                          ),
                      ],
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
                    Text('Body Composition', style: AppTextStyles.subtitle),
                    const SizedBox(height: 16),
                    if (userData.bodyFatPercentage != null)
                      _buildMetricRow(
                        'Body Fat', 
                        '${userData.bodyFatPercentage!.toStringAsFixed(1)}%', 
                        'Current', 
                        true,
                      ),
                    if (userData.bodyFatPercentage != null)
                      const SizedBox(height: 12),
                    if (userData.muscleMass != null)
                      _buildMetricRow(
                        'Muscle Mass', 
                        '${userData.muscleMass!.toStringAsFixed(1)} kg', 
                        'Current', 
                        true,
                      ),
                    if (userData.bodyFatPercentage == null && userData.muscleMass == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No body composition data available',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            // Add Measurement Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addMeasurement);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Measurement'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gray900,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, String change, bool isPositive) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Text(value, style: AppTextStyles.subtitle),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: (isPositive ? AppColors.green500 : AppColors.red500).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(change,
            style: AppTextStyles.caption.copyWith(
              color: isPositive ? AppColors.green500 : AppColors.red500,
            ),
          ),
        ),
      ],
    );
  }
}
