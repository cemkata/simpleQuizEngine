import os
import re
import configparser

cnfgFile = "./config_files/config.ini"

if os.path.isfile(os.path.abspath(cnfgFile)):
    config = configparser.ConfigParser()
    config.read(cnfgFile)
    try:
        serverPort = config['DEFAULT']['Port']
    except ValueError:
        raise KeyError('Wrong port')
    serverAddres = config['DEFAULT']['ip']
    ip_pattern = re.compile('(?:^|\b(?<!\.))(?:1?\d\d?|2[0-4]\d|25[0-5])(?:\.(?:1?\d\d?|2[0-4]\d|25[0-5])){3}(?=$|[^\w.])')
    if not ip_pattern.match(serverAddres):
        raise KeyError('Server IP address')
    examFolder = os.path.abspath(config['DEFAULT']['examFolder'])
else:
    print("Warning!!")
    print("Using default config")
    examFolder = ".\exams"
    # Address where the app listens. Note  listening 127.0.0.1 is diffrent than listening on the real NIC ip.
    serverAddres = "127.0.0.1"
    # Port of the web interface
    serverPort = 8080

if not os.path.exists(examFolder):
    os.makedirs(examFolder)