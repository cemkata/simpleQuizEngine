# -*- coding: utf-8 -*-
from bottle import Bottle, request, redirect, template, static_file
from importQuestions import proccesFile
import os
from config import * # App config is loaded here
import webbrowser
import sys

app = Bottle()

cwd = os.getcwd()
examFolder = os.path.join(cwd, examFolder)

@app.route('/static/<filepath:path>')
def static_content(filepath):
     return static_file(filepath, root='./views/static')

@app.route('/favicon.ico')
def favicon():
    return static_file('icon.png', root='./views/static')


@app.route('/')
def index():
     return template('index.tpl', items = os.listdir(examFolder), comand = 1) #comand 1 shows the dump folders

@app.route('/showDumps')
def show_dumps():
     courseID = request.query.courseID or -1
     if courseID == -1:
        redirect("/")
     dumpFolder = os.path.join(examFolder, courseID)
     
     if not os.path.exists(dumpFolder):
        return ""
     try:
        return template('index.tpl', items = os.listdir(dumpFolder), comand = 2, cid = courseID) #comand 2 shows the dump in given folder
     except NotADirectoryError:
        redirect(f"/start?courseID=.&examID={courseID}")
     
@app.route('/start')
def start_dump():
     courseID = request.query.courseID or -1
     if courseID == -1:
        redirect("/")
     examID = request.query.examID or -1
     if examID == -1:
        redirect("/") 
     return template('start', cid = courseID, dump = examID)

@app.route('/get')
def get_json_dump():
     courseID = request.query.courseID or -1
     if courseID == -1:
        return "404"
     examID = request.query.examID or -1
     if examID == -1:
        return "404"
     return proccesFile(os.path.join(examFolder, courseID, examID))

def main():
    print("Starting dump wizard "+ str(ver))
    skpBrowser = True
    if len(sys.argv) == 2:
         if sys.argv[1] in ['-p', '--portable']:
              skpBrowser = False
    if skpBrowser:
         url = f"http://{serverAddres}:{serverPort}"
         webbrowser.open(url)
    app.run(host = serverAddres, port = serverPort, debug=True)

if __name__ == '__main__':
    main()
