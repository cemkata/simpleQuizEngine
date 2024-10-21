# -*- coding: utf-8 -*-
import json
import re
from json.decoder import JSONDecodeError
try:
  import cPickle as pickle
except:
  import pickle

import sqlite3
import os
import html

import threading

from config import usePickle, useSQL, maxSizeWarning

_JSON = 0
_PKL =  1
_SQL =  2

SQL_CMD_INS = 0
SQL_CMD_UPD = 1
SQL_CMD_DEL = 2
SQL_CMD_ALL = 3

__CREATE_SQL_DATABASE='''BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "questions" (
    "ID"    INTEGER UNIQUE,
    "QUESTION_TEXT"    TEXT NOT NULL,
    "QUESTION_ANSWERS"    TEXT,
    "QUESTION_CORECT"    TEXT,
    "QUESTION_REF"    TEXT,
    "QUESTION_EXPLAIN"    TEXT,
    "QUESTION_ANSWERS_GRP"    TEXT,
    "QUESTION_ANSWERS_CNT"    TEXT,
    PRIMARY KEY("ID" AUTOINCREMENT)
);
COMMIT;'''

if usePickle:
    _DEFAULT_TYPE = _PKL
elif useSQL:
    _DEFAULT_TYPE = _SQL
else:
    _DEFAULT_TYPE = _JSON

class myLock:
  count = 0
  lock = threading.RLock()

cache_lock = threading.RLock()
locked_files = {}

def proccesFile(fileName):
    try:
        with cache_lock:
            try:
                lock = locked_files[fileName].lock
                locked_files[fileName].count += 1
            except:
                locked_files[fileName] = myLock()
                lock = locked_files[fileName].lock
        with lock:
            try:
                with open(fileName, "r", encoding="Utf-8") as f:
                    return json.load(f)
            except JSONDecodeError as e:
                #print("proccesOldTypeFile") #Debug
                return proccesOldTypeFile(fileName)
            except UnicodeDecodeError as e:
                try:
                    #print("proccesFile_pkl") #Debug
                    return proccesFile_pkl(fileName)
                except pickle.UnpicklingError as e:
                    #print("proccesFile_sql") #Debug
                    return proccesFile_sql(fileName)
    except:
        pass
    finally:
        with cache_lock:
            locked_files[fileName].count -= 1
            if locked_files[fileName].count == 0:
                locked_files.pop(fileName)
  
def proccesFile_pkl(fileName):
    with open(fileName, "rb") as f:
        data = pickle.load(f)
    return data

def proccesFile_sql(fileName):
    sql_query = f'''SELECT `ID`, `QUESTION_TEXT`, `QUESTION_ANSWERS`, `QUESTION_CORECT`, `QUESTION_REF`, `QUESTION_EXPLAIN`, `QUESTION_ANSWERS_GRP`, `QUESTION_ANSWERS_CNT` FROM `questions`;'''
    questions = []
    # last_id = -1
    try:
        for q in execute_sql_statment(sql_query, fileName):
            tmpDict = {}
            #process to json string to values
            q_exp = tmpDict["id"] = q[0]
            q_txt = tmpDict["question"] = json.loads(html.unescape(q[1]))
            q_ans = tmpDict["answers"] = json.loads(html.unescape(q[2]))
            q_cor = tmpDict["correctAnswer"] = json.loads(html.unescape(q[3]))
            q_ref = tmpDict["referenceLink"] = json.loads(html.unescape(q[4]))
            q_exp = tmpDict["explanation"] = json.loads(html.unescape(q[5]))
            try:
                q_exp = tmpDict["answersGroups"] = json.loads(html.unescape(q[6]))
            except json.decoder.JSONDecodeError:
                pass
            try:
                q_exp = tmpDict["answersCount"] = json.loads(html.unescape(q[7]))
            except json.decoder.JSONDecodeError:
                pass
            questions.append(tmpDict.copy())
            # last_id = q[0]
        result = {'dump':questions, 'lastID': len(questions)}
        return result
    except Exception as e:
        raise e
        return '''{"dump": [], "lastID": 0}'''

