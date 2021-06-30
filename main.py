#! /usr/bin/env python3
from googletrans import Translator
import sqlite3 as sq
import click


translator = Translator()

def insertToDB(fr_words, en_words, wordRefURLs):
    fr_con = sq.connect('data/frenchinator.db')
    cur = fr_con.cursor()
    for fr_word,en_word,wordRefURL in zip(fr_words,en_words,wordRefURLs):
        cur.execute("UPDATE words SET count = count + 1 WHERE fr_word = ?", [fr_word])
        if cur.rowcount == 0:
            cur.execute("INSERT INTO words VALUES(?,?,?,1) ", (fr_word, en_word, wordRefURL))
    fr_con.commit()
    fr_con.close()

def translateCLI():
    fr_word = input("huh: ")
    fr_words = []
    en_words = []
    wordRefURLs = []
    while fr_word != "n":
        en_response = translator.translate(fr_word, src="fr", dest="en")
        en_word = en_response.text
        print(f"Google Translation: {en_word}")
        wordRefURL = f"https://www.wordreference.com/fren/{fr_word}"
        print(wordRefURL)
        fr_words.append(fr_word)
        en_words.append(en_word)
        wordRefURLs.append(wordRefURL)
        fr_word = input("huh: ")
    insertToDB(fr_words, en_words, wordRefURLs)


def journalUI():
    text_edit = pyqt5.QPlainTextEdit()

@click.command()
@click.option("--translate", '-t', is_flag=True)
@click.option("--journal", '-j', is_flag=True)
def main(translate, journal):
    if translate == 1:
        translateCLI()
    elif journal == 1:
        journalUI()

if __name__ == "__main__":
    main()