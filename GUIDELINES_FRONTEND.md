# 📱 Frontend Developer Guide — Prasamsha

Welcome to the project! This guide is everything you need to set up Flutter,
understand the app structure, and build the Lemon Leaf Disease Detection mobile app.

---

## 🎯 Your Responsibility

You are responsible for building the **Flutter mobile application** that farmers
and users will use to scan lemon leaves. The app communicates with Ganga's Django
backend to get disease predictions and treatment advice.

**Your deliverable:**
A working Android + iOS app with:
- 📸 Camera scan feature
- 🖼️ Gallery upload feature
- 🔬 Disease result screen with treatment steps
- 🇳🇵 Nepali + English language support

---

## 📁 Your Working Folder

```
frontend/                         ← YOUR MAIN FOLDER
├── lib/
│   ├── main.dart                 ← App entry point
│   ├── screens/
│   │   ├── home_screen.dart      ← Main screen with Scan + Upload buttons
│   │   ├── result_screen.dart    ← Shows disease result + treatment
│   │   └── history_screen.dart   ← Past predictions list
│   ├── services/
│   │   └── api_service.dart      ← All HTTP calls to Django backend
│   ├── models/
│   │   └── prediction_model.dart ← Data classes (PredictionResult, TreatmentData)
│   ├── widgets/
│   │   ├── severity_badge.dart   ← Red/Orange/Green badge for disease severity
│   │   ├── treatment_card.dart   ← Card showing treatment steps
│   │   └── language_toggle.dart  ← EN / NP toggle button
│   └── utils/
│       ├── language_provider.dart ← Manages EN/NP language switching
│       └── constants.dart         ← Colors, text styles, app constants
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml   ← Camera + Internet permissions
├── ios/
│   └── Runner/
│       └── Info.plist            ← iOS camera permissions
└── pubspec.yaml                  ← Flutter dependencies
```

**Files you should NOT change:**
- `predictor/` — Ganga's backend
- `ml/` — Bhawna's ML code
- `bakend/` — Django settings
- `config.yaml` — project config

---

## ⚙️ Setup — Do This First

### 1. Clone the Repository
```bash
git clone https://github.com/gangaadhikari123/Lemon_Leaf_Disease_Detection.git
cd Lemon_Leaf_Disease_Detection
```

### 2. Verify Flutter is Installed
```bash
flutter --version
# Should show: Flutter 3.x.x
```

If Flutter is not found:
```bash
# Add Flutter to PATH
echo 'export PATH="$PATH:/home/YOUR_USERNAME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
flutter --version
```

### 3. Run Flutter Doctor
```bash
flutter doctor
```

Fix any issues marked with ✗. The important ones are:
- ✓ Flutter
- ✓ Android toolchain
- ✓ Connected device

### 4. Go to Frontend Folder
```bash
cd frontend
```

### 5. Install Flutter Packages
```bash
flutter pub get
```

Expected output: `Got dependencies!`

### 6. Run the App
```bash
flutter devices          # see available devices
flutter run              # run on first available device
```

---

## 📱 App Screens — What You Need to Build

### Screen 1 — Home Screen (`home_screen.dart`) ✓ Already created

```
┌─────────────────────────────┐
│  🍋 Lemon Disease Detector  │  [EN/NP toggle]
├─────────────────────────────┤
│                             │
│         🌿 (logo)           │
│                             │
│   Detect Lemon Leaf Disease │
│   कागती पातको रोग पहिचान   │
│                             │
│  ┌──────────────────────┐   │
│  │  📷 Scan with Camera  │   │
│  └──────────────────────┘   │
│                             │
│  ┌──────────────────────┐   │
│  │ 🖼️ Upload from Gallery│   │
│  └──────────────────────┘   │
│                             │
│  💡 Tips for best results   │
│  • Use natural daylight     │
│  • Focus on ONE leaf        │
└─────────────────────────────┘
```

### Screen 2 — Result Screen (`result_screen.dart`) ✓ Already created

