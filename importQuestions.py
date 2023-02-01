# -*- coding: utf-8 -*-
import json
import re
def proccesFile(fileName):
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

    for q in questionsStrings:
        lines = q.splitlines()
        tmpDict = {}
        answers = {}
        tmpDict['explanation'] = ''
        tmpDict['question'] = ''
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
                    tmpDict['correctAnswer'] = lines[i].replace("Correct Answer: ", '')
                elif lines[i].startswith("Answer: "):
                    tmpDict['correctAnswer'] = lines[i].replace("Answer: ", '')
                elif lines[i][1].lower() == '.' and lines[i][2].lower() == ' ' and answerTextDone: # answers
                    qestionTextDone = False
                    questionAnsr = lines[i][0]
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

    return json.dumps(questions, ensure_ascii=False)
