# 🍋 Lemon Leaf Disease Detection System

An AI-powered mobile application that detects lemon leaf diseases using a camera or gallery photo and provides treatment recommendations in both **English and Nepali**.

---

## 👥 Team

| Name | Role | Responsibility |
|---|---|---|
| **Ganga** | Backend Developer | Django REST API, Database, Server |
| **Bhawna** | ML Engineer | TensorFlow Model, Training Pipeline |
| **Prasamsha** | Frontend Developer | Flutter Mobile App (Android + iOS) |

---

## 🏗️ System Architecture

```
Flutter App (Prasamsha)
      ↓  HTTP requests
Django REST API (Ganga)
      ↓  calls ML pipeline
TensorFlow Model (Bhawna)
      ↓  returns prediction
Django sends result + treatment back to Flutter
```

---

## 📁 Project Structure Overview

```
lemon_disease_project/
│
├── 📂 bakend/              → Django project settings (Ganga)
├── 📂 predictor/           → Django API app (Ganga)
├── 📂 ml/                  → Machine Learning pipeline (Bhawna)
│   ├── data/               → Data loading, preprocessing, augmentation
│   ├── models/             → EfficientNetB0 model architecture
│   ├── training/           → Training scripts for Stage 1 & Stage 2
│   ├── pipeline/           → Inference pipeline (predict.py)
│   └── utils/              → Config, visualization, metrics
├── 📂 frontend/            → Flutter mobile app (Prasamsha)
│   └── lib/
│       ├── screens/        → Home, Scan, Result, History screens
│       ├── services/       → API calls to Django
│       ├── models/         → Data models
│       ├── widgets/        → Reusable UI components
│       └── utils/          → Language provider, constants
├── 📂 data/                → Dataset images (NOT pushed to git)
│   ├── stage1_binary/      → lemon_leaf / other_leaf / other_object
│   └── stage2_disease/     → healthy / citrus_canker / greasy_spot / ...
├── 📂 saved_models/        → Trained model weights (NOT pushed to git)
├── 📂 notebooks/           → Jupyter notebooks for experiments (Bhawna)
├── config.yaml             → Central configuration (ALL settings here)
├── requirements.txt        → Python dependencies
├── .gitignore              → Files excluded from git
└── README.md               → This file
```

---

## 🚀 Quick Start (All Team Members)

### 1. Clone the Repository
```bash
git clone https://github.com/gangaadhikari123/Lemon_Leaf_Disease_Detection.git
cd Lemon_Leaf_Disease_Detection
```

### 2. Read Your Role-Specific Guide
- **Bhawna (ML)** → Read [`GUIDELINES_ML.md`](./GUIDELINES_ML.md)
- **Prasamsha (Frontend)** → Read [`GUIDELINES_FRONTEND.md`](./GUIDELINES_FRONTEND.md)
- **Ganga (Backend)** → Read [`GUIDELINES_BACKEND.md`](./GUIDELINES_BACKEND.md)

---

## 🔗 API Endpoints (For Reference)

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/predict/` | Upload leaf image → get disease + treatment |
| `GET` | `/api/health/` | Check server and model status |
| `GET` | `/api/classes/` | List all disease class names |
| `GET` | `/api/history/` | Get past prediction records |

---

## 🌿 Disease Classes

**Stage 1 — Is it a lemon leaf?**
- `lemon_leaf`, `other_leaf`, `other_object`

**Stage 2 — What disease does it have?**
- `healthy`, `citrus_canker`, `greasy_spot`, `sooty_mold`, `yellow_mosaic`, `powdery_mildew`

---

## 📞 Team Communication Rules

1. **Never push directly to `main`** — always create a branch
2. **Branch naming:** `feature/your-name-feature` e.g. `feature/bhawna-stage1-training`
3. **Commit messages:** be descriptive e.g. `Add EfficientNetB0 base model builder`
4. **Pull before you push** — always run `git pull origin main` before starting work
5. **Ask before changing** `config.yaml` — it affects everyone's code
