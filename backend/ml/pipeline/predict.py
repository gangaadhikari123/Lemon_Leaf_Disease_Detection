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



# import os
# from django.conf import settings
# from tensorflow.keras.models import load_model

# MODEL_DIR = os.path.join(settings.BASE_DIR, "ml", "models")

# LEAF_MODEL_PATH = os.path.join(
#     MODEL_DIR,
#     "leaf_detector_model.keras"
# )

# DISEASE_MODEL_PATH = os.path.join(
#     MODEL_DIR,
#     "lemon_disease_model.keras"
# )

# print("BASE_DIR:", settings.BASE_DIR)
# print("MODEL_DIR:", MODEL_DIR)
# print("Files available:", os.listdir(MODEL_DIR) if os.path.exists(MODEL_DIR) else "Folder not found")
# print("Leaf model exists:", os.path.exists(LEAF_MODEL_PATH))
# print("Disease model exists:", os.path.exists(DISEASE_MODEL_PATH))

# leaf_model = load_model(LEAF_MODEL_PATH)
# disease_model = load_model(DISEASE_MODEL_PATH)

# class_names = [
#     "Anthracnose",
#     "Bacterial Blight",
#     "Citrus Canker",
#     "Curl Virus",
#     "Deficiency Leaf",
#     "Dry Leaf",
#     "Healthy Leaf",
#     "Sooty Mould",
#     "Spider Mites",
# ]