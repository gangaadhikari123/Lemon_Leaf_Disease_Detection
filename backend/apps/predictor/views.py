# from django.shortcuts import render
# from django.http import JsonResponse
# from django.views.decorators.csrf import csrf_exempt

# import numpy as np
# from ml.pipeline.predict import leaf_model, disease_model, class_names
# from .utils import preprocess
# from .models import PredictionHistory
# from .services import get_treatment   
# from .models import PredictionHistory
# import json


# # UI Page
# def predict_ui(request):
#     return render(request, "index.html")



# # Prediction API
# @csrf_exempt
# def predict_image(request):

#     if request.method == "POST":

      
#         # 1. GET IMAGE
#         image = request.FILES.get("image")

#         if not image:
#             return JsonResponse({"error": "No image uploaded"})

        
#         # 2. PREPROCESS
#         img_array = preprocess(image)

      
#         # 3. LEAF DETECTION
#         leaf_pred = leaf_model.predict(img_array)
#         leaf_confidence = float(leaf_pred[0][0])

#         print("Leaf confidence:", leaf_confidence)

#         if leaf_confidence > 0.5:
#             return JsonResponse({
#                 "result": "Not a lemon leaf"
#             })

     
#         # 4. DISEASE PREDICTION
#         disease_pred = disease_model.predict(img_array)

#         class_index = np.argmax(disease_pred)
#         confidence = float(np.max(disease_pred))

#         disease = class_names[class_index].strip()

#         print("Predicted disease:", disease)


#         # 5. GET BOTH LANGUAGES
#         treatment = get_treatment(disease)


#         # 6. SAVE HISTORY (optional)
#         PredictionHistory.objects.create(
#             disease=disease,
#             is_lemon_leaf=True,
#             confidence=confidence,
#             treatment=json.dumps(treatment)
#         )

#         # 7. RESPONSE (BOTH EN + NP)
#         return JsonResponse({
#             "result": "Lemon Leaf Detected",
#             "disease": disease,
#             "confidence": confidence,
#             "treatment": treatment   # <-- contains both EN + NP
#         })

#     return JsonResponse({"error": "Only POST allowed"})



# # HEALTH CHECK
# def health(request):
#     return JsonResponse({
#         "status": "ok",
#         "leaf_model": "loaded",
#         "disease_model": "loaded"
#     })



# # CLASSES API
# def classes(request):
#     return JsonResponse({
#         "leaf_classes": [
#             "lemon_leaf",
#             "not_lemon_leaf"
#         ],
#         "disease_classes": class_names
#     })



# # HISTORY API
# def history(request):

#     data = PredictionHistory.objects.all().order_by("-created_at")

#     results = []

#     for item in data:
#         results.append({
#             "id": item.id,
#             "disease": item.disease,
#             "is_lemon_leaf": item.is_lemon_leaf,
#             "confidence": item.confidence,
#             "treatment": item.treatment,
#             "created_at": item.created_at
#         })

#     return JsonResponse({
#         "count": len(results),
#         "results": results
#     })

# # 2. HEALTH CHECK API
# def health(request):

#     return JsonResponse({
#         "status": "ok",
#         "leaf_model": "loaded",
#         "disease_model": "loaded"
#     })



# # 3. CLASSES API
# def classes(request):

#     return JsonResponse({
#         "leaf_classes": [
#             "lemon_leaf",
#             "not_lemon_leaf"
#         ],
#         "disease_classes": class_names
#     })



# # 4. HISTORY API
# def history(request):

#     data = PredictionHistory.objects.all().order_by("-created_at")

#     results = []

#     for item in data:
#         results.append({
#             "id": item.id,
#             "disease": item.disease,
#             "is_lemon_leaf": item.is_lemon_leaf,
#             "confidence": item.confidence,
#             "treatment": item.treatment,
#             "created_at": item.created_at
#         })

#     return JsonResponse({
#         "count": len(results),
#         "results": results

#     }) 

from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

import numpy as np
from PIL import Image
import io
import json

from ml.pipeline.predict import leaf_model, disease_model, class_names
from .models import PredictionHistory
from .services import get_treatment


