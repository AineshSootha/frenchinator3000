#! /usr/bin/env python3
from googletrans import Translator
import sqlite3 as sq
import click
from flask import Flask
from flask_restful import Resource, Api, reqparse
import json

app = Flask(__name__)
api = Api(app)

translator = Translator()

class Translate(Resource):
    def get(self):
        return
    
    def post(self):
        parser = reqparse.RequestParser() 
        parser.add_argument('word', required=True)
        args = parser.parse_args() 
        response = self.translate(args['word'])
        translated = json.loads(response)
        print(translated)
        return translated
    
    def insertToDB(self, fr_words, en_words, wordRefURLs):
        fr_con = sq.connect('data/frenchinator.db')
        cur = fr_con.cursor()
        for fr_word,en_word,wordRefURL in zip(fr_words,en_words,wordRefURLs):
            cur.execute("UPDATE words SET count = count + 1 WHERE fr_word = ?", [fr_word])
            if cur.rowcount == 0:
                cur.execute("INSERT INTO words VALUES(?,?,?,1) ", (fr_word, en_word, wordRefURL))
        fr_con.commit()
        fr_con.close()
    
    def translateCLI(self):
        fr_word = input("huh: ")
        fr_words = []
        en_words = []
        wordRefURLs = []
        while fr_word != "n":
            translateResponse = self.translate(fr_word)
            fr_word = input("huh: ")
            translated = json.loads(translateResponse)
            print(f"Translation: {translated['en']}")
            print(f"Word Ref: {translated['wordRefURL']}")
            fr_words.append(fr_word)
            en_words.append(translated['en'])
            wordRefURLs.append(translated['wordRefURL'])

    def translate(self, fr_word):
        en_response = translator.translate(fr_word, src="fr", dest="en")
        en_word = en_response.text
        print(f"Google Translation: {en_word}")
        wordRefURL = f"https://www.wordreference.com/fren/{fr_word}"
        self.insertToDB(fr_word, en_word, wordRefURL)
        responseDict = {'en': en_word, 'wordRefURL': wordRefURL}
        return json.dumps(responseDict)

class Journal(Resource):
    def get(self):
        return
    
    def post(self):
        return

api.add_resource(Translate, '/translate')
api.add_resource(Journal, '/journal')







def journalUI():
    journal()

@click.command()
@click.option("--translate", '-t', is_flag=True)
@click.option("--journal", '-j', is_flag=True)
def main(translate, journal):
    if translate == 1:
        translate = Translate()
        translate.translateCLI()
    elif journal == 1:
        journalUI()

if __name__ == "__main__":
    app.run()