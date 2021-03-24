# This Python file uses the following encoding: utf-8
import sys
import os

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal, QTimer

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

class MainWindow (QObject):
    def __init__(self):
        QObject.__init__(self)
        chk= ""
        self.timer = QTimer()
        self.timer.timeout.connect(lambda: self.sing(chk))


        self.timer.start(1000)



    printSing = Signal(str)
    printLyrics = Signal(str)

    def sing(self,chk):

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
                self.printSing.emit(song_name)

                raw_song_name = song_url

                print(chk)
                if(chk==""):
                    print("entered")

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



                    raw_names = song_notations



                    search_places = ['genius.com']


                            # New request using song_url created before
                    request = requests.get(f"https://{search_places[0]}/{raw_names[0]}")

                            # Verify status_code of request
                    if request.status_code == 200:

                                # BeautifulSoup library return an html code
                        html_code = BeautifulSoup(request.text, features="html.parser")



                                    # Extract lyrics from beautifulsoup response using the correct prefix {"class": "lyrics"}
                        lyrics="-"
                        if html_code.find("div", {"class": "lyrics"}) is not None:
                            lyrics = html_code.find("div", {"class": "lyrics"}).get_text()
                        if lyrics!= "-":
                            self.printLyrics.emit(lyrics)
                    else:
                        print("Sorry, I can't find the actual lyrics on this request")
                        self.printLyrics.emit("Sorry, I can't find the actual lyrics on this")
                if(raw_song_name != chk):
                    print("AWOL")
                    chk = raw_song_name

            else:
                print("Play Song for lyrics")
                self.printSing.emit("Play Song")



        else:
            print("Can't get token  for")






        # try different servers so you dont get blacklisted













if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    main = MainWindow()

    engine.rootContext().setContextProperty("backend", main)
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))





    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
