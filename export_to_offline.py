# -*- coding: utf-8 -*-
from bottle import template
from importQuestions import proccesFile
from config import examFolder
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

def main():
    dir_list = os.listdir(examFolder)
    cource = process_input(dir_list)

    nextExamFolder = os.path.join(examFolder, dir_list[cource])
    file_list = os.listdir(nextExamFolder)

    exam = process_input(file_list)
    
    text = template('quiz', json_Output = \
                    get_json_dump(dir_list[cource], file_list[exam]),\
                    tittle = f'{dir_list[cource]}_{file_list[exam]}')

    outputFolder = os.path.join(cwd, "html_output")
    if not os.path.exists(outputFolder):
       # Create a new directory because it does not exist
       os.makedirs(outputFolder)

    outFileName = os.path.join(outputFolder, f'result_{dir_list[cource]}_{file_list[exam]}.html')
    with open(outFileName, mode='w', encoding='utf-8') as f:
        f.write(text)
        
    print("Done!")
    print(f"File is: {outFileName}")

if __name__ == '__main__':
    main()
