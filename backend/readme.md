brew install python@3.11  
python3.11 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

to run backend code using docker file
cd docker
docker-compose up --build

http://127.0.0.1:8000/api/predict-ui/

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
│       └── utils.py            → Image preprocessing + helper functions  
│
├── 📂 ml/
│   ├── 📂 models/
│   │   └── models.keras          → Trained ConvNeXt / CNN model
│   │
│   ├── 📂 pipeline/
│   │   └── predict.py            → Load model + run inference
│   
│
├── 📂 media/
│                  
│
├── 📂 docker/
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── manage.py
├── requirements.txt



to run database
docker-compose build
docker-compose up -d

docker-compose exec ..python manage.py makemigrations
docker-compose exec ..python manage.py migrate
