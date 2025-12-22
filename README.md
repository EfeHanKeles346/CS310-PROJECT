# 🧠 FitMind

A mobile application for personalized fitness and nutrition tracking based on real body measurements with Firebase integration.

---

## 🩺 The Problem

Most fitness and nutrition apps provide one-size-fits-all plans that ignore personal differences such as metabolism, recovery rate, and lifestyle.  
As a result, users struggle to stay consistent and often fail to see real progress.

---

## 💡 Our Solution

**FitMind** creates a truly personalized experience by using real body measurement data (from gyms or dietitians) to build custom workout and meal plans.  
Every 2–4 weeks, the system checks user progress and updates their plan accordingly.  
This allows users to track fitness, nutrition, and body composition in one private, adaptive environment.

---

## ⚙️ Features

- **Measurement-Based Personalization:** Input real measurements (weight, fat %, muscle mass) to generate tailored programs.  
- **Adaptive Progress Updates:** Updates workout and meal plans every few weeks using rule-based logic.  
- **Editable Nutrition Tracker:** Manually add or modify foods and calorie/macro values.  
- **Smart Weekly Planner:** Connect workouts, meals, sleep, and supplements through an easy calendar interface.  
- **Progress Visualization:** View your body transformation over time through simple charts.  
- **Real-time Firebase Sync:** All data syncs in real-time with Cloud Firestore.
- **Secure Authentication:** Firebase Authentication with email/password.

---

## 🧩 Platform & Tech

- Developed with **Flutter** for both iOS and Android.  
- Uses **Firebase** for authentication and real-time data storage:
  - Firebase Authentication (Email/Password)
  - Cloud Firestore (Real-time database)
- **Provider** for state management.
- **SharedPreferences** for local data persistence.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Xcode (for iOS development)
- Android Studio (for Android development)
- Firebase project configured

### Running the App

#### Using the run script (Recommended for iOS):
```bash
cd fitmindproject

# Normal run
./run.sh

# Full cleanup and run (if issues occur)
./run.sh --clean

# Show help
./run.sh --help
```

#### Manual run:
```bash
cd fitmindproject
flutter pub get
flutter run
```

### Hot Reload Shortcuts (while app is running):
- `r` → Hot reload (quick refresh)
- `R` → Hot restart (full restart)
- `q` → Quit application

---

## 📁 Project Structure

```
fitmindproject/
├── lib/
│   ├── main.dart              # App entry point & Firebase init
│   ├── routes.dart            # Navigation routes
│   ├── firebase_options.dart  # Firebase configuration
│   ├── models/                # Data models
│   ├── providers/             # State management (Provider)
│   ├── screens/               # UI screens
│   ├── services/              # Business logic & Firebase services
│   └── utils/                 # Constants, colors, styles
├── firestore.rules            # Firestore security rules
├── firestore.indexes.json     # Firestore composite indexes
├── pubspec.yaml               # Dependencies
└── run.sh                     # iOS run script
```

---

## 🔥 Firebase Integration (Step 3)

### Authentication
- Email/Password sign-up and sign-in
- Secure session management
- User profile data sync

### Firestore Collections
- `users` - User profile data
- `workout_logs` - Workout tracking
- `meal_logs` - Nutrition tracking
- `measurements` - Body measurements

### Security Rules
- Authentication-based access control
- Users can only access their own data
- All CRUD operations are protected

---

## 👥 Team Members

| Name              | Student ID |
| ----------------- | ---------- |
| Alihan Bulut      | 32151      |
| Orkun Kağan Yücel | 31915      |
| Mehmet Ege Aşan   | 34101      |
| Efe Han Keleş     | 31994      |
| Arda Belli        | 34136      |
| Ömer Faruk Orhan  | 31939      |

---

## 📄 License

This project is developed for CS310 coursework.
