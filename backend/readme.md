brew install python@3.11  
python3.11 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

to run backend code using docker file
cd docker
docker-compose up --build

http://127.0.0.1:8000/api/predict-ui/


backend/
├── config/                      → Django settings only
│
├── apps/
│   └── predictor/
│       ├── models.py            → DB models
│       ├── views.py            → API
│       ├── urls.py
│       ├── serializers.py
│       ├── services.py         
│
├── ml/
│   ├── models/
│   │   └── models.keras
│   ├── pipeline/
│   │   └── predict.py
│   ├── utils/
│
├── media/
├── manage.py
├── requirements.txt
└── docker/



to run database
docker-compose build
docker-compose up -d

docker-compose exec ..python manage.py makemigrations
docker-compose exec ..python manage.py migrate