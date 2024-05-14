# -*- coding: utf-8 -*-
import json
import re

def proccesFile(fileName):
    with open(fileName, "r", encoding="Utf-8") as f:
        data = json.load(f)
    return data

def saveFile(fileName, data):
    with open(fileName, "w", encoding="Utf-8") as f:
        json.dump(data, f, ensure_ascii=False)
