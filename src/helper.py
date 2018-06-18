import io
import os
from PIL import Image

def to_bytearray(image):
    byte_array = io.BytesIO()
    image.save(byte_array, format='PNG')
    return bytearray(byte_array.getvalue())

def create_dir_if_not_exists(dir):
    if not os.path.exists(dir):
                os.makedirs(dir)
