import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';

class UnitsPreferencesScreen extends StatefulWidget {
  const UnitsPreferencesScreen({super.key});

  @override
  State<UnitsPreferencesScreen> createState() => _UnitsPreferencesScreenState();
}

class _UnitsPreferencesScreenState extends State<UnitsPreferencesScreen> {
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _distanceUnit = 'km';
  bool _darkMode = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Units & Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('Units', style: AppTextStyles.subtitle),
          const SizedBox(height: 16),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Weight', style: AppTextStyles.body),
                  trailing: DropdownButton<String>(
                    value: _weightUnit,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'kg', child: Text('kg')),
                      DropdownMenuItem(value: 'lbs', child: Text('lbs')),
                    ],
                    onChanged: (value) => setState(() => _weightUnit = value!),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text('Height', style: AppTextStyles.body),
                  trailing: DropdownButton<String>(
                    value: _heightUnit,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'cm', child: Text('cm')),
                      DropdownMenuItem(value: 'ft/in', child: Text('ft/in')),
                    ],
                    onChanged: (value) => setState(() => _heightUnit = value!),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text('Distance', style: AppTextStyles.body),
                  trailing: DropdownButton<String>(
                    value: _distanceUnit,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'km', child: Text('km')),
                      DropdownMenuItem(value: 'miles', child: Text('miles')),
                    ],
                    onChanged: (value) => setState(() => _distanceUnit = value!),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Text('Appearance', style: AppTextStyles.subtitle),
          const SizedBox(height: 16),
          
          Card(
            child: SwitchListTile(
              title: Text('Dark Mode', style: AppTextStyles.body),
              subtitle: Text('Enable dark theme', style: AppTextStyles.caption),
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
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
                    'Preferences will be saved automatically',
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

