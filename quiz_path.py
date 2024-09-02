# -*- coding: utf-8 -*-
from importQuestionsHelper import proccesFile, saveFile
import os
from config import examFolder # App config is loaded here

cwd = os.getcwd()
examFolder = os.path.join(cwd, examFolder)

def patch(courseID, quizID):
    dump_file = proccesFile(os.path.join(examFolder, courseID, quizID))
    for i in range(len(dump_file["dump"])):
        if type(dump_file["dump"][i]['question']) is list:
            answersGroups = []
            for j in range(len(dump_file["dump"][i]['correctAnswer'])):
                answersGroups.append(j)
            dump_file["dump"][i]['answersGroups'] = answersGroups
    saveFile(os.path.join(examFolder, courseID, quizID), dump_file)

if __name__ == '__main__':
    patch("Cisco", "Merge_CCNA_200-301_Part0-Q0001-1xxx")
    #patch("demo", "demo.json.txt")
