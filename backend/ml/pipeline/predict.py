import os
from django.conf import settings
from tensorflow.keras.models import load_model

MODEL_DIR = os.path.join(settings.BASE_DIR, "ml", "models")

<<<<<<< HEAD
leaf_model = load_model(os.path.join(MODEL_DIR, "leaf_detector_model.keras"))
=======
leaf_model = load_model(os.path.join(MODEL_DIR, "mobilenetv2_model1.keras"))
>>>>>>> 6640eb99dbb04553d8e1b6e19c189b5b1d4f964d
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
<<<<<<< HEAD
]
=======
] 



>>>>>>> 6640eb99dbb04553d8e1b6e19c189b5b1d4f964d
