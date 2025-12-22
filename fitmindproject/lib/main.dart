import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';
import 'services/user_data_service.dart';
import 'providers/auth_provider.dart';
import 'providers/workout_provider.dart';
import 'providers/meal_provider.dart';
import 'providers/preferences_provider.dart';
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

/// Main entry point
/// Step 3: Firebase initialization and Provider setup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Step 3 requirement)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Load user data on app start
  await UserDataService().refresh();
  
  runApp(const FitMindApp());
}

/// Root App Widget
/// Step 3: MultiProvider setup with all providers
class FitMindApp extends StatelessWidget {
  const FitMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Step 3 requirement: Provider setup with MultiProvider
    return MultiProvider(
      providers: [
        // Auth Provider (Step 3 requirement: Auth state management)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Workout Provider (Step 3 requirement: Data state management)
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        
        // Meal Provider (Step 3 requirement: Data state management)
        ChangeNotifierProvider(create: (_) => MealProvider()),
        
        // Preferences Provider (Step 3 requirement: SharedPreferences)
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, prefsProvider, _) {
          return MaterialApp(
            title: 'FitMind',
            debugShowCheckedModeBanner: false,
            // Theme based on user preference (Step 3: SharedPreferences)
            themeMode: prefsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            home: const AuthWrapper(), // Step 3: Authentication-based routing
            routes: _buildRoutes(),
          );
        },
      ),
    );
  }

  /// Build light theme
  ThemeData _buildLightTheme() {
    return ThemeData(
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
      );
  }

  /// Build dark theme
  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.blue500,
      scaffoldBackgroundColor: AppColors.gray900,
      textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'Poppins',
      ),
    );
  }

  /// Build routes map
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      // splash removed - home property already uses AuthWrapper
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
    };
  }
}

/// Authentication Wrapper
/// Step 3 requirement: Authentication-based access control
/// Logged-out users → Login/Register screen
/// Logged-in users → Main app screens
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? _lastUserId;

  @override
  Widget build(BuildContext context) {
    // Step 3: Listen to authentication state changes
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Step 3: Authentication-based routing
        if (authProvider.isAuthenticated) {
          // User is logged in → show main app
          final user = authProvider.user;
          if (user != null && _lastUserId != user.uid) {
            // Initialize data providers with user ID only once per login
            _lastUserId = user.uid;
            
            // Use addPostFrameCallback to avoid calling notifyListeners during build
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (mounted) {
                // Step 3: Sync Firebase data to local storage on login
                await UserDataService().loadFromFirebase();
                debugPrint('AuthWrapper: Firebase data synced to local');
                
                final workoutProvider =
                    Provider.of<WorkoutProvider>(context, listen: false);
                final mealProvider =
                    Provider.of<MealProvider>(context, listen: false);

                // Listen to real-time Firestore updates
                workoutProvider.listenToWorkouts(user.uid);
                mealProvider.listenToMeals(user.uid);
              }
            });
          }

          return const MainScaffold();
        } else {
          // User is not logged in → show get started / login screen
          _lastUserId = null; // Reset when logged out
          return const GetStartedScreen();
        }
      },
    );
  }
}
