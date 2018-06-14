import io
from PIL import Image

def to_bytearray(image):
    byte_array = io.BytesIO()
    image.save(byte_array, format='PNG')
    return bytearray(byte_array.getvalue())
