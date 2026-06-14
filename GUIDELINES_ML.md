# 🤖 ML Engineer Guide — Bhawna

Welcome to the project! This guide is everything you need to set up, understand,
and complete your Machine Learning work for the Lemon Leaf Disease Detection system.

---

## 🎯 Your Responsibility

You are responsible for **building, training, and delivering the AI models** that
power the entire app. Ganga's Django backend will call your trained model to make
predictions. Prasamsha's Flutter app will display those results.

**Your two deliverables:**
1. `saved_models/stage1/best_model.h5` — lemon leaf detector
2. `saved_models/stage2/best_model.h5` — disease classifier

---

## 📁 Your Working Folders

```
lemon_disease_project/
│
├── 📂 ml/                        ← YOUR MAIN FOLDER
│   ├── utils/
│   │   ├── config.py             ← reads config.yaml, all settings here
│   │   └── visualize.py          ← Grad-CAM heatmap generation
│   ├── data/
│   │   ├── loader.py             ← loads images, builds tf.data pipeline
│   │   ├── preprocess.py         ← resize + normalize images
│   │   └── augmentation.py       ← random flips, brightness, zoom etc.
│   ├── models/
│   │   ├── base_model.py         ← EfficientNetB0 backbone builder
│   │   ├── stage1_model.py       ← lemon vs others classifier
│   │   └── stage2_model.py       ← disease classifier
│   ├── training/
│   │   ├── train_stage1.py       ← run this to train Stage 1
│   │   ├── train_stage2.py       ← run this to train Stage 2
│   │   ├── callbacks.py          ← ModelCheckpoint, EarlyStopping etc.
│   │   └── evaluate.py           ← confusion matrix, classification report
│   └── pipeline/
│       ├── predict.py            ← full two-stage inference pipeline
│       └── confidence.py         ← threshold logic (reject uncertain inputs)
│
├── 📂 data/                      ← PUT YOUR DATASET IMAGES HERE
│   ├── stage1_binary/
│   │   ├── lemon_leaf/           ← 500-1000 lemon leaf images
│   │   ├── other_leaf/           ← 300-500 other plant leaves
│   │   └── other_object/         ← 300-500 non-leaf objects
│   └── stage2_disease/
│       ├── healthy/              ← 200+ healthy lemon leaves
│       ├── citrus_canker/        ← 200+ canker infected leaves
│       ├── greasy_spot/          ← 200+ greasy spot leaves
│       ├── sooty_mold/           ← 200+ sooty mold leaves
│       ├── yellow_mosaic/        ← 200+ yellow mosaic leaves
│       └── powdery_mildew/       ← 200+ powdery mildew leaves
│
├── 📂 saved_models/              ← TRAINED MODELS SAVED HERE AUTOMATICALLY
│   ├── stage1/
│   │   ├── best_model.h5         ← auto-saved during training
│   │   └── tflite/model.tflite   ← auto-exported for mobile
│   └── stage2/
│       ├── best_model.h5
│       └── tflite/model.tflite
│
├── 📂 notebooks/                 ← YOUR EXPERIMENT NOTEBOOKS
│   ├── 01_eda.ipynb              ← explore your dataset here first
│   ├── 02_stage1_experiment.ipynb
│   └── 03_stage2_experiment.ipynb
│
├── 📂 logs/                      ← TensorBoard training logs (auto-generated)
├── 📂 reports/                   ← confusion matrices, charts (auto-generated)
└── config.yaml                   ← CENTRAL CONFIG — change settings here
```

> ⚠️ **IMPORTANT:** `data/` and `saved_models/` are in `.gitignore`.
> They will NOT be pushed to GitHub (too large).
> Share dataset via Google Drive and share model weights via Google Drive link.

---

## ⚙️ Setup — Do This First

### 1. Clone & Enter Project
```bash
git clone https://github.com/gangaadhikari123/Lemon_Leaf_Disease_Detection.git
cd Lemon_Leaf_Disease_Detection
```

### 2. Create Virtual Environment
```bash
python3 -m venv lemon_env
source lemon_env/bin/activate
```

> Every time you open a new terminal, run `source lemon_env/bin/activate` first!

### 3. Install ML Dependencies
```bash
pip install --upgrade pip
pip install tensorflow>=2.12.0
pip install numpy pillow scikit-learn matplotlib seaborn opencv-python pyyaml
pip install jupyter notebook ipykernel
```

Or install everything at once:
```bash
pip install -r requirements.txt
```

### 4. Verify TensorFlow
```bash
python -c "
import tensorflow as tf
print('TensorFlow:', tf.__version__)
print('GPU available:', tf.config.list_physical_devices('GPU'))
"
```

### 5. Create Required Folders
```bash
mkdir -p data/stage1_binary/{lemon_leaf,other_leaf,other_object}
mkdir -p data/stage2_disease/{healthy,citrus_canker,greasy_spot,sooty_mold,yellow_mosaic,powdery_mildew}
mkdir -p saved_models/{stage1/tflite,stage2/tflite}
mkdir -p logs reports notebooks
```

---

## 📊 Step 1 — Collect & Organize Dataset

### Where to Get Images

| Source | Link | What to Download |
|---|---|---|
| Kaggle PlantVillage | kaggle.com/datasets/emmarex/plantdisease | Citrus disease images |
| Kaggle New Plant Diseases | kaggle.com/datasets/vipoooool/new-plant-diseases-dataset | Other leaf classes |
| Roboflow Universe | universe.roboflow.com | Search "lemon leaf disease" |
| Your own photos | Use your phone camera | Local lemon leaves |

### Minimum Images Required

| Folder | Minimum | Recommended |
|---|---|---|
| `stage1_binary/lemon_leaf/` | 300 | 700+ |
| `stage1_binary/other_leaf/` | 200 | 400+ |
| `stage1_binary/other_object/` | 200 | 400+ |
| Each `stage2_disease/` class | 100 | 300+ |

### Verify Your Dataset
```bash
python run_check.py
```

Expected output:
```
Stage 1: data/stage1_binary
  ✓  lemon_leaf: 712 images
  ✓  other_leaf: 420 images
  ✓  other_object: 380 images

Stage 2: data/stage2_disease
  ✓  healthy: 310 images
  ✓  citrus_canker: 290 images
  ...
✓ Dataset ready!
```

---

## 🔬 Step 2 — Explore Dataset (EDA)

Before training, always explore your data:

```bash
# Start Jupyter notebook
jupyter notebook notebooks/01_eda.ipynb
```

In the notebook, check:
- Class distribution (are classes balanced?)
- Sample images from each class
- Image sizes and quality
- Any corrupted or mislabeled images

---

## 🧠 Step 3 — Understand the Two-Stage Pipeline

```
Input Image
     ↓
[STAGE 1] Is it a lemon leaf?
  ├── lemon_leaf (confidence ≥ 0.85) → go to Stage 2
  ├── other_leaf → REJECT "Not a lemon leaf"
  └── other_object → REJECT "Not a lemon leaf"
     ↓
[STAGE 2] What disease?
  ├── healthy
  ├── citrus_canker
  ├── greasy_spot
  ├── sooty_mold
  ├── yellow_mosaic
  └── powdery_mildew
```

**Why two stages?**
Stage 1 acts as a gatekeeper — if someone points the camera at a mango leaf
or their hand, the app rejects it immediately before wasting resources on
disease classification.

---

## 🏋️ Step 4 — Train Stage 1 Model

```bash
# Make sure virtual environment is active
source lemon_env/bin/activate

# Run Stage 1 training
python -m ml.training.train_stage1
```

**What happens:**
- Phase 1 (epochs 1-15): Only the classification head trains. Backbone is frozen.
- Phase 2 (epochs 16-40): Top 20 backbone layers unfreeze for fine-tuning.
- Best model auto-saved to `saved_models/stage1/best_model.h5`
- TFLite model auto-exported to `saved_models/stage1/tflite/model.tflite`

**Watch for:**
```
Epoch 1/15 — loss: 0.85 — accuracy: 0.65 — val_accuracy: 0.62
Epoch 5/15 — loss: 0.42 — accuracy: 0.84 — val_accuracy: 0.81
...
Phase 1 complete. Best val_accuracy: 0.8921

PHASE 2: Fine-tuning top backbone layers
Epoch 1/25 — val_accuracy: 0.9142
...
Phase 2 complete. Best val_accuracy: 0.9380
```

**Target:** Stage 1 val_accuracy ≥ **90%** before moving to Stage 2.

---

## 📈 Step 5 — Evaluate Stage 1

```bash
python -m ml.training.evaluate --stage 1
```

This generates:
- `reports/stage1_confusion_matrix.png` — shows where model confuses classes
- `reports/stage1_per_class_accuracy.png` — accuracy per class
- `reports/stage1_classification_report.txt` — precision, recall, F1

**Open confusion matrix:**
```bash
eog reports/stage1_confusion_matrix.png
```

If Stage 1 accuracy is below 90%, try:
- Collecting more images for weak classes
- Increasing `phase2_epochs` in `config.yaml`
- Lowering `phase2_lr` in `config.yaml`

---

## 🦠 Step 6 — Train Stage 2 Model

Only proceed after Stage 1 achieves ≥ 90% accuracy.

```bash
python -m ml.training.train_stage2
```

Same process as Stage 1 but for disease classification.
Target: Stage 2 val_accuracy ≥ **85%**

---

## 👁️ Step 7 — Visualize What Model Sees (Grad-CAM)