def saveFile(fileName, data, SQL_CMD = -1, question_id = None, type = _DEFAULT_TYPE):
    #print(f"{type=}") #Debug
    try:
        with cache_lock:
            try:
                lock = locked_files[fileName].lock
                locked_files[fileName].count += 1
            except:
                locked_files[fileName] = [threading.RLock(),1]
                lock = locked_files[fileName].lock
        with lock:
            result = "Done!"
            if type == _JSON:
                saveFile_json(fileName, data)
            elif type == _PKL:
                saveFile_pkl(fileName, data)
            elif type == _SQL:
                if SQL_CMD > SQL_CMD_INS - 1 and SQL_CMD < SQL_CMD_ALL:
                    saveFile_sql(fileName, data, SQL_CMD, question_id)
                elif SQL_CMD == SQL_CMD_ALL:
                    for q in data['dump']:
                        # To check
                        saveFile_sql(fileName, data, SQL_CMD_INS, q['id'])
            else:
                pass #FUTURE use
            if os.path.getsize(fileName) > maxSizeWarning:
                result += "\nWarning file bigger than 25MB.\nConsider spliting it."
            return result
    except:
        pass
    finally:
        with cache_lock:
            locked_files[fileName].count -= 1
            if locked_files[fileName].count == 0:
                locked_files.pop(fileName)

def saveFile_sql(fileName, data, cmd, q_id):
    #Add sql logic
    if cmd != SQL_CMD_DEL:
        #process table values to json string
        q_id = q_id - 1
        q_txt = html.escape(json.dumps(data["dump"][q_id]["question"]))
        q_ans = html.escape(json.dumps(data["dump"][q_id]["answers"]))
        q_cor = html.escape(json.dumps(data["dump"][q_id]["correctAnswer"]))
        q_ref = html.escape(json.dumps(data["dump"][q_id]["referenceLink"]))
        q_exp = html.escape(json.dumps(data["dump"][q_id]["explanation"]))
        try:
            q_grp = html.escape(json.dumps(data["dump"][q_id]["answersGroups"])) #error if no group exist
        except KeyError:
            q_grp = ""
        try:
            q_cnt = html.escape(json.dumps(data["dump"][q_id]["answersCount"])) #error if no count exist
        except KeyError:
            q_cnt = ""
    if cmd == SQL_CMD_INS:
        #sql insert query
        sql_query = f'''INSERT INTO `questions` (`QUESTION_TEXT`, `QUESTION_ANSWERS`, `QUESTION_CORECT`, `QUESTION_REF`, `QUESTION_EXPLAIN`, `QUESTION_ANSWERS_GRP`, `QUESTION_ANSWERS_CNT`) VALUES ("{q_txt}", "{q_ans}", "{q_cor}", "{q_ref}", "{q_exp}", "{q_grp}", "{q_cnt}");'''
    elif cmd == SQL_CMD_UPD:
        #sql update query
        sql_query = f'''UPDATE `questions` SET `QUESTION_TEXT` = "{q_txt}", `QUESTION_ANSWERS` = "{q_ans}", `QUESTION_CORECT` = "{q_cor}", `QUESTION_REF` = "{q_ref}", `QUESTION_EXPLAIN` = "{q_exp}", `QUESTION_ANSWERS_GRP` = "{q_grp}", `QUESTION_ANSWERS_CNT` = "{q_cnt}" WHERE `id` = {q_id};'''
    elif cmd == SQL_CMD_DEL:
        #sql delete query
        sql_query = f'''DELETE FROM `questions` WHERE `id` = {q_id};'''
    else:
        return #FUTURE use

    #run sql str
    try:
        execute_sql_statment(sql_query, fileName)
    except sqlite3.OperationalError as e:
        raise e
    except sqlite3.DatabaseError:
        migrateDB2SQL(sql_query, fileName)
        execute_sql_statment(sql_query, fileName)

def execute_sql_statment(in_sql, db_file, SINGLE_ROW = False):
    if not os.path.isfile(db_file):
        conn = sqlite3.connect(db_file)
        with conn:
            cur = conn.cursor()
            cur.executescript(__CREATE_SQL_DATABASE)
            conn.commit()
    try:
        conn = sqlite3.connect(db_file)
        with conn:
            cur = conn.cursor()
            cur.execute(in_sql)
            if SINGLE_ROW:
                rows = cur.fetchone()
            else:
                rows = cur.fetchall()
            conn.commit()
        return rows
    except sqlite3.Error as e:
        conn.close()
        raise e
    return None

def migrateDB2SQL(in_sql, dbpath):
    tmpHolder = proccesFile(dbpath)
    os.remove(dbpath)
    saveFile(dbpath, tmpHolder, SQL_CMD = SQL_CMD_ALL)
    execute_sql_statment(in_sql, dbpath)

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