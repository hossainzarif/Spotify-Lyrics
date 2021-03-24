import sys
import spotipy
import spotipy.util as util
import requests
from Config.config import USERNAME, SPOTIPY_CLIENT_ID, SPOTIPY_CLIENT_SECRET, SPOTIPY_REDIRECT_URI
from bs4 import BeautifulSoup
import time


scope = 'user-read-currently-playing'

token = spotipy.util.prompt_for_user_token(
    USERNAME, scope, client_id=SPOTIPY_CLIENT_ID, client_secret=SPOTIPY_CLIENT_SECRET, redirect_uri=SPOTIPY_REDIRECT_URI
)


def sing():

    if token:
        # Create a Spotify() instance with our token
        sp = spotipy.Spotify(auth=token)

        # method currently playing return an actual song on Spotify
        current_song = sp.currently_playing()

        if(current_song is not None):

            # Extract artist from json response
            artist = current_song['item']['artists'][0]['name']

            # Extract song name from json response
            song_name = current_song['item']['name']

            # create a valid url for web scrapping using song name and artist
            song_url = '{}-{}-lyrics'.format(str(artist).strip().replace(' ', '-'),
                                        str(song_name).strip().replace(' ', '-'))

           # print('\nSong: {}\nArtist: {}'.format(song_name, artist))
            return (song_url, (current_song['item']['duration_ms'] - current_song['progress_ms']) / 1000)
        else:
            print("Play Song for lyrics")
            return "None",0

    else:
        print("Can't get token for")


# def sing():

#     if token:
#         # Create a Spotify() instance with our token
#         sp = spotipy.Spotify(auth=token)

#         # method currently playing return an actual song on Spotify
#         current_song = sp.currently_playing()

#         # Extract artist from json response
#         artist = current_song['item']['artists'][0]['name']
#         # Extract song name from json response
#         song_name = current_song['item']['name']

#         # create a valid url for web scrapping using song name and artist
#         song_url = '{}-{}-lyrics'.format(str(artist).strip().replace(' ', '-'),
#                                         str(song_name).strip().replace(' ', '-'))
        
#         print('\nSong: {}\nArtist: {}'.format(song_name, artist))

#     else:
#         print("Can't get token for")

#     return (song_url , (current_song['item']['duration_ms'] - current_song['progress_ms']) / 1000)


def notation(raw_song_name):

    song_notations = []
    
    # needed for a proper url extention

    # make & 'and'
    raw_song_name.replace('&' , 'and')

    # make ' fill in the gap ----------------------------------------------------------------------- # FIXME: not working can't remove the single quote
    raw_song_name.replace("'" , "")
    song_notations.append(raw_song_name)

    # make '---'  slice of what is left
    dashindexs = raw_song_name.find('---')
    song_notations.append(raw_song_name[:dashindexs + 1])

    return song_notations


def lyricsrequest(raw_names):
    
    # try different servers so you dont get blacklisted
    search_places = ['genius.com']


            # New request using song_url created before
    request = requests.get(f"https://{search_places[0]}/{raw_names[0]}")

            # Verify status_code of request
    if request.status_code == 200:
                
                # BeautifulSoup library return an html code
        html_code = BeautifulSoup(request.text, features="html.parser")

                    

                    # Extract lyrics from beautifulsoup response using the correct prefix {"class": "lyrics"}
        lyrics=""          
        if html_code.find("div", {"class": "lyrics"}) is not None:
            lyrics = html_code.find("div", {"class": "lyrics"}).get_text()

        print(lyrics)



    else:
        print("Sorry, I can't find the actual lyrics on this request")


if __name__ == "__main__":
    chk = "NONE"
    while True:

        raw_song_name , wait = sing()
        #print(raw_song_name)
        print(chk)
        if(raw_song_name != "None" and chk!= raw_song_name):
            print("entered")
            song_notations = notation(raw_song_name)
            lyricsrequest(song_notations)
        chk = raw_song_name
        print(chk)
        time.sleep(1)  