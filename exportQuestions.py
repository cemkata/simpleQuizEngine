# -*- coding: utf-8 -*-
from importQuestions import proccesFile
from config import examFolder
import re
import os

cwd = os.getcwd()
examFolder = os.path.join(cwd, examFolder)

def get_json_dump(courseID, examID):
     if not courseID or not examID:
         exit()
     return proccesFile(os.path.join(examFolder, courseID, examID)).replace('\"', '\\"').replace('`', '\\`')

def process_input(coiceList, msg = 'coice'):
    for idx, c in enumerate(coiceList):
        print(idx+1,"-", c)
    coice = int(input(f"{msg}: ")) -1
    while (coice > len(coiceList)-1 or coice < 0):
        print(f"wrong {msg}")
        coice = int(input(f"{msg}: ")) -1
    return coice

def getQuestions_numbers():
    done = True
    questionList =[]
    print('To end the input of values type EOF')
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

def exportQuestions(fileName, questionsID):
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

    for i in questionsID:
        questions.append(questionsStrings[i-1])

    with open(f'{fileName}_exported.txt' , "w", encoding="Utf-8") as f:
        f.write(info)
        for k in range(len(questions)):
            q = questions[k]
            i = questionsID[k]
        #for i, q in enumerate(questions):
            f.write('QUESTION ' + str(i))
            #f.write('\r\n')
            f.write(q)
            #f.write('\r\n')

def main():
    dir_list = os.listdir(examFolder)
    cource = process_input(dir_list)

    nextExamFolder = os.path.join(examFolder, dir_list[cource])
    file_list = os.listdir(nextExamFolder)

    exam = process_input(file_list)

    exportedQuestionsList = getQuestions_numbers()
    
    outFileName = os.path.join(nextExamFolder, file_list[exam])
    exportQuestions(outFileName, exportedQuestionsList)
    
    print("Done!")
    print(f"File is: {outFileName}")

if __name__ == '__main__':
    main()
