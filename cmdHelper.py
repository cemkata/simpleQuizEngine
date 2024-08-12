# -*- coding: utf-8 -*-
from bottle import template
from importQuestionsHelper import proccesFile, saveFile
from config import examFolder
import os
import json

ver = 0.5

cwd = os.getcwd()
examFolder = os.path.join(cwd, examFolder)

def process_input(coiceList, msg = 'coice', lastChoise = -1):
    for idx, c in enumerate(coiceList):
        print(idx+1,"-", c)
    coice = input(f"{msg}: ") or lastChoise + 1
    coice = int(coice) -1
    while (coice > len(coiceList)-1 or coice < 0):
        print(f"wrong {msg}")
        coice = int(input(f"{msg}: ")) -1
    return coice

def getDump(examFolder, cource = -1):
    dir_list = os.listdir(examFolder)
    if cource > -1:
        print(f"Last selected folder {cource+1} - {dir_list[cource]}")
        print("Press enter to use old selection")
        cource = process_input(dir_list, lastChoise = cource)
    else:
        cource = process_input(dir_list)

    nextExamFolder = os.path.join(examFolder, dir_list[cource])
    file_list = os.listdir(nextExamFolder)

    exam = process_input(file_list)

    return file_list[exam], nextExamFolder, cource

def getQuestions_selection():
    done = True
    questionList =[]
    print('Input of values separated by , or |')
    print('To end the input of values (separated by , or |) type EOF')
    while done:
        inStr = input(">")
        if(" " in inStr or "," in inStr):
            inStr = inStr.replace(" ", "|").replace(",","|")
            inStr = inStr.split("|")
            print(inStr)
            try:
                questionList = [int(s) for s in inStr if s != '']
                print(questionList)
            except ValueError:
                print(questionList)
                print("The input is not a valid number")

        elif ("EOF" in inStr.upper()):
            return questionList
        else:
            try:
                questionList.append(int(inStr))
            except ValueError:
                print("The input is not a valid number")

def getQuestions_range():
    print('Input range like 1-10')
    while True:
        inStr = input(">")
        if(" " in inStr):
            inStr = inStr.replace(" ", "")

        try:
            tmp = inStr.split("-")
            if(len(tmp) != 2):
                print("Wrong range")
                continue
            begin = int(tmp[0])
            end = int(tmp[1])
            questionList = [s for s in range(begin,end)]
            return questionList
        except ValueError:
            print("The input is not a valid number")

def exportQuestions(fileName, questionsIDs):
    questions = proccesFile(fileName)

    exportedQuestions = []
    dump_file = {"dump":[]}

    i = 0
    for q in questions['dump']:
        if q["id"]+1 in questionsIDs:
            tmp = q.copy()
            tmp['id']=i
            dump_file["dump"].append(tmp)
            i += 1

    dump_file["lastID"] = len(dump_file["dump"])
    saveFile(f'{fileName}_exported', dump_file)

def exportQuestions_main():
    selected_dump_file, nextExamFolder = getDump(examFolder)

    print("Range for exsample question from 1 to 10.")
    print("Selection looks like 1,2,4,5,7,10.")
    print("Do you want range of questions or selection of questions? (r,s)")
    while True:
        answ = input(">>")
        if answ == "r" or answ == "R":
            exportedQuestionsList = getQuestions_range()
            break
        elif answ == "s" or answ == "S":
            exportedQuestionsList = getQuestions_selection()
            break
        else:
            print("Selection can be either 's' or 'r'!")

    outFileName = os.path.join(nextExamFolder, selected_dump_file)
    exportQuestions(outFileName, exportedQuestionsList)

    print("Done!")
    print(f"File is: {outFileName}_exported")
    input("Done press enter...")

def get_json_dump(courseID, examID):
     if not courseID or not examID:
         exit()
     return proccesFile(os.path.join(examFolder, courseID, examID))

def export_to_offline_main():
    selected_dump_file, nextExamFolder = getDump(examFolder)

    nextExamFolder = os.path.basename(nextExamFolder)

    text = template('quiz', json_Output = \
                    get_json_dump(nextExamFolder, selected_dump_file),\
                    tittle = f'{nextExamFolder}_{selected_dump_file}')

    outputFolder = os.path.join(cwd, "html_output")
    if not os.path.exists(outputFolder):
       # Create a new directory because it does not exist
       os.makedirs(outputFolder)

    outFileName = os.path.join(outputFolder, f'result_{nextExamFolder}_{selected_dump_file}.html')
    with open(outFileName, mode='w', encoding='utf-8') as f:
        f.write(text)

    print("Done!")
    print(f"File is: {outFileName}")

def mergeQuestions_main():
    selected_dump_file_a, nextExamFolder_a, selcected_ID = getDump(examFolder)
    selected_dump_file_b, nextExamFolder_b, _ = getDump(examFolder, selcected_ID)

    content_a = get_json_dump(nextExamFolder_a, selected_dump_file_a)
    content_b = get_json_dump(nextExamFolder_b, selected_dump_file_b)

    newDump = {}
    newDump["dump"] = []

    i = 0
    for q in content_a["dump"]:
        q["id"] = i
        newDump["dump"].append(q)
        i += 1

    for q in content_b["dump"]:
        q["id"] = i
        newDump["dump"].append(q)
        i += 1

    newDump["lastID"] = len(newDump["dump"])

    outFileName = os.path.join(nextExamFolder, f'{selected_dump_file_a}_merged')

    saveFile(outFileName, newDump)

    print("Done!")
    print(f"File is: {outFileName}")