# ── Safe Image Preprocessor ───────────────────────────────────────
def preprocess_image(image_file):
    """
    Safely preprocess any uploaded image.
    Fixes: grayscale, RGBA, palette, corrupted resize artifacts.
    Works with images from Google, camera, gallery, any source.
    """
    # Read image bytes
    image_bytes = image_file.read()
    
    # Open with PIL
    img = Image.open(io.BytesIO(image_bytes))
    
    # Force RGB — fixes ALL channel issues:
    # grayscale (1ch) → RGB (3ch)
    # RGBA (4ch)      → RGB (3ch)  
    # palette mode    → RGB (3ch)
    # CMYK            → RGB (3ch)
    img = img.convert('RGB')
    
    # Resize to model input size
    img = img.resize((224, 224), Image.LANCZOS)
    
    # Convert to numpy float32 array
    img_array = np.array(img, dtype=np.float32)
    
    # Verify shape — must be (224, 224, 3)
    if img_array.shape != (224, 224, 3):
        raise ValueError(
            f"Image shape error: got {img_array.shape}, "
            f"expected (224, 224, 3)"
        )
    
    # Normalize to [0, 1]
    img_array = img_array / 255.0
    
    # Add batch dimension → (1, 224, 224, 3)
    img_array = np.expand_dims(img_array, axis=0)
    
    return img_array


# ── UI Page ───────────────────────────────────────────────────────
def predict_ui(request):
    return render(request, "index.html")


# ── Prediction API ────────────────────────────────────────────────
@csrf_exempt
def predict_image(request):
    if request.method != "POST":
        return JsonResponse({"error": "Only POST allowed"}, status=405)

    # 1. Get image from request
    image = request.FILES.get("image")
    if not image:
        return JsonResponse({"error": "No image uploaded"}, status=400)

    try:
        # 2. Preprocess image safely
        img_array = preprocess_image(image)

        # 3. Leaf detection
        leaf_pred = leaf_model.predict(img_array)
        leaf_confidence = float(leaf_pred[0][0])
        print(f"Leaf confidence: {leaf_confidence}")

        # If confidence <0.5 → NOT a lemon leaf
        if leaf_confidence < 0.5:
            return JsonResponse({
                "result": "Not a lemon leaf"
            })

        # 4. Disease prediction
        disease_pred    = disease_model.predict(img_array)
        class_index     = int(np.argmax(disease_pred))
        confidence      = float(np.max(disease_pred))
        disease         = class_names[class_index].strip()
        print(f"Predicted disease: {disease}")

        # 5. Get treatment in both EN + NP
        treatment = get_treatment(disease)

        # 6. Save to history
        PredictionHistory.objects.create(
            disease=disease,
            is_lemon_leaf=True,
            confidence=confidence,
            treatment=json.dumps(treatment)
        )

        # 7. Return response
        return JsonResponse({
            "result":     "Lemon Leaf Detected",
            "disease":    disease,
            "confidence": confidence,
            "treatment":  treatment
        })

    except ValueError as e:
        print(f"Image preprocessing error: {e}")
        return JsonResponse({
            "error": f"Image format error: {str(e)}"
        }, status=400)

    except Exception as e:
        print(f"Prediction error: {e}")
        return JsonResponse({
            "error": f"Prediction failed: {str(e)}"
        }, status=500)


# ── Health Check ──────────────────────────────────────────────────
def health(request):
    return JsonResponse({
        "status":        "ok",
        "leaf_model":    "loaded",
        "disease_model": "loaded"
    })


# ── Classes API ───────────────────────────────────────────────────
def classes(request):
    return JsonResponse({
        "leaf_classes": [
            "lemon_leaf",
            "not_lemon_leaf"
        ],
        "disease_classes": class_names
    })


# ── History API ───────────────────────────────────────────────────
def history(request):
    data    = PredictionHistory.objects.all().order_by("-created_at")
    results = []

    for item in data:
        results.append({
            "id":           item.id,
            "disease":      item.disease,
            "is_lemon_leaf": item.is_lemon_leaf,
            "confidence":   item.confidence,
            "treatment":    item.treatment,
            "created_at":   str(item.created_at)
        })

    return JsonResponse({
        "count":   len(results),
        "results": results
    })

