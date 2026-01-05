import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../services/user_data_service.dart';
import '../../services/firestore_service.dart';
import '../../models/measurement_model.dart';
import '../../providers/auth_provider.dart';
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
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.uid;
    
    if (userData == null || userId == null) {
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
    
    // Step 3 Requirement: StreamBuilder for real-time Firestore data with loading/error states
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
      body: StreamBuilder<List<MeasurementModel>>(
        stream: FirestoreService().getMeasurements(userId),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.blue500),
                  const SizedBox(height: 16),
                  Text('Loading measurements...', style: AppTextStyles.body),
                ],
              ),
            );
          }
          
          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.red500),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading measurements',
                    style: AppTextStyles.subtitle.copyWith(color: AppColors.red500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {}); // Trigger rebuild to retry
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          // Success state
          final measurements = snapshot.data ?? [];
          final latestMeasurement = measurements.isNotEmpty ? measurements.first : null;
          
          return SingleChildScrollView(
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
                                  Text(
                                    latestMeasurement != null 
                                      ? '${latestMeasurement.weight.toStringAsFixed(1)} kg'
                                      : '${userData.weight.toStringAsFixed(1)} kg', 
                                    style: AppTextStyles.subtitle
                                  ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Body Composition', style: AppTextStyles.subtitle),
                            Text(
                              '${measurements.length} measurement${measurements.length != 1 ? 's' : ''}',
                              style: AppTextStyles.caption.copyWith(color: AppColors.blue500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (latestMeasurement != null && latestMeasurement.bodyFat != null)
                          _buildMetricRow(
                            'Body Fat', 
                            '${latestMeasurement.bodyFat!.toStringAsFixed(1)}%', 
                            'Latest', 
                            true,
                          ),
                        if (latestMeasurement != null && latestMeasurement.bodyFat != null)
                          const SizedBox(height: 12),
                        if (latestMeasurement != null && latestMeasurement.muscleMass != null)
                          _buildMetricRow(
                            'Muscle Mass', 
                            '${latestMeasurement.muscleMass!.toStringAsFixed(1)} kg', 
                            'Latest', 
                            true,
                          ),
                        if (measurements.isEmpty || 
                            (latestMeasurement?.bodyFat == null && latestMeasurement?.muscleMass == null))
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              measurements.isEmpty 
                                ? 'No measurements recorded yet. Add your first measurement!'
                                : 'No body composition data available',
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
                
                // Step 3: Measurement History with DELETE functionality
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Measurement History', style: AppTextStyles.subtitle),
                            if (measurements.isNotEmpty)
                              Text(
                                'Swipe left to delete',
                                style: AppTextStyles.caption.copyWith(color: AppColors.mutedText),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (measurements.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'No measurements yet',
                                style: AppTextStyles.body.copyWith(color: AppColors.mutedText),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: measurements.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final measurement = measurements[index];
                              return _buildMeasurementItem(measurement);
                            },
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
          );
        },
      ),
    );
  }

  /// Step 3: DELETE operation - Delete measurement from Firestore
  Future<void> _deleteMeasurement(MeasurementModel measurement) async {
    try {
      await FirestoreService().deleteMeasurement(measurement.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Measurement deleted'),
            backgroundColor: AppColors.green500,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () async {
                // Restore the measurement
                await FirestoreService().addMeasurement(measurement);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: AppColors.red500,
          ),
        );
      }
    }
  }

  /// Build individual measurement item with swipe to delete
  Widget _buildMeasurementItem(MeasurementModel measurement) {
    final dateStr = DateFormat('MMM dd, yyyy').format(measurement.createdAt);
    final timeStr = DateFormat('HH:mm').format(measurement.createdAt);
    
    return Dismissible(
      key: Key(measurement.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.red500,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Measurement'),
            content: Text('Delete measurement from $dateStr?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppColors.red500),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) => _deleteMeasurement(measurement),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.blue100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.monitor_weight_outlined, color: AppColors.blue500),
        ),
        title: Text(
          '${measurement.weight.toStringAsFixed(1)} kg',
          style: AppTextStyles.subtitle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$dateStr at $timeStr', style: AppTextStyles.caption),
            if (measurement.bodyFat != null || measurement.muscleMass != null)
              Text(
                [
                  if (measurement.bodyFat != null) 'BF: ${measurement.bodyFat!.toStringAsFixed(1)}%',
                  if (measurement.muscleMass != null) 'MM: ${measurement.muscleMass!.toStringAsFixed(1)}kg',
                ].join(' • '),
                style: AppTextStyles.caption.copyWith(color: AppColors.blue500),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: AppColors.red500, size: 20),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Measurement'),
                content: Text('Delete measurement from $dateStr?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(foregroundColor: AppColors.red500),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              _deleteMeasurement(measurement);
            }
          },
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
