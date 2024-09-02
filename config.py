import os
import re
import configparser

cnfgFile = "./config_files/config.ini"

if os.path.isfile(os.path.abspath(cnfgFile)):
    config = configparser.ConfigParser()
    config.read(cnfgFile)
    try:
        serverPort = config['DEFAULT']['Port']
        serverPort = config.getint('DEFAULT', 'Port')
    except (ValueError, KeyError) as e:
        raise KeyError('Wrong port')
    serverAddres = config['DEFAULT']['ip']
    if serverAddres.lower() != "localhost":
        ip_pattern = re.compile('(?:^|\b(?<!\.))(?:1?\d\d?|2[0-4]\d|25[0-5])(?:\.(?:1?\d\d?|2[0-4]\d|25[0-5])){3}(?=$|[^\w.])')
        ipv6_pattern = re.compile('(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))')
        if not ip_pattern.match(serverAddres) and not ipv6_pattern.match(serverAddres):
            raise KeyError('Server IP address')
    examFolder = os.path.abspath(config['DEFAULT']['examFolder'])
    config.BOOLEAN_STATES = {'sure': True, 'nope': False}
    config.BOOLEAN_STATES = {'on': True, 'off': False}
    usePickle = False
    if config.has_option('DEFAULT', "Save_format"):
        usePickle = config.getboolean('DEFAULT', "Save_format")
    autoOpenInBrowser = False
    if config.has_option('DEFAULT', "auto_open_in_browser"):
        autoOpenInBrowser = config.getboolean('DEFAULT', "auto_open_in_browser")
else:
    print("Warning!!")
    print("Using default config")
    examFolder = ".\exams"
    # Address where the app listens. Note  listening 127.0.0.1 is diffrent than listening on the real NIC ip.
    serverAddres = "127.0.0.1"
    # Port of the web interface
    serverPort = 8080
    #save file format = json
    usePickle = False
    autoOpenInBrowser = False

if not os.path.exists(examFolder):
    os.makedirs(examFolder)
