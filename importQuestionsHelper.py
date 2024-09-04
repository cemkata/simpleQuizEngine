# -*- coding: utf-8 -*-
import json
import re
from json.decoder import JSONDecodeError
try:
  import cPickle as pickle
except:
  import pickle

from config import usePickle

_JSON = 0
_PKL =  1


if usePickle:
    _DEFAULT_TYPE = _PKL
else:
    _DEFAULT_TYPE = _JSON

def proccesFile(fileName):
    try:
        with open(fileName, "r", encoding="Utf-8") as f:
            data = json.load(f)
        return data
    except JSONDecodeError as e:
        return proccesOldTypeFile(fileName)
    except UnicodeDecodeError as e:
        return proccesFile_pkl(fileName)

def proccesFile_pkl(fileName):
    try:
        with open(fileName, "rb") as f:
            data = pickle.load(f)
        return data
    except UnpicklingError as e:
        return '''{"dump": [], "lastID": 0}'''

def saveFile(fileName, data, save_file_type = _DEFAULT_TYPE):
    if save_file_type == _JSON:
        saveFile_json(fileName, data)
    elif save_file_type == _PKL:
        saveFile_pkl(fileName, data)
    else:
        pass #FUTURE use

def saveFile_pkl(fileName, data):
    with open(fileName, "wb") as f:
        pickle.dump(data, f)    

def saveFile_json(fileName, data):
    with open(fileName, "w", encoding="Utf-8") as f:
        json.dump(data, f, ensure_ascii=False)

def proccesOldTypeFile(fileName):
    with open(fileName, "r", encoding="Utf-8") as f:
         s = f.read()
    s = s.replace('''“''','''"''')
    s = s.replace('''”''','''"''')
    s = s.replace('''‘''',"'")
    s = s.replace('''‘''',"'")
    s = s.replace('''–''',"-")
    questionsStrings = re.split('QUESTION \d+', s)

    info = questionsStrings.pop(0)

    questions = []
    i = 0
    for q in questionsStrings:
        lines = q.splitlines()
        tmpDict = {}
        answers = {}
        tmpDict['explanation'] = ''
        tmpDict['question'] = ''
        tmpDict['id'] = i #new
        tmpDict['referenceLink'] = "" #new
        i += 1 #new
        qestionTextDone = True
        answerTextDone = True
        explanationTextDone = True
        questionAnsr = ''
        for i in range(len(lines)):
            try:
                if len(lines[i]) < 3:
                    continue
                #print(lines[i])
                if lines[i].startswith("Explanation/Reference") or lines[i].startswith("Section:") or lines[i].startswith("Explanation") or lines[i].startswith("Reference:"):
                    answerTextDone = False
                    if lines[i].startswith("Reference:"):
                       link = lines[i].split(":", 1)[1]
                       if link.startswith(" "):
                           link = link.replace(" ", '', 1)
                       #link = lines[i].split()[1]
                       if link.startswith("http"):
                          tmpDict['explanation'] += f'''<p>Reference:</p><a href="{link}"  target="_blank">link</a>'''
                       else:
                          tmpDict['explanation'] += lines[i] + "</br>"
                    else:
                       tmpDict['explanation'] += lines[i] + "</br>"
                elif lines[i].startswith("Correct Answer:"):
                    ##tmpDict['correctAnswer'] = lines[i].replace("Correct Answer: ", '')
                    tmpDict['correctAnswer'] = "" #new
                    for c in lines[i].replace("Correct Answer: ", ''): #new
                        tmpDict['correctAnswer'] += str(ord(c)%65) #new
                elif lines[i].startswith("Answer: "):
                    tmpDict['correctAnswer'] = lines[i].replace("Answer: ", '')
                elif lines[i][1].lower() == '.' and lines[i][2].lower() == ' ' and answerTextDone: # answers
                    qestionTextDone = False
                    ##questionAnsr = lines[i][0]
                    questionAnsr = str(ord(lines[i][0])%65) #new
                    answers[questionAnsr] = lines[i]
                else:
                    if qestionTextDone:
                        tmpDict['question'] += lines[i] + "</br>"
                    elif answerTextDone:
                        answers[questionAnsr] += "</br>" + lines[i]
                    else:
                        tmpDict['explanation'] += lines[i] + "</br>"
            except Exception as e:
                print("\nProblem with question:\n=========================\n\n")
                print(q)
                print(f"\nProblem with Line: {i}\n=========================\n\n")
                raise e                
                    
        tmpDict['answers'] = answers.copy()
        questions.append(tmpDict.copy())

    return {'dump':questions, 'lastID': len(questions)}
