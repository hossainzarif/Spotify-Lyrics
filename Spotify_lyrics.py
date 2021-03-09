import sys
import spotipy
import spotipy.util as util
import requests
from Config.config import USERNAME, SPOTIPY_CLIENT_ID, SPOTIPY_CLIENT_SECRET, SPOTIPY_REDIRECT_URI
from bs4 import BeautifulSoup


scope = 'user-read-currently-playing'

token = spotipy.util.prompt_for_user_token(
    USERNAME,scope,client_id= SPOTIPY_CLIENT_ID,client_secret= SPOTIPY_CLIENT_SECRET,redirect_uri= SPOTIPY_REDIRECT_URI
)
