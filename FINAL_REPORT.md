# CS310 - Mobile Application Development
# Final Project Report

**Project Name:** FitMind  
**Course:** CS310 - Mobile Application Development  
**Submission Date:** 5 January 2026  



## Team Members

| Name | Student ID |
|------|------------|
| Alihan Bulut | 32151 |
| Orkun Kağan Yücel | 31915 |
| Mehmet Ege Aşan | 34101 |
| Efe Han Keleş | 31994 |
| Arda Belli | 34136 |
| Ömer Faruk Orhan | 31939 |



## 1. App Overview

**FitMind** is a comprehensive mobile fitness and nutrition tracking application developed using Flutter. The app provides a personalized experience by using real body measurement data to create custom workout and meal plans tailored to each user's specific needs and goals.

### Motivation

Most fitness and nutrition apps provide one-size-fits-all plans that ignore personal differences such as metabolism, recovery rate, and lifestyle. Users often struggle to stay consistent and fail to see real progress because the recommendations are not personalized to their individual body composition and goals.

FitMind solves this problem by:
- Using real body measurements (weight, body fat %, muscle mass) to generate personalized programs
- Calculating accurate BMR, TDEE, and macro targets based on scientific formulas
- Adapting workout and meal plans based on user's experience level and goals
- Providing progress tracking with visual charts



## 2. Main Features

### Authentication Features
- **User Registration:** Multi-step registration with personal information, fitness goals, and body measurements
- **User Login:** Secure email/password authentication
- **User Logout:** Clean session termination with data sync
- **Password Reset:** Email-based password recovery

### Core Features
- **Measurement-Based Personalization:** Input real measurements (weight, fat %, muscle mass) to generate tailored programs
- **BMR/TDEE Calculator:** Calculates Basal Metabolic Rate and Total Daily Energy Expenditure using Mifflin-St Jeor equation
- **Macro Calculator:** Calculates protein, carbohydrate, and fat targets based on user's weight and goals
- **Workout Tracking:** Log workouts with exercise details, sets, reps, and duration
- **Meal Tracking:** Track daily meals with calorie and macro calculations
- **Progress Tracking:** Monitor weight changes and body composition over time
- **Smart Weekly Planner:** Calendar-based planning for workouts, meals, and sleep
- **Progress Visualization:** Charts showing body transformation progress

### User Experience Features
- **Dark/Light Mode:** Theme switching based on user preference
- **Responsive Design:** Adapts to different screen sizes (phone/tablet)
- **Real-time Sync:** Data synchronized across devices using Cloud Firestore
- **Offline Support:** Core functionality works without internet connection



## 3. Firebase Usage

### Firebase Authentication
- **Sign Up:** `createUserWithEmailAndPassword()` for new user registration
- **Sign In:** `signInWithEmailAndPassword()` for user login
- **Sign Out:** `signOut()` for secure logout
- **Auth State:** `authStateChanges()` stream for reactive authentication state management
- **Error Handling:** User-friendly error messages for all authentication errors (weak password, email in use, invalid credentials, etc.)

### Cloud Firestore Database

**Collections Structure:**

| Collection | Purpose | Fields |
|------------|---------|--------|
| `users` | User profiles | uid, email, displayName, age, gender, height, weight, fitnessGoal, activityLevel, createdAt |
| `workout_logs` | Workout history | id, createdBy, workoutName, exercises, duration, caloriesBurned, createdAt |
| `meal_logs` | Meal entries | id, createdBy, mealType, foods, totalCalories, protein, carbs, fats, createdAt |
| `measurements` | Body measurements | id, createdBy, weight, bodyFat, muscleMass, createdAt |

**CRUD Operations:**
- **Create:** `set()` method for adding new documents
- **Read:** `snapshots()` for real-time data streams, `get()` for one-time reads
- **Update:** `update()` method for modifying existing documents
- **Delete:** `delete()` method for removing documents

**Real-time Updates:**
- Used Firestore `snapshots()` to listen for real-time changes
- Implemented in WorkoutProvider and MealProvider for instant UI updates



## 4. State Management Approach

### Provider Pattern

We used the **Provider** package for state management throughout the application.

**Providers Implemented:**

