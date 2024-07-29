# -*- coding: utf-8 -*-
from bottle import Bottle, request, redirect, template, static_file
from importQuestionsHelper import proccesFile, saveFile
import os
from config import * # App config is loaded here
import json
ver = '1.14'

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
        redirect("/start?courseID=.&examID="+courseID)
    
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

@app.route('/editor/')
def editor_index():
    return template('index.tpl', items = os.listdir(examFolder), comand = 3) #comand 3 shows the dump folders

@app.route('/editor/showDumps')
def editor_show_dumps():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/")
    dumpFolder = os.path.join(examFolder, courseID)
    
    if not os.path.exists(dumpFolder):
        return ""
    try:
        return template('index.tpl', items = os.listdir(dumpFolder), comand = 4, cid = courseID) #comand 4 shows the dump in given folder
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
    return template('showquestions.tpl', questions = q_list['dump'], comand = 4, cid = courseID, dump = examID) #comand 4 shows the dump in given folder
       
    return proccesFile(os.path.join(examFolder, courseID, examID))
    
@app.route('/editor/editQuestion')
def CardEditor():
    #ncourseID=course_name&quizID=0&cardID=1
    courseID = request.query.courseID
    quizID = request.query.quizID
    questionID = int(request.query.questionID)
    if questionID == -1:
        targetQuestion = {'explanation': '','referenceLink':'',\
            'question': '', 'correctAnswer': '', 'answers': {}}
    else:
        dump_file = proccesFile(os.path.join(examFolder, courseID, quizID))
        for i in range(len(dump_file["dump"])):
            if dump_file["dump"][i]["id"] == questionID:
                targetQuestion = {'explanation': dump_file["dump"][i]['explanation'],\
                'referenceLink':dump_file["dump"][i]['referenceLink'],\
                'question': dump_file["dump"][i]['question'],\
                'correctAnswer': dump_file["dump"][i]['correctAnswer'],\
                'answers': dump_file["dump"][i]['answers']}
    return template('question_editor.tpl', questionID = questionID, \
        courseID = courseID, quizID=quizID, questionContent = targetQuestion)

@app.route('/editor/saveQuestion', method='POST')
def SaveQuestion():
    courseID = request.forms.get('courseID')
    questionID =  int(request.forms.get("questionID"))
    quizID = request.forms.get("quizID")
    questionTxt =  request.forms.get("questionTxt")
    explnTxt =  request.forms.get("explnTxt")
    referenceLink =  request.forms.get("referenceLink")
    answers =  json.loads(request.forms.get("answers"))
    correctAnswer =  request.forms.get("correctAnswer")
    dump_file = proccesFile(os.path.join(examFolder, courseID, quizID))
    
    if("$?__" in questionTxt):
        resultingQuestionTxt = []
        for q in questionTxt.split("$?__"):
            q = q.replace("<div>", "")
            q = q.replace("</div>", "")
            if q.startswith("<br>"):
                q = q.replace("<br>", "", 1)
            if q.startswith("</br>"):
                q = q.replace("</br>", "", 1)
            if len(q) == 0:
                continue
            resultingQuestionTxt.append(q+"$?__")
        questionTxt = resultingQuestionTxt
        newCorrectAnswer = []
        for answ in json.loads(correctAnswer):
            if len(answ) != 0:
                newCorrectAnswer.append(answ)
        correctAnswer = newCorrectAnswer
    
    for i in range(len(dump_file["dump"])):
        if dump_file["dump"][i]["id"] == questionID:
            dump_file["dump"][i]['explanation'] = explnTxt
            dump_file["dump"][i]['referenceLink'] = referenceLink
            dump_file["dump"][i]['question'] = questionTxt
            dump_file["dump"][i]['correctAnswer'] = correctAnswer
            dump_file["dump"][i]['answers'] = answers
            saveFile(os.path.join(examFolder, courseID, quizID), dump_file)
            return "Done!"

    i = int(dump_file["lastID"])
    dump_file["dump"].append({})
    if i == len(dump_file["dump"]):
        i = len(dump_file["dump"]) - 1
    dump_file["dump"][i]['explanation'] = explnTxt
    dump_file["dump"][i]['referenceLink'] = referenceLink
    dump_file["dump"][i]['question'] = questionTxt
    dump_file["dump"][i]['correctAnswer'] = correctAnswer
    dump_file["dump"][i]['answers'] = answers
    dump_file["dump"][i]['id'] = i
    dump_file["lastID"] = i + 1
    saveFile(os.path.join(examFolder, courseID, quizID), dump_file)
    return "Done!"

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
            saveFile(os.path.join(examFolder, courseID, quizID), dump_file)
            return "Done!"
    return "Error!"

@app.route('/editor/addcategory')
def addcategory():
    return template("editCourseDeck.tpl", action = "addcategory", name="")
    
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
    return template("editCourseDeck.tpl", action = "editDump", name="", cid = courseID)

@app.route('/editor/editDump')
def editDump():
    courseID = request.query.courseID
    qid = request.query.examID
    return template("editCourseDeck.tpl", action = "editDump", name=qid, quiz_id=qid, cid = courseID)
    
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
    return template("editCourseDeck.tpl", action = "addcategory", name=courseID, cid = courseID)
    
@app.route('/editor/deleteCategory')
def deleteCategory():
    courseID = request.query.courseID or -1
    if courseID == -1:
        redirect("/editor/")
    for f in os.listdir(os.path.join(examFolder, courseID)):
        os.remove(os.path.join(examFolder, courseID, f))
    os.rmdir(os.path.join(examFolder, courseID))
    redirect("/editor/")

def main():
    print("Starting dump wizard "+ str(ver))
    app.run(host = serverAddres, port = serverPort, debug=True)

if __name__ == '__main__':
    main()
