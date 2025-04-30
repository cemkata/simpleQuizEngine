# -*- coding: utf-8 -*-
from bottle import Bottle, request, redirect, template, static_file, abort, ServerAdapter
from importQuestionsHelper import proccesFile, saveFile
import os
from config import serverAddres, serverPort, examFolder, showSelectionPage, webconf # App config is loaded here
from versionGetter import fullVersion
import json

try:
    from paste import httpserver
    from paste.translogger import TransLogger
    PASTE_SERVER = True
except ModuleNotFoundError:
    PASTE_SERVER = False

ver = fullVersion()

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
def new_index():
    if not showSelectionPage:
        redirect("./main/")
    return template('selectionpage')

@app.route('/main/')
def index():
    return template('index', items = [f for f in os.listdir(examFolder) if not os.path.isfile(os.path.join(examFolder, f))], comand = 1) #comand 1 shows the dump folders

@app.route('/main/showDumps')
def show_dumps():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/")
    dumpFolder = os.path.join(examFolder, courseID)

    if not os.path.exists(dumpFolder):
        return ""
    try:
        return template('index', items = [f for f in os.listdir(dumpFolder) if os.path.isfile(os.path.join(dumpFolder, f))], comand = 2, cid = courseID) #comand 2 shows the dump in given folder
    except NotADirectoryError:
        redirect("/start?courseID=.&examID="+courseID)

@app.route('/main/start')
def start_dump():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/")
    examID = request.query.examID or -1
    if examID == -1:
        redirect("/") 
    return template('start', cid = courseID, dump = examID, page_config = webconf)

@app.route('/main/get')
def get_json_dump():
    courseID = request.query.courseID or -1
    if courseID == -1:
        return "404"
    examID = request.query.examID or -1
    if examID == -1:
        return "404"
    fileDownload = request.query.fileDownload or -1
    if fileDownload != -1:
        return static_file(os.path.join(courseID, examID), root=examFolder, download=True)
    return proccesFile(os.path.join(examFolder, courseID, examID))

@app.route('/editor/')
def editor_index():
    return template('index', items = [f for f in os.listdir(examFolder) if not os.path.isfile(os.path.join(examFolder, f))], comand = 3) #comand 3 shows the dump folders

@app.route('/editor/showDumps')
def editor_show_dumps():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/")
    dumpFolder = os.path.join(examFolder, courseID)
    
    if not os.path.exists(dumpFolder):
        return ""
    try:
        return template('index', items = [f for f in os.listdir(dumpFolder) if os.path.isfile(os.path.join(dumpFolder, f))], comand = 4, cid = courseID) #comand 4 shows the dump in given folder
    except NotADirectoryError:
        redirect("/editor/listquestions?courseID=.&examID="+courseID)

@app.route('/editor/listquestions')
def editor_listquestions():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/editor/")
    examID = request.query.examID or -1
    if examID == -1:
        redirect("/editor/") 
    q_list = proccesFile(os.path.join(examFolder, courseID, examID))
    return template('showquestions', questions = q_list['dump'], comand = 4, cid = courseID, dump = examID) #comand 4 shows the dump in given folder

@app.route('/editor/editQuestion')
def questionEditor():
    courseID = request.query.courseID
    quizID = request.query.quizID
    questionID = int(request.query.questionID)
    if questionID == -1:
        targetQuestion = {'explanation': '','referenceLink':'',\
            'question': '', 'correctAnswer': '', 'answers': {}, 'category': ""}
    else:
        dump_file = proccesFile(os.path.join(examFolder, courseID, quizID))
        for i in range(len(dump_file["dump"])):
            if dump_file["dump"][i]["id"] == questionID:
                try:
                    answersGroups = dump_file["dump"][i]['answersGroups']
                except KeyError:
                    answersGroups = None
                try:
                    answersCount = dump_file["dump"][i]['answersCount']
                except KeyError:
                    answersCount = None
                    
                targetQuestion = {'explanation': dump_file["dump"][i]['explanation'],\
                'referenceLink':dump_file["dump"][i]['referenceLink'],\
                'question': dump_file["dump"][i]['question'],\
                'correctAnswer': dump_file["dump"][i]['correctAnswer'],\
                'answers': dump_file["dump"][i]['answers'],
                'answersGroups': answersGroups,
                'answersCount': answersCount,
                'category': dump_file["dump"][i]['category']}
    return template('question_editor', questionID = questionID, \
        courseID = courseID, quizID=quizID, questionContent = targetQuestion)

