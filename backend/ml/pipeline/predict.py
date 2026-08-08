import os
from django.conf import settings
from tensorflow.keras.models import load_model

MODEL_DIR = os.path.join(settings.BASE_DIR, "ml", "models")

leaf_model = load_model(os.path.join(MODEL_DIR, "mobilenetv2_model1.keras"))
disease_model = load_model(os.path.join(MODEL_DIR, "lemon_disease_model.keras"))

class_names = [
    'Anthracnose',
    'Bacterial Blight',
    'Citrus Canker',
    'Curl Virus',
    'Deficiency Leaf',
    'Dry Leaf',
    'Healthy Leaf',
    'Sooty Mould',
    'Spider Mites'
] 