| Provider | Purpose |
|----------|---------|
| `AuthProvider` | Manages authentication state, user session, login/logout operations |
| `WorkoutProvider` | Manages workout logs, syncs with Firestore, handles CRUD operations |
| `MealProvider` | Manages meal logs, calculates daily totals, syncs with Firestore |
| `PreferencesProvider` | Manages user preferences (dark mode, units), uses SharedPreferences |

**Implementation Details:**

```dart
// MultiProvider setup in main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => WorkoutProvider()),
    ChangeNotifierProvider(create: (_) => MealProvider()),
    ChangeNotifierProvider(create: (_) => PreferencesProvider()),
  ],
  child: MaterialApp(...),
)
```

**Why Provider?**
- Simple and easy to understand
- Built-in Flutter integration
- Efficient rebuilds with Consumer/Selector widgets
- Good separation of concerns between UI and business logic



## 5. Individual Contributions

> **Important Note:** Throughout all phases of this project, our team worked collaboratively with equal participation from every member. We held regular meetings where we developed features together, reviewed each other's code, and made decisions as a group. While responsibilities were distributed for organizational purposes, the actual development was a joint effort where everyone contributed equally to all aspects of the project including UI implementation, Firebase integration, state management, testing, and documentation.

Even though the development was collaborative, responsibilities were distributed as follows:



### Efe Han Keleş (31994)

**UI Implementation:**
- Implemented SplashScreen, GetStartedScreen, MainScaffold, and AboutScreen
- Integrated named routes, global theme system, and custom Poppins font family
- Set up app-wide styling with AppColors, AppTextStyles, AppSpacing utilities

**Backend & State Management:**
- Developed UserDataService for local data persistence
- Implemented PreferencesService and PreferencesProvider for user settings (dark mode, units)
- Configured SharedPreferences integration for offline preference storage



### Mehmet Ege Aşan (34101)

**UI Implementation:**
- Developed the complete authentication flow including LoginScreen and RegisterStep1-3
- Implemented advanced form validation with real-time feedback
- Created seamless navigation between registration steps

**Backend & State Management:**
- Developed AuthService with Firebase Authentication integration (sign-up, login, logout, password reset)
- Implemented AuthProvider for reactive authentication state management
- Created UserModel with Firestore serialization/deserialization



### Orkun Kağan Yücel (31915)

**UI Implementation:**
- Created HomeScreen dashboard with daily summary cards
- Developed PlannerScreen layout with calendar integration
- Implemented ProgressScreen with progress visualization
- Built BodyMeasurementsScreen for tracking body composition

**Backend & State Management:**
- Developed MeasurementModel for body measurement data
- Implemented CalculationService with BMR, TDEE, and macro calculations using Mifflin-St Jeor equation
- Created progress tracking algorithms for weight loss/gain goals



### Ömer Faruk Orhan (31939)

**UI Implementation:**
- Implemented MealsScreen with daily meal overview
- Developed AddFoodScreen with food search and nutritional information
- Created AddMeasurementScreen with measurement input forms
- Built SleepScreen with sleep tracking charts and dialogs

**Backend & State Management:**
- Developed MealLogModel and FoodModel for nutrition data
- Implemented MealProvider with Firestore real-time sync
- Created MealTrackingService and FoodDatabaseService for meal management



### Alihan Bulut (32151)

**UI Implementation:**
- Developed WorkoutListScreen with swipe-to-delete functionality
- Created WorkoutDetailScreen with exercise details and logging
- Implemented GoalsTargetsScreen for fitness goal configuration
- Built UnitsPreferencesScreen for measurement unit settings

**Backend & State Management:**
- Developed WorkoutLogModel, WorkoutModel, and ExerciseModel
- Implemented WorkoutProvider with Firestore real-time sync
- Created WorkoutLogService and WorkoutProgramService for workout management
- Developed WorkoutProgramGenerator for personalized program recommendations



### Arda Belli (34136)

**UI Implementation:**
- Created ProfileScreen with user information display
- Developed all settings-related screens: NotificationsScreen, DataPrivacyScreen, PrivacyPolicyScreen
- Organized profile navigation structure and settings menu
- Implemented PersonalInfoScreen for profile editing

**Backend & State Management:**
- Developed FirestoreService with complete CRUD operations for all collections
- Created comprehensive unit tests for CalculationService (21 tests)
- Implemented widget tests for LoginScreen (8 tests)
- Prepared README documentation with setup instructions and test descriptions



## 6. Lessons Learned

### Technical Lessons

1. **Flutter & Dart:**
   - Learned widget composition and the difference between StatelessWidget and StatefulWidget
   - Understanding of BuildContext and widget tree structure
   - Proper use of async/await for asynchronous operations

2. **Firebase Integration:**
   - Setting up Firebase for both iOS and Android platforms
   - Understanding Firestore data modeling and document structure
   - Implementing real-time data synchronization
   - Handling authentication states and secure user sessions

3. **State Management:**
   - Importance of separating business logic from UI
   - Using Provider pattern for reactive state updates
   - Managing complex state across multiple screens

4. **Testing:**
   - Writing meaningful unit tests for business logic
   - Creating widget tests for UI components
   - Importance of test-driven development

### Teamwork Lessons

1. **Git Collaboration:**
   - Using branches for feature development
   - Resolving merge conflicts
   - Writing meaningful commit messages

2. **Communication:**
   - Regular team meetings and progress updates
   - Clear task assignment and tracking
   - Code review practices

3. **Project Planning:**
   - Breaking down large features into smaller tasks
   - Setting realistic deadlines
   - Adapting to changing requirements



## 7. Challenges Faced and Solutions

### Challenge 1: Firebase Configuration for iOS
**Problem:** Initial Firebase setup caused build errors on iOS with Xcode 16.2.

**Solution:** Updated Firebase packages to latest compatible versions and properly configured `GoogleService-Info.plist`. Added necessary configurations in `Podfile` for iOS deployment target.



### Challenge 2: Real-time Data Sync
**Problem:** Complex Firestore queries required composite indexes which caused errors during development.

**Solution:** Implemented client-side sorting and filtering to avoid complex index requirements. This approach simplified development while maintaining functionality.



### Challenge 3: State Management Complexity
**Problem:** Managing authentication state across the entire app while ensuring data is loaded correctly for each user.

**Solution:** Created an `AuthWrapper` widget that listens to authentication changes and conditionally renders screens. Used `addPostFrameCallback` to avoid calling `notifyListeners` during build phase.



### Challenge 4: Form Validation
**Problem:** Ensuring proper validation for multi-step registration forms while providing good user experience.

**Solution:** Used Flutter's built-in `Form` and `TextFormField` validation with custom validators. Implemented step-by-step validation to give immediate feedback to users.



### Challenge 5: Testing Firebase-Dependent Code
**Problem:** Widget tests failed because they couldn't initialize Firebase in test environment.

**Solution:** Created mock providers that don't depend on Firebase for widget tests. Separated business logic into testable services like `CalculationService` for comprehensive unit testing.



## 8. Project Video

**Video Link:** https://drive.google.com/file/d/1tB1iom-CQgMzAPN0CuLijuaCKlHB0AiU/view?usp=sharing



The video demonstrates:
- User registration and login flow
- Adding body measurements
- Viewing personalized macro and calorie targets
- Logging workouts and meals
- Viewing progress charts
- Settings and preferences
- Logout functionality



## 9. Repository Information

**GitHub Repository:** https://github.com/EfeHanKeles346/CS310-PROJECT

**Project Structure:**
```
fitmindproject/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   ├── routes.dart
│   ├── models/
│   ├── providers/
│   ├── services/
│   ├── screens/
│   └── utils/
├── test/
│   ├── calculation_service_test.dart (Unit Tests)
│   └── login_screen_test.dart (Widget Tests)
├── assets/
└── pubspec.yaml
```



## 10. Conclusion

FitMind successfully demonstrates the implementation of a full-stack mobile application using Flutter and Firebase. The project integrates user authentication, real-time database operations, and state management to create a functional fitness tracking application.

Key achievements:
- ✅ Complete Firebase integration (Auth + Firestore)
- ✅ Provider-based state management
- ✅ Responsive UI design
- ✅ Comprehensive testing (29 tests passing)
- ✅ Clean code architecture with separation of concerns

The project provided valuable hands-on experience in mobile app development and team collaboration, preparing us for real-world software development challenges.





