import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/user_data_service.dart';

class BodyMeasurementsScreen extends StatefulWidget {
  const BodyMeasurementsScreen({super.key});

  @override
  State<BodyMeasurementsScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<BodyMeasurementsScreen> {
  final UserDataService _userDataService = UserDataService();
  
  @override
  void initState() {
    super.initState();
    // Listen to changes in user data
    _userDataService.addListener(_onUserDataChanged);
  }
  
  @override
  void dispose() {
    _userDataService.removeListener(_onUserDataChanged);
    super.dispose();
  }
  
  void _onUserDataChanged() {
    // Update UI when data changes
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = _userDataService.userData;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Body Measurements'),
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
            Text('Current Measurements', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    _buildMeasurementRow('Weight', '${userData?.weight.toStringAsFixed(1) ?? '--'} kg', Icons.monitor_weight_outlined),
                    const Divider(height: 24),
                    _buildMeasurementRow('Body Fat', userData?.bodyFatPercentage != null ? '${userData!.bodyFatPercentage!.toStringAsFixed(1)}%' : 'Not set', Icons.percent),
                    const Divider(height: 24),
                    _buildMeasurementRow('Muscle Mass', userData?.muscleMass != null ? '${userData!.muscleMass!.toStringAsFixed(1)} kg' : 'Not set', Icons.fitness_center),
                    const Divider(height: 24),
                    _buildMeasurementRow('Height', '${userData?.height.toStringAsFixed(0) ?? '--'} cm', Icons.height),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Measurement History', style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Text('Track your progress over time', style: AppTextStyles.body.copyWith(
              color: AppColors.mutedText,
            )),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.insert_chart_outlined, size: 48, color: AppColors.gray500),
                  const SizedBox(height: 8),
                  Text('Measurement tracking coming soon', 
                    style: AppTextStyles.body.copyWith(color: AppColors.mutedText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text('Add measurements from the home screen', 
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
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
                      'Add new measurements every 2 weeks for best results',
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
  
  Widget _buildMeasurementRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.gray700),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(label, style: AppTextStyles.body),
        ),
        Text(value, style: AppTextStyles.subtitle),
      ],
    );
  }
}

