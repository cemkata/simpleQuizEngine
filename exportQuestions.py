# -*- coding: utf-8 -*-
from importQuestionsHelper import proccesFile, saveFile
from config import examFolder
import re
import os

cwd = os.getcwd()
examFolder = os.path.join(cwd, examFolder)

def process_input(coiceList, msg = 'coice'):
    for idx, c in enumerate(coiceList):
        print(idx+1,"-", c)
    coice = int(input(f"{msg}: ")) -1
    while (coice > len(coiceList)-1 or coice < 0):
        print(f"wrong {msg}")
        coice = int(input(f"{msg}: ")) -1
    return coice

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

def main():
    dir_list = os.listdir(examFolder)
    cource = process_input(dir_list)

    nextExamFolder = os.path.join(examFolder, dir_list[cource])
    file_list = os.listdir(nextExamFolder)

    exam = process_input(file_list)
     
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
    
    outFileName = os.path.join(nextExamFolder, file_list[exam])
    exportQuestions(outFileName, exportedQuestionsList)
    
    print("Done!")
    print(f"File is: {outFileName}")
    input("Done press enter...")
if __name__ == '__main__':
    main()
