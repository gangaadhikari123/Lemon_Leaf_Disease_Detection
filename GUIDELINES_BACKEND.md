# ⚙️ Backend Developer Guide — Ganga

This is your own reference guide for the Django backend.
Share the other two guides with Bhawna and Prasamsha.

---

## 🎯 Your Responsibility

You are responsible for:
- Django REST API that Flutter app calls
- Database storing all prediction records
- Connecting Bhawna's trained ML models to the API
- Keeping the server running for the team to test against

---

## 📁 Your Working Folders

```
lemon_disease_project/
├── 📂 bakend/              ← Django project settings
│   ├── settings.py         ← INSTALLED_APPS, CORS, MEDIA settings
│   ├── urls.py             ← Root URL router
│   └── wsgi.py             ← Production server entry point
├── 📂 predictor/           ← Django API app
│   ├── models.py           ← PredictionRecord database model
│   ├── views.py            ← API endpoint logic
│   ├── serializers.py      ← JSON serialization
│   ├── urls.py             ← API URL routes
│   ├── treatments.py       ← Treatment data EN + NP
│   ├── admin.py            ← Django admin configuration
│   └── tests.py            ← API unit tests
├── manage.py
├── requirements.txt
└── config.yaml             ← Central config (shared with ML team)
```

---

## ⚙️ Setup

```bash
cd ~/lemon_disease_project
source lemon_env/bin/activate
python manage.py check
python manage.py migrate
python manage.py runserver 0.0.0.0:8000   # 0.0.0.0 allows phone to connect
```

---

## 🔌 API Endpoints Reference

| Method | URL | Description | Used By |
|---|---|---|---|
| `POST` | `/api/predict/` | Upload image → prediction + treatment | Prasamsha (Flutter) |
| `GET` | `/api/health/` | Server + model status check | Prasamsha (Flutter) |
| `GET` | `/api/classes/` | List all class names | Prasamsha (Flutter) |
| `GET` | `/api/history/` | Past prediction records | Prasamsha (Flutter) |
| `GET` | `/admin/` | Django admin dashboard | You only |

---

## 🤝 How You Connect with Bhawna (ML)

Once Bhawna trains the models, she will share `.h5` files via Google Drive.

**You need to:**
1. Download `stage1/best_model.h5` and `stage2/best_model.h5`
2. Place them in `saved_models/stage1/` and `saved_models/stage2/`
3. Restart Django server
4. Test: `curl http://127.0.0.1:8000/api/health/` → both models should show `true`

---

## 🤝 How You Connect with Prasamsha (Frontend)

When Prasamsha is testing on her phone:

```bash
# Run server accessible on local network
python manage.py runserver 0.0.0.0:8000

# Find your IP address
ip addr | grep 'inet ' | grep -v '127.0.0.1'
# Example output: inet 192.168.1.105
```

Tell Prasamsha: **"Use `http://192.168.1.105:8000/api` as the base URL"**
She will update `api_service.dart` with this IP.

---

## ✅ Your Task List

- [ ] `python manage.py check` — no issues
- [ ] `python manage.py migrate` — all tables created
- [ ] `/api/health/` returns JSON
- [ ] `/api/classes/` returns correct class names
- [ ] `/api/predict/` returns 503 before models, 200 after models loaded
- [ ] Admin panel shows PredictionRecord entries
- [ ] `python manage.py test predictor` — all tests pass
- [ ] Server runs on `0.0.0.0:8000` for phone testing
- [ ] Receive models from Bhawna and place in `saved_models/`
- [ ] Full end-to-end test with Prasamsha's Flutter app

---

## 🌿 Git Workflow

```bash
git pull origin main
git checkout -b feature/ganga-your-feature
# make changes
git add predictor/ bakend/
git commit -m "Your descriptive message"
git push origin feature/ganga-your-feature
# Merge via Pull Request on GitHub
```
