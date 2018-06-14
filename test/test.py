import unittest
import os
import sys

if os.path.exists('../src'):
    sys.path.append('../src')

if os.path.exists('../keras-yolo3'):
    sys.path.append('../keras-yolo3')

from twitter import process_tweet
from yolo import YOLO
import json

MODEL_DATA_DIR="../keras-yolo3/model_data"
FONT_DIR="../keras-yolo3/font"

class Test(unittest.TestCase):

    def test_elephant_tweet(self):
        yolo = YOLO(MODEL_DATA_DIR, FONT_DIR)

        with open('data/tweets/1006916974662725635.json') as f:
            data = json.load(f)
        source_img, result_img, result_meta = process_tweet(data, yolo)
        print(result_meta)
        #result_img.show()
        self.assertTrue("elephant" in str(result_meta))

    def test_person_tweet(self):
        yolo = YOLO(MODEL_DATA_DIR, FONT_DIR)
        with open('data/tweets/1006918108575981568.json') as f:
            data = json.load(f)
        source_img, result_img, result_meta = process_tweet(data, yolo)
        print(result_meta)
        #result_img.show()
        self.assertTrue("person" in str(result_meta) and "cell phone" in str(result_meta))


if __name__ == '__main__':
    unittest.main()
