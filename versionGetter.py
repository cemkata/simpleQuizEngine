import json

def getVersion(product):
    try:
        with open("./version.nfo", "r") as f:
            data = json.load(f)
            ver = data[product]
    except (FileNotFoundError, json.JSONDecodeError, KeyError) as er:
        #ver = "Version ?? unknown ??"
        ver = "??"
    return ver

def fullVersion():
    return f'''{getVersion("app")}-{getVersion("db_schema")}-{getVersion("templates")}'''