Grad-CAM shows which part of the leaf the model looked at:

```bash
python -m ml.utils.visualize path/to/leaf.jpg 2
```

Opens a side-by-side image: original leaf + heatmap overlay.
Red areas = what the model focused on.
Share interesting Grad-CAM results with the team!

---

## ✅ Step 8 — Test Full Pipeline

```bash
python -m ml.pipeline.predict path/to/test_leaf.jpg
```

Expected output:
```
── Prediction Result ──
  Is lemon leaf:  True
  Final label:    citrus_canker
  Confidence:     94.1%
  Message:        Lemon leaf detected (97%). Disease: 'citrus_canker' (94%).

  Disease probabilities:
    healthy              0.012  ▏
    citrus_canker        0.941  ██████████████████▊
    greasy_spot          0.023  ▏
    sooty_mold           0.008  
    yellow_mosaic        0.011  
    powdery_mildew       0.005  
```

---

## 📤 Step 9 — Share Models with Team

Since model files are too large for GitHub, share via Google Drive:

```bash
# Check model file sizes
ls -lh saved_models/stage1/best_model.h5
ls -lh saved_models/stage2/best_model.h5
```

1. Upload both `.h5` files to Google Drive
2. Share the Drive link with Ganga
3. Ganga will place them in `saved_models/` on the server

---

## 🔧 Adjusting Settings

All settings are in `config.yaml` at the project root.
**Do not hardcode values in Python files.**

Common things you might change:

```yaml
# Increase epochs if model isn't converging
training:
  phase1_epochs: 20      # default 15
  phase2_epochs: 30      # default 25

# Lower LR if val_accuracy is jumping around
  phase2_lr: 0.000005    # default 0.00001

# Increase confidence threshold if getting wrong predictions
stage1:
  confidence_threshold: 0.90   # default 0.85
```

After changing `config.yaml`, commit it:
```bash
git add config.yaml
git commit -m "Increase phase1_epochs to 20 for better convergence"
git push origin feature/bhawna-your-feature-name
```

---

## 🌿 Git Workflow for Bhawna

```bash
# Always start by pulling latest changes
git pull origin main

# Create your own branch for each feature
git checkout -b feature/bhawna-stage1-training

# Work on your files...

# Stage and commit your work
git add ml/
git add config.yaml
git commit -m "Complete Stage 1 training — achieved 93.2% val accuracy"

# Push your branch
git push origin feature/bhawna-stage1-training

# On GitHub, create a Pull Request to merge into main
# Tell Ganga to review and merge
```

**Files you will mostly work with:**
- `ml/` — all files inside here
- `config.yaml` — hyperparameter tuning
- `notebooks/` — experiments
- `data/` — your dataset (not pushed to git)

**Files you should NOT change:**
- `predictor/` — Ganga's Django app
- `frontend/` — Prasamsha's Flutter app
- `bakend/settings.py` — Django settings

---

## 🆘 Common Errors & Fixes

**Error: `ModuleNotFoundError: No module named 'tensorflow'`**
```bash
source lemon_env/bin/activate   # activate virtual environment first
```

**Error: `FileNotFoundError: Expected class directory not found`**
```bash
# Your data folders are missing or misnamed
ls data/stage1_binary/          # check what's there
# Make sure folder names match exactly: lemon_leaf, other_leaf, other_object
```

**Error: `CUDA out of memory`**
```python
# Add to top of training script to limit GPU memory
import tensorflow as tf
gpus = tf.config.list_physical_devices('GPU')
if gpus:
    tf.config.experimental.set_memory_growth(gpus[0], True)
```

**Error: `val_accuracy not improving`**
- Check class imbalance in dataset
- Try increasing data augmentation zoom_range in `config.yaml`
- Check if images are clearly focused and well-lit

---

## 📋 Your Complete Task List

- [ ] Setup virtual environment and install dependencies
- [ ] Collect minimum dataset (300+ images per Stage 1 class)
- [ ] Run `python run_check.py` — all classes show green ✓
- [ ] Run `notebooks/01_eda.ipynb` — explore dataset
- [ ] Train Stage 1 — achieve ≥ 90% val_accuracy
- [ ] Evaluate Stage 1 — check confusion matrix
- [ ] Train Stage 2 — achieve ≥ 85% val_accuracy
- [ ] Evaluate Stage 2 — check per-class accuracy
- [ ] Test full pipeline with `predict.py`
- [ ] Generate Grad-CAM visualizations
- [ ] Upload trained models to Google Drive
- [ ] Share Google Drive link with Ganga
- [ ] Document any config changes in commit messages

---

## 📞 Contact

- **Ganga (Backend)** — if predict endpoint not working or API format issues
- **Prasamsha (Frontend)** — if you want to see how results are displayed in the app
