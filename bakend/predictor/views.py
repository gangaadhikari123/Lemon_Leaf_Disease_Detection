from django.shortcuts import render

# Create your views here.
# predictor/views.py
import io
import numpy as np
from PIL import Image
from .treatments import get_treatment


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser
from rest_framework import status

from .models import PredictionRecord
from .serializers import PredictionSerializer

# ML predictor — loaded once when Django starts
predictor = None

def get_predictor():
    """Lazy-load the predictor (only when first request comes in)."""
    global predictor
    if predictor is None:
        try:
            from ml.pipeline.predict import LemonDiseasePredictor
            predictor = LemonDiseasePredictor()
        except Exception as e:
            print(f"⚠ Could not load models: {e}")
    return predictor


class PredictView(APIView):
    """POST /api/predict/ — upload image, get disease prediction."""
    parser_classes = [MultiPartParser]

    def post(self, request):
        if 'image' not in request.FILES:
            return Response(
                {'error': 'No image uploaded. Send image as form-data key "image".'},
                status=status.HTTP_400_BAD_REQUEST
            )

        image_file = request.FILES['image']
        p = get_predictor()

        if p is None:
            return Response(
                {'error': 'ML models not loaded. Train models first.'},
                status=status.HTTP_503_SERVICE_UNAVAILABLE
            )

        # Convert uploaded file to numpy array
        img = Image.open(image_file).convert('RGB')
        img_array = np.array(img)

        # Run prediction
        result = p.predict_from_array(img_array)

        # Run prediction
        result = p.predict_from_array(img_array)

        # determine language and treatment for this prediction
        lang = request.data.get('language', 'en')
        treatment = get_treatment(result['final_label'], lang) if result['is_lemon_leaf'] else None

        # Save to database
        record = PredictionRecord.objects.create(
            stage1_conf  = result['stage1']['confidence'],
            stage2_class = result['stage2']['predicted_class'] if result['stage2'] else None,
            stage2_conf  = result['stage2']['confidence']      if result['stage2'] else None,
            final_label  = result['final_label'],
            message      = result['message'],
        )

        return Response({
            'id':           record.id,
            'is_lemon':     result['is_lemon_leaf'],
            'final_label':  result['final_label'],
            'confidence':   result['confidence'],
            'message':      result['message'],
            'stage1':       result['stage1'],
            'stage2':       result['stage2'],
            'treatment':    treatment,
        }, status=status.HTTP_200_OK)


class HealthView(APIView):
    """GET /api/health/ — check if server and models are ready."""

    def get(self, request):
        from pathlib import Path
        from ml.utils.config import CFG
        return Response({
            'server':       'ok',
            'stage1_model': Path(CFG.STAGE1_MODEL_PATH).exists(),
            'stage2_model': Path(CFG.STAGE2_MODEL_PATH).exists(),
        })


class ClassesView(APIView):
    """GET /api/classes/ — list all class names."""

    def get(self, request):
        from ml.utils.config import CFG
        return Response({
            'stage1_classes': CFG.STAGE1_CLASSES,
            'stage2_classes': CFG.STAGE2_CLASSES,
        })


class HistoryView(APIView):
    """GET /api/history/ — list all past predictions."""

    def get(self, request):
        records = PredictionRecord.objects.all()[:50]
        serializer = PredictionSerializer(records, many=True)
        return Response(serializer.data)