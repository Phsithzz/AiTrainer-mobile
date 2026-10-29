# AI Form Trainer - Mobile App (Flutter)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20BLoC-blueviolet)](https://bloclibrary.dev)
[![Backend](https://img.shields.io/badge/Backend-FastAPI%20%2B%20MediaPipe-009688?logo=fastapi)](https://fastapi.tiangolo.com)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success)](#)

A modern, high-performance cross-platform mobile application for real-time exercise form correction and fitness tracking powered by AI (Computer Vision + MediaPipe Pose Tracker) and FastAPI.

---

## 🌟 Key Features

- **🏋️‍♂️ AI Live Form Trainer**:
  - Real-time pose feedback via WebSocket streaming (`/exercise/squat`, `/exercise/pushup`, `/exercise/plank`).
  - Automatic rep counting with strict stage detection (`down`, `up`, `hold`).
  - Instant form flaw detection with highlighted correction cues (e.g. "ส้นเท้าลอย", "หลังโค้งงอ", "สะโพกตก").
  - Built-in Mock Simulator for offline testing without requiring a live backend.
- **📊 Performance Dashboard**:
  - Overall accuracy gauge with dynamic health color indicators.
  - Exercise breakdown cards (Squat, Push-up, Plank) with accuracy and rep volume.
  - Common weaknesses ranking identifying the user's top form errors.
  - Global comparison benchmarking user form against community averages.
- **📜 Workout History**:
  - Full workout log with exercise badges, timestamps, and accuracy rates.
  - Granular form flaw breakdown per workout session.
  - Filter by exercise type (All, Squat, Push-up, Plank).
- **🔐 Secure Authentication**:
  - Email/Password registration & login.
  - 6-digit OTP email verification flow.
  - Persistent JWT session storage via `SharedPreferences`.
- **⚙️ Settings & Customization**:
  - Configurable Backend Host URL with local emulator/device switcher.
  - Mock Mode toggle.
  - Voice cues & haptic feedback preferences.

---

## 📐 Architecture & Design Pattern

The application strictly adheres to **Clean Architecture** combined with the **BLoC (Business Logic Component)** pattern for predictable state management, testability, and separation of concerns.

```text
lib/
├── core/                         # Shared core utilities and infrastructure
│   ├── constants/                # Colors, API endpoints, assets
│   ├── di/                       # GetIt dependency injection container
│   ├── errors/                   # Failure and Exception abstractions
│   ├── network/                  # Dio HTTP & WebSocket client with mock interceptor
│   ├── theme/                    # Material 3 athletic dark theme & typography
│   ├── utils/                    # Formatters (Thai localization, time, error codes)
│   └── widgets/                  # Reusable UI components (AppCard, etc.)
│
├── features/
│   ├── auth/                     # Authentication & OTP verification
│   │   ├── domain/               # User entities, AuthRepository interface, UseCases
│   │   ├── data/                 # UserModel, AuthRemoteDataSource, AuthRepositoryImpl
│   │   └── presentation/         # AuthBloc, LoginPage, RegisterPage, VerifyOtpPage
│   │
│   ├── exercise/                 # AI Form Workout & Exercise Selection
│   │   ├── domain/               # Workout entities, ExerciseRepository, UseCases
│   │   ├── data/                 # WorkoutModel, ExerciseRemoteDataSource, ExerciseRepositoryImpl
│   │   └── presentation/         # WorkoutBloc, SelectExercisePage, TrainPage
│   │
│   ├── dashboard/                # Workout Statistics & Global Comparison
│   │   ├── domain/               # DashboardStats entity, Repository, UseCases
│   │   ├── data/                 # DashboardStatsModel, DataSource, RepositoryImpl
│   │   └── presentation/         # DashboardBloc, DashboardPage
│   │
│   ├── history/                  # Completed Workouts Log
│   │   └── presentation/         # HistoryBloc, HistoryPage
│   │
│   ├── settings/                 # User Profile & App Settings
│   │   └── presentation/         # SettingsPage
│   │
│   └── navigation/               # Root Bottom Navigation Shell
│       └── presentation/         # MainNavigationPage
│
└── main.dart                     # App bootstrap with MultiBlocProvider & AuthGate
```

---

## 🤸 Supported Exercises & Detected Flaws

| Exercise | AI Stage Tracking | Detected Form Errors |
|---|---|---|
| **Squat (สควอท)** | Up ➔ Down ➔ Up | `squat_bad_heel` (ส้นเท้าลอย)<br>`squat_bad_back` (หลังโค้งงอ) |
| **Push-up (วิดพื้น)** | Up ➔ Down ➔ Up | `pushup_bad_hips` (สะโพกตก/โก่ง)<br>`pushup_bad_knees` (เข่างอ)<br>`pushup_bad_neck` (ก้มหรือเงยเกินไป) |
| **Plank (แพลงก์)** | Ready ➔ Holding | `plank_bad_hips` (สะโพกตกหรือโก่ง)<br>`plank_bad_knees` (เข่างอ)<br>`plank_bad_neck` (ศีรษะไม่ตรง) |

---

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.22+ (tested on Flutter 3.44)
- Dart SDK 3.4+
- Android Studio / VS Code with Flutter extension
- (Optional) Running FastAPI AI backend at port 8000

### Installation
```bash
# Clone the repository
git clone https://github.com/Phsithzz/AiTrainer-mobile.git
cd AiTrainer-mobile

# Install dependencies
flutter pub get

# Run unit tests
flutter test

# Run the app
flutter run
```

---

## 🧪 Unit Tests

Run test suite:
```bash
flutter test
```
Includes:
- Thai string and error code localization tests (`formatters_test.dart`)
- JSON serialization/deserialization for models (`models_test.dart`)
- Application theme configuration tests (`widget_test.dart`)

---

## 👨‍💻 Tech Stack

- **Framework**: Flutter / Dart
- **State Management**: `flutter_bloc`
- **Dependency Injection**: `get_it`
- **Functional Programming**: `dartz` (Either / Failure)
- **Networking**: `dio`, `web_socket_channel`
- **Charts & Visualization**: `fl_chart`
- **Storage**: `shared_preferences`
- **Fonts**: `google_fonts` (Outfit font family)
