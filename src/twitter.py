import os
import io
import logging
import tweepy
import twitter_secret
import requests
from yolo import YOLO
from PIL import Image


def process_tweet(tweet, yolo):
    print("-==============================-")
    print("Start to process tweet id: " +
                 tweet["id_str"] + " user: " + tweet["user"]["screen_name"])

    # Download image
    print("Downloading: "+tweet['entities']['media'][0]['media_url'])
    response = requests.get(tweet['entities']['media'][0]['media_url'])
    image = Image.open(io.BytesIO(response.content))

    print(" [+] Image downloaded")

    # Process image using yolo
    source_img = image.copy()
    result_image, result_meta = yolo.detect_image(image)

    print(result_meta)
    print(" [+] Image processed")
    print("-==============================-")
    return source_img, result_image, result_meta

# Send a reply to status with image


def reply_tweet(img_file_name, username, message, status_id):
    # Twitter requires all requests to use OAuth for authentication
    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_TOKEN, ACCESS_SECRET)
    api = tweepy.API(auth)

    # Update the authenticated user’s status
    api.update_with_media(img_file_name, status='@{0} {1}'.format(
        username, message), in_reply_to_status_id=status_id)
