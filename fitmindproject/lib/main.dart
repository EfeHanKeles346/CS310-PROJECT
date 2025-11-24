import 'package:flutter/material.dart';
import 'routes.dart';
import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';
import 'services/user_data_service.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/get_started/get_started_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_step1_screen.dart';
import 'screens/auth/register_step2_screen.dart';
import 'screens/auth/register_step3_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/planner/planner_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/workouts/workout_list_screen.dart';
import 'screens/workouts/workout_detail_screen.dart';
import 'screens/meals/meals_screen.dart';
import 'screens/meals/add_food_screen.dart';
import 'screens/measurement/add_measurement_screen.dart';
import 'screens/sleep/sleep_screen.dart';
import 'screens/about/about_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/profile/personal_info_screen.dart';
import 'screens/profile/goals_targets_screen.dart';
import 'screens/profile/body_measurements_screen.dart';
import 'screens/profile/units_preferences_screen.dart';
import 'screens/profile/notifications_screen.dart';
import 'screens/profile/data_privacy_screen.dart';
import 'screens/profile/privacy_policy_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load user data on app start
  await UserDataService().refresh();
  runApp(const FitMindApp());
}

class FitMindApp extends StatelessWidget {
  const FitMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Apply custom Poppins font family across entire app (Phase 2.2 requirement)
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.gray100,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.gray900),
          titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.gray900),
        ),
        // Ensure text theme uses Poppins
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Poppins'),
          displayMedium: TextStyle(fontFamily: 'Poppins'),
          displaySmall: TextStyle(fontFamily: 'Poppins'),
          headlineLarge: TextStyle(fontFamily: 'Poppins'),
          headlineMedium: TextStyle(fontFamily: 'Poppins'),
          headlineSmall: TextStyle(fontFamily: 'Poppins'),
          titleLarge: TextStyle(fontFamily: 'Poppins'),
          titleMedium: TextStyle(fontFamily: 'Poppins'),
          titleSmall: TextStyle(fontFamily: 'Poppins'),
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
          bodySmall: TextStyle(fontFamily: 'Poppins'),
          labelLarge: TextStyle(fontFamily: 'Poppins'),
          labelMedium: TextStyle(fontFamily: 'Poppins'),
          labelSmall: TextStyle(fontFamily: 'Poppins'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gray900,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.gray900,
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: AppColors.gray300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.blue500, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.red500),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.gray300),
          ),
          color: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.blue500,
          unselectedItemColor: AppColors.gray500,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.getStarted: (context) => const GetStartedScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register1: (context) => const RegisterStep1Screen(),
        AppRoutes.register2: (context) => const RegisterStep2Screen(),
        AppRoutes.register3: (context) => const RegisterStep3Screen(),
        AppRoutes.mainScaffold: (context) => const MainScaffold(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.planner: (context) => const PlannerScreen(),
        AppRoutes.progress: (context) => const ProgressScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.workoutList: (context) => const WorkoutListScreen(),
        AppRoutes.workoutDetail: (context) => const WorkoutDetailScreen(),
        AppRoutes.meals: (context) => const MealsScreen(),
        AppRoutes.addFood: (context) => const AddFoodScreen(),
        AppRoutes.addMeasurement: (context) => const AddMeasurementScreen(),
        AppRoutes.sleep: (context) => const SleepScreen(),
        AppRoutes.about: (context) => const AboutScreen(),
        AppRoutes.personalInfo: (context) => const PersonalInfoScreen(),
        AppRoutes.goalsTargets: (context) => const GoalsTargetsScreen(),
        AppRoutes.bodyMeasurements: (context) => const BodyMeasurementsScreen(),
        AppRoutes.unitsPreferences: (context) => const UnitsPreferencesScreen(),
        AppRoutes.notifications: (context) => const NotificationsScreen(),
        AppRoutes.dataPrivacy: (context) => const DataPrivacyScreen(),
        AppRoutes.privacyPolicy: (context) => const PrivacyPolicyScreen(),
      },
    );
  }
}