@app.route('/editor/saveQuestion', method='POST')
def SaveQuestion():
    courseID = request.forms.get('courseID')
    questionID = int(request.forms.get("questionID"))
    quizID = request.forms.get("quizID")
    questionTxt = request.forms.get("questionTxt")
    questionCat = int(request.forms.get("questionCat"))
    explnTxt = request.forms.get("explnTxt")
    referenceLink = request.forms.get("referenceLink")
    answers = json.loads(request.forms.get("answers"))
    correctAnswer = request.forms.get("correctAnswer")
    answersGroups = request.forms.get("answers_grp") or False
    answersCount = request.forms.get("answers_cnt") or False

    dump_file = proccesFile(os.path.join(examFolder, courseID, quizID))

    if questionCat == 0:
        # 0 = Free text
        pass
    elif  questionCat == 1:
        # 1 = Single choice
        pass
    elif  questionCat == 2:
        # 2 = Multiple chioce
        pass
    elif  questionCat == 3:
        # 3 = Drag-drop
    #if "$?__" in questionTxt:
        resultingQuestionTxt = []
        removeDivStrings = ["<div>", "</div>"]
        #NEW method
        for q in questionTxt.split(removeDivStrings[1]):
            q = q.replace(removeDivStrings[0], "")
            resultingQuestionTxt.append(q)
        ##OLD method
        #removeDivBr = ["<br>", "</br>"]
        #for q in questionTxt.split("$?__"): 
        #    for htmlElm in removeDivStrings:
        #        q = q.replace(htmlElm, "")
        #    for htmlElm in removeDivBr:
        #        if q.startswith(htmlElm):
        #            q = q.replace(htmlElm, "", 1)
        #    if len(q) == 0:
        #        q = removeDivBr[0]
        #    else:
        #        resultingQuestionTxt.append(q+"$?__")
        #    resultingQuestionTxt.append(q+"$?__")
        questionTxt = resultingQuestionTxt
        newCorrectAnswer = []
        for answ in json.loads(correctAnswer):
            if len(answ) != 0:
                newCorrectAnswer.append(answ)
        if len(newCorrectAnswer) == 0:
            newCorrectAnswer.append("  ")
        correctAnswer = newCorrectAnswer
    else:
        pass
        # 5 and more futur use

    for i in range(len(dump_file["dump"])):
        if dump_file["dump"][i]["id"] == questionID:
            dump_file["dump"][i]['explanation'] = explnTxt
            dump_file["dump"][i]['referenceLink'] = referenceLink
            dump_file["dump"][i]['question'] = questionTxt
            dump_file["dump"][i]['category'] = questionCat
            dump_file["dump"][i]['correctAnswer'] = correctAnswer
            dump_file["dump"][i]['answers'] = answers
            if answersGroups:
                dump_file["dump"][i]['answersGroups'] = json.loads(answersGroups)
            if answersCount:
                dump_file["dump"][i]['answersCount'] = json.loads(answersCount)
            return saveFile(os.path.join(examFolder, courseID, quizID), dump_file)

    i = int(dump_file["lastID"])
    dump_file["dump"].append({})
    if i == len(dump_file["dump"]):
        i = len(dump_file["dump"]) - 1
    dump_file["dump"][i]['explanation'] = explnTxt
    dump_file["dump"][i]['referenceLink'] = referenceLink
    dump_file["dump"][i]['question'] = questionTxt
    dump_file["dump"][i]['category'] = questionCat
    dump_file["dump"][i]['correctAnswer'] = correctAnswer
    dump_file["dump"][i]['answers'] = answers
    if answersGroups:
        dump_file["dump"][i]['answersGroups'] = json.loads(answersGroups)
    if answersCount:
        dump_file["dump"][i]['answersCount'] = json.loads(answersCount)
    dump_file["dump"][i]['id'] = i
    dump_file["lastID"] = i + 1
    return saveFile(os.path.join(examFolder, courseID, quizID), dump_file)

