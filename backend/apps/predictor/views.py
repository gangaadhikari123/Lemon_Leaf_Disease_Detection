from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

import numpy as np
from ml.pipeline.predict import leaf_model, disease_model, class_names
from .utils import preprocess
from .models import PredictionHistory
from .services import get_treatment   
from .models import PredictionHistory


# UI Page
def predict_ui(request):
    return render(request, "index.html")



# Prediction API
@csrf_exempt
def predict_image(request):

    if request.method == "POST":

      
        # 1. GET IMAGE
        image = request.FILES.get("image")

        if not image:
            return JsonResponse({"error": "No image uploaded"})

        
        # 2. PREPROCESS
        img_array = preprocess(image)

      
        # 3. LEAF DETECTION
        leaf_pred = leaf_model.predict(img_array)
        leaf_confidence = float(leaf_pred[0][0])

        print("Leaf confidence:", leaf_confidence)

        if leaf_confidence > 0.5:
            return JsonResponse({
                "result": "Not a lemon leaf"
            })

     
        # 4. DISEASE PREDICTION
        disease_pred = disease_model.predict(img_array)

        class_index = np.argmax(disease_pred)
        confidence = float(np.max(disease_pred))

        disease = class_names[class_index].strip()

        print("Predicted disease:", disease)


        # 5. GET BOTH LANGUAGES
        treatment = get_treatment(disease)


        # 6. SAVE HISTORY (optional)
        PredictionHistory.objects.create(
            disease=disease,
            is_lemon_leaf=True,
            confidence=confidence,
            treatment=json.dumps(treatment)
        )

        # 7. RESPONSE (BOTH EN + NP)
        return JsonResponse({
            "result": "Lemon Leaf Detected",
            "disease": disease,
            "confidence": confidence,
            "treatment": treatment   # <-- contains both EN + NP
        })

    return JsonResponse({"error": "Only POST allowed"})



# HEALTH CHECK
def health(request):
    return JsonResponse({
        "status": "ok",
        "leaf_model": "loaded",
        "disease_model": "loaded"
    })



# CLASSES API
def classes(request):
    return JsonResponse({
        "leaf_classes": [
            "lemon_leaf",
            "not_lemon_leaf"
        ],
        "disease_classes": class_names
    })



# HISTORY API
def history(request):

    data = PredictionHistory.objects.all().order_by("-created_at")

    results = []

    for item in data:
        results.append({
            "id": item.id,
            "disease": item.disease,
            "is_lemon_leaf": item.is_lemon_leaf,
            "confidence": item.confidence,
            "treatment": item.treatment,
            "created_at": item.created_at
        })

    return JsonResponse({
        "count": len(results),
        "results": results
    })

# 2. HEALTH CHECK API
def health(request):

    return JsonResponse({
        "status": "ok",
        "leaf_model": "loaded",
        "disease_model": "loaded"
    })



# 3. CLASSES API
def classes(request):

    return JsonResponse({
        "leaf_classes": [
            "lemon_leaf",
            "not_lemon_leaf"
        ],
        "disease_classes": class_names
    })



# 4. HISTORY API
def history(request):

    data = PredictionHistory.objects.all().order_by("-created_at")

    results = []

    for item in data:
        results.append({
            "id": item.id,
            "disease": item.disease,
            "is_lemon_leaf": item.is_lemon_leaf,
            "confidence": item.confidence,
            "treatment": item.treatment,
            "created_at": item.created_at
        })

    return JsonResponse({
        "count": len(results),
        "results": results
    })