```
┌─────────────────────────────┐
│  ← Analysis Result          │
├─────────────────────────────┤
│  [Photo of scanned leaf]    │
│                             │
│  ⚠️ Citrus Canker Detected  │  ← red border if diseased
│  Confidence: 94.1% ████████ │
│  Description of disease...  │
│                             │
│  🏥 Treatment Steps         │
│  ① Remove infected leaves   │
│  ② Apply copper spray...    │
│                             │
│  🛡️ Prevention Tips         │
│  • Use disease-free plants  │
│  • Avoid overhead water     │
│                             │
│  [📷 Scan Another Leaf]     │
└─────────────────────────────┘
```

### Screen 3 — History Screen (`history_screen.dart`) — You Need to Build This

```
┌─────────────────────────────┐
│  ← Scan History             │
├─────────────────────────────┤
│  [thumbnail] citrus_canker  │
│              94% • 2 hrs ago│
├─────────────────────────────┤
│  [thumbnail] healthy        │
│              98% • 1 day ago│
├─────────────────────────────┤
│  [thumbnail] Not a leaf     │
│              rejected       │
└─────────────────────────────┘
```

---

## 🔌 API Connection

The app talks to Ganga's Django server. All API calls are in `api_service.dart`.

### Base URL Settings
```dart
// lib/services/api_service.dart

// For Android Emulator:
static const String baseUrl = 'http://10.0.2.2:8000/api';

// For iOS Simulator:
static const String baseUrl = 'http://127.0.0.1:8000/api';

// For Real Phone (use Ganga's computer IP):
static const String baseUrl = 'http://192.168.1.XX:8000/api';
// Ask Ganga: run `ip addr` on his computer to get his IP
```

### What the API Returns
When you call `POST /api/predict/` with a leaf image, you get:

```json
{
  "id": 1,
  "is_lemon": true,
  "final_label": "citrus_canker",
  "confidence": 0.9412,
  "message": "Lemon leaf detected. Disease: citrus_canker (94%).",
  "stage1": {
    "predicted_class": "lemon_leaf",
    "confidence": 0.9721
  },
  "stage2": {
    "predicted_class": "citrus_canker",
    "confidence": 0.9412,
    "all_probabilities": {
      "healthy": 0.012,
      "citrus_canker": 0.941,
      "greasy_spot": 0.023,
      "sooty_mold": 0.008,
      "yellow_mosaic": 0.011,
      "powdery_mildew": 0.005
    }
  },
  "treatment": {
    "status": "Citrus Canker Detected",
    "description": "Citrus canker is a bacterial disease...",
    "treatment": ["Remove infected leaves", "Apply copper spray..."],
    "prevention": ["Use certified planting material", "..."],
    "severity": "high"
  }
}
```

**Severity colors to use:**
- `"high"` → Red `Color(0xFFD32F2F)`
- `"medium"` → Orange `Color(0xFFF57C00)`
- `"none"` (healthy) → Green `Color(0xFF2E7D32)`

---

## 🌐 Language Support (EN/NP)

The app supports English and Nepali. Language switching is handled by `LanguageProvider`.

### How to Use in Any Screen
```dart
// At top of widget build method:
final lang = context.watch<LanguageProvider>();

// Use lang.t() to show text in selected language:
Text(lang.t('Scan with Camera', 'क्यामेराले स्क्यान गर्नुहोस्'))
Text(lang.t('Treatment Steps', 'उपचार विधि'))
Text(lang.t('Upload from Gallery', 'ग्यालरीबाट अपलोड गर्नुहोस्'))

// Toggle language:
lang.toggleLanguage()   // switches between EN and NP

// Check current language:
lang.isNepali   // true if Nepali is selected
lang.language   // 'en' or 'np'
```

### API Language — Send to Backend
```dart
// When making predict request, send language:
request.fields['language'] = lang.language;   // sends 'en' or 'np'
// Backend returns treatment text in the selected language
```

---

## 🎨 Design Guidelines