@app.route('/editor/deleteQuestion')
def deleteQuestion():
    courseID = request.query.courseID
    quizID = request.query.quizID
    questionID = int(request.query.questionID)
    dump_file = proccesFile(os.path.join(examFolder, courseID, quizID))
    for i in range(len(dump_file["dump"])):
        if dump_file["dump"][i]["id"] == questionID:
            _ = dump_file["dump"].pop(i)
            for j in range(i, len(dump_file["dump"])):
                dump_file["dump"][j]["id"] = dump_file["dump"][j]["id"] - 1
            dump_file["lastID"] = dump_file["lastID"] - 1
            return saveFile(os.path.join(examFolder, courseID, quizID), dump_file)
    return "Error!"

@app.route('/editor/addcategory')
def addcategory():
    return template("editCourseDeck", action = "addcategory", name="")

@app.route('/editor/addcategory', method="POST")
def addcategory_process_post():
    courseID = request.forms.get('cid') or False
    courseName = request.forms.get('name')
    if not courseID:
        os.mkdir(os.path.join(examFolder, courseName))
    else:
        os.rename(os.path.join(examFolder, courseID),\
                  os.path.join(examFolder, courseName))
    redirect("/editor/")

@app.route('/editor/addquiz')
def addDump():
    courseID = request.query.courseID
    return template("editCourseDeck", action = "editDump", name="", cid = courseID)

@app.route('/editor/editDump')
def editDump():
    courseID = request.query.courseID
    qid = request.query.examID
    return template("editCourseDeck", action = "editDump", name=qid, quiz_id=qid, cid = courseID)
    
@app.route('/editor/editDump', method="POST")
def editDump_process_post():
    courseID = request.forms.get('cid') or False
    oldName = request.forms.get('qid') or False
    newName = request.forms.get('name') or False
    if not courseID:
        redirect("/editor/")
    if not oldName:
        if not os.path.isfile(os.path.join(examFolder, courseID, newName)):
            with open(os.path.join(examFolder, courseID, newName), "w") as f:
                f.write("""{"dump": [], "lastID": 0}""")
    else:
        os.rename(os.path.join(examFolder, courseID, oldName),\
                  os.path.join(examFolder, courseID, newName))
    redirect("/editor/showDumps?courseID="+courseID)

@app.route('/editor/deleteDump')
def deleteDump():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/editor/")
    examID = request.query.examID or -1
    if examID == -1:
        redirect("/editor/" + courseID + "/")
    os.remove(os.path.join(examFolder, courseID, examID))
    redirect("/editor/showDumps?courseID=" + courseID)

@app.route('/editor/editCategory')
def editCategory():
    courseID = request.query.courseID
    return template("editCourseDeck", action = "addcategory", name=courseID, cid = courseID)
    
@app.route('/editor/deleteCategory')
def deleteCategory():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/editor/")
    for f in os.listdir(os.path.join(examFolder, courseID)):
        os.remove(os.path.join(examFolder, courseID, f))
    os.rmdir(os.path.join(examFolder, courseID))
    redirect("/editor/")

@app.route('/editor/importFile', method="POST")
def uploadFile():
    courseID = request.forms.get('courseID') or False
    if not courseID:
        abort(401, "Sorry, access denied.")
    uploadedFile = request.files.get('file') or False
    if not uploadedFile:
        abort(401, "Sorry, access denied.")
    save_path = os.path.join(examFolder, courseID)
    try:
        if os.path.isfile(os.path.join(save_path, uploadedFile.filename)):
            abort(500, "File exist!")
        else:
            uploadedFile.save(save_path)
    except:
            abort(500, "Server error.")
    return 'OK'

class MyWSGIRefServer(ServerAdapter):
    def run(self, handler):
        handler = TransLogger(handler, setup_console_handler = (not self.quiet))
        httpserver.serve(handler,
                         host = self.host,
                         port=str(self.port), **self.options)
    def stop(self):
        pass
    def __repr__(self):
        return "PasteServer()"

def main():
    print("Starting dump wizard "+ str(ver))
    print(f"Home page   {serverAddres}:{serverPort}/")
    print(f"Quiz page   {serverAddres}:{serverPort}/main/")
    print(f"Quiz editor {serverAddres}:{serverPort}/editor/")

    if PASTE_SERVER:
        server_custom = MyWSGIRefServer(host=serverAddres, port=serverPort)
        app.run(server = server_custom, debug=True)
    else:
        app.run(host = serverAddres, port = serverPort, debug=True)

if __name__ == '__main__':
    main()
    
