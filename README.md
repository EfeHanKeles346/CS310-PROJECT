# 🧠 FitMind

A mobile application for personalized, offline fitness and nutrition tracking based on real body measurements.

---

## 🩺 The Problem

Most fitness and nutrition apps provide one-size-fits-all plans that ignore personal differences such as metabolism, recovery rate, and lifestyle.  
As a result, users struggle to stay consistent and often fail to see real progress.

---

## 💡 Our Solution

**FitMind** creates a truly personalized experience by using real body measurement data (from gyms or dietitians) to build custom workout and meal plans.  
Every 2–4 weeks, the system checks user progress and updates their plan accordingly — all without requiring an internet connection.  
This allows users to track fitness, nutrition, and body composition in one private, adaptive environment.

---

## ⚙️ Features

- **Measurement-Based Personalization:** Input real measurements (weight, fat %, muscle mass) to generate tailored programs.  
- **Adaptive Progress Updates:** Updates workout and meal plans every few weeks using rule-based logic.  
- **Editable Nutrition Tracker:** Manually add or modify foods and calorie/macro values.  
- **Smart Weekly Planner:** Connect workouts, meals, sleep, and supplements through an easy calendar interface.  
- **Progress Visualization:** View your body transformation over time through simple charts.  
- **Offline Functionality:** Works completely offline using local storage (SQLite).

---

## 🧩 Platform & Tech

- Developed with **Flutter** for both iOS and Android.  
- Uses **SQLite** for secure local data storage.  
- Follows Flutter’s recommended `.gitignore` template for clean version control.  

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

## 🚀 Setup & Installation

### Prerequisites

- **Flutter SDK:** Version 3.0.0 or higher
- **Dart SDK:** Included with Flutter
- **Android Studio** or **Xcode** (for iOS development)

### Step-by-Step Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd "cs310 phase 4/fitmindproject"
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration:**
   - Firebase is pre-configured in `lib/firebase_options.dart`
   - Android config: `android/app/google-services.json`
   - iOS config: `ios/Runner/GoogleService-Info.plist`

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing

### Running Tests

```bash
cd fitmindproject
flutter test
```

### Test Descriptions

| Test File | Type | Description |
|-----------|------|-------------|
| `test/calculation_service_test.dart` | Unit Test | Tests CalculationService: BMR calculation, TDEE calculation, macro calculations, progress tracking, and workout recommendations |
| `test/login_screen_test.dart` | Widget Test | Tests LoginScreen: UI rendering, form validation, password visibility toggle, and user interactions |

---