### Colors
```dart
// Use these consistent colors throughout the app
const Color primaryGreen  = Color(0xFF2E7D32);   // main green
const Color lightGreen    = Color(0xFF388E3C);   // button green
const Color bgColor       = Color(0xFFF5F9F0);   // app background
const Color severityHigh  = Color(0xFFD32F2F);   // red — high severity
const Color severityMed   = Color(0xFFF57C00);   // orange — medium
const Color severityNone  = Color(0xFF2E7D32);   // green — healthy
```

### Text Styles
```dart
// Title
TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))

// Body
TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5)

// Button label
TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
```

### Border Radius
```dart
// Always use rounded corners
BorderRadius.circular(16)   // cards, images
BorderRadius.circular(12)   // buttons
BorderRadius.circular(8)    // progress bars, small elements
```

---

## 📦 All Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  http: ^1.2.0
  image_picker: ^1.0.7
  camera: ^0.10.5
  path_provider: ^2.1.2
  path: ^1.9.0
  flutter_spinkit: ^5.2.0
  cached_network_image: ^3.3.1
  percent_indicator: ^4.2.3
  lottie: ^3.1.0
  provider: ^6.1.2
  shared_preferences: ^2.2.3
  intl: ^0.20.2
  cupertino_icons: ^1.0.8
```

---

## 🔧 Android Permissions

Make sure `android/app/src/main/AndroidManifest.xml` has:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 🌿 Git Workflow for Prasamsha

```bash
# Always start by pulling latest changes
git pull origin main

# Create your branch
git checkout -b feature/prasamsha-result-screen

# Work on your screen files...

# Stage only YOUR files (don't commit backend or ML files)
git add frontend/
git commit -m "Build result screen with treatment cards and severity badge"

# Push your branch
git push origin feature/prasamsha-result-screen

# Create Pull Request on GitHub to merge into main
# Tell Ganga to review and merge
```

---

## 🆘 Common Errors & Fixes

**`flutter pub get` fails with version error:**
```bash
flutter pub upgrade
flutter pub get
```

**`MissingPluginException` for camera or image_picker:**
```bash
flutter clean
flutter pub get
flutter run
```

**`Connection refused` when calling API:**
- Make sure Ganga's Django server is running: `python manage.py runserver 0.0.0.0:8000`
- Check your `baseUrl` in `api_service.dart` — use `10.0.2.2` for Android emulator
- Make sure phone and computer are on the same WiFi network for real device testing

**App shows blank white screen:**
- Check `main.dart` has `ChangeNotifierProvider` wrapping the app
- Run `flutter run` and check terminal for error messages

**Image not uploading:**
- Check AndroidManifest.xml has CAMERA and STORAGE permissions
- On Android 13+, use `READ_MEDIA_IMAGES` instead of `READ_EXTERNAL_STORAGE`

---

## ✅ Your Complete Task List

- [ ] Clone repo and run `flutter pub get` successfully
- [ ] Run `flutter run` — app launches on emulator or phone
- [ ] Home Screen — Camera and Gallery buttons work
- [ ] Image picker opens camera and gallery correctly
- [ ] API call sends image to Django (test with Ganga's server running)
- [ ] Loading indicator shows while waiting for response
- [ ] Result Screen — shows disease name and confidence bar
- [ ] Result Screen — shows treatment steps as numbered cards
- [ ] Result Screen — shows prevention tips as bullet cards
- [ ] Language toggle — switches between English and Nepali
- [ ] Nepali text displays correctly on all screens
- [ ] History Screen — shows list of past predictions
- [ ] Severity badge — correct color (red/orange/green) per disease
- [ ] "Not a lemon leaf" rejection handled gracefully
- [ ] Error handling — shows friendly message if server is down
- [ ] Test on both Android and iOS (or emulators)
- [ ] App icon and name set correctly

---

## 📞 Contact

- **Ganga (Backend)** — if API returns unexpected responses or server errors
- **Bhawna (ML)** — if you want to understand what diseases look like or add disease info to UI
