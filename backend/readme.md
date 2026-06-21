Tech Stack
Django + Django REST Framework
Python 3.11
TensorFlow / PyTorch (ML model)
Docker & Docker Compose
SQLite / PostgreSQL (configurable)
📁 Project Structure
backend/
├── 📂 config/                     → Django project settings only
│   ├── settings.py               → INSTALLED_APPS, CORS, MEDIA, DB config
│   ├── urls.py                   → Root URL router
│   ├── wsgi.py                   → Production entry point
│   └── asgi.py                   → Async support (optional)
│
├── 📂 apps/
│   └── 📂 predictor/             → Main ML prediction API app
│       ├── models.py             → PredictionRecord DB model
│       ├── views.py              → API endpoints (upload, predict, history)
│       ├── urls.py               → API routes
│       ├── serializers.py        → JSON serialization (DRF)
│       ├── services.py           → Business logic (prediction workflow)
│       ├── treatments.py         → Disease treatments (EN + NP)
│       ├── admin.py              → Django admin setup
│       └── utils.py              → Image preprocessing + helper functions
│
├── 📂 ml/
│   ├── 📂 models/
│   │   └── models.keras          → Trained ConvNeXt / CNN model
│   │
│   ├── 📂 pipeline/
│   │   └── predict.py            → Load model + run inference
│
├── 📂 media/
│   ├── uploads/                  → Uploaded leaf images
│   └── results/                 → Processed outputs (optional)
│
├── 📂 docker/
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── manage.py
├── requirements.txt
└── config.yaml
⚙️ Setup (Local Development)
1️⃣ Install Python 3.11 (Mac)
brew install python@3.11
2️⃣ Create Virtual Environment
python3.11 -m venv .venv
source .venv/bin/activate
3️⃣ Install Dependencies
pip install -r requirements.txt
🐳 Run Using Docker (Recommended)
1️⃣ Build Docker Containers
cd docker
docker-compose up --build
2️⃣ Run in Background
docker-compose up -d
🗄️ Database Setup (Docker)
Build & Start Services
docker-compose build
docker-compose up -d
Run Migrations
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate
🌐 API Access
Prediction UI
http://127.0.0.1:8000/api/predict-ui/
🔥 Common Docker Commands
Stop containers
docker-compose down
View logs
docker-compose logs -f
Restart services
docker-compose restart
