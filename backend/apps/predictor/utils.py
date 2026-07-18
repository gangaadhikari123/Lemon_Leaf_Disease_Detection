import numpy as np
from tensorflow.keras.preprocessing import image as keras_image
from PIL import Image

def preprocess(img_file):

    # Convert Django uploaded file → PIL Image
    img = Image.open(img_file)
    img = img.resize((224, 224))

    # Convert to array
    img_array = keras_image.img_to_array(img)

    # Normalize
    img_array = np.expand_dims(img_array, axis=0)
    img_array = img_array / 255.0

    return img_array