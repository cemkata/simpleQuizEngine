import os
import re
import configparser

USEING_K8S = os.getenv('K8S')

if USEING_K8S:
    cnfgFile = "/etc/quiz_engin_config.ini"
else:
    cnfgFile = "./config_files/config.ini"

if os.path.isfile(os.path.abspath(cnfgFile)):
    config = configparser.ConfigParser()
    config.read(cnfgFile)

    if USEING_K8S:
        serverPort = 80
        serverAddres = '0.0.0.0'
    else:
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
    config.BOOLEAN_STATES = {'sure': True, 'nope': False,
                             'on': True, 'off': False,
                             'yes': True, 'no': False,
                             'enable': True, 'disable': False}
    usePickle = False
    if config.has_option('DEFAULT', "Save_format_pkl"):
        try:
            usePickle = config.getboolean('DEFAULT', "Save_format_pkl")
        except ValueError:
            pass
    useSQL = False
    if config.has_option('DEFAULT', "Save_format_sql"):
        try:
            useSQL = config.getboolean('DEFAULT', "Save_format_sql")
        except ValueError:
            pass
    autoOpenInBrowser = False
    if config.has_option('DEFAULT', "auto_open_in_browser"):
        try:
            autoOpenInBrowser = config.getboolean('DEFAULT', "auto_open_in_browser")
        except ValueError:
            pass
    showSelectionPage = False
    if config.has_option('DEFAULT', "auto_open_in_browser"):
        try:
            showSelectionPage = config.getboolean('DEFAULT', "allow_selection_page")
        except ValueError as e:
            pass
    maxSizeWarning = 26214400 # 26214400 bytes == 25 MB
    if config.has_option('DEFAULT', "FileSize"):
        try:
            maxSizeWarning = config.getint('DEFAULT', 'FileSize')
        except ValueError as e:
            pass

    webconf = {}
    webconf['Display_GUI'] = False
    webconf['Hide_restart_answer'] = False
    webconf['Show_progress_bar'] = True
    webconf['Show_progress_as_numbers'] = True
    webconf['Allow_edit_from_inside_a_quiz'] = False
    webconf['Exsam_mode'] = False
    webconf['Exsam_mode_read_only'] = False
    webconf['Randomize_questions'] = False
    webconf['Randomize_questions_read_only'] = False
    webconf['Randomize_answers'] = False
    webconf['Randomize_answers_read_only'] = False
    if config.has_option('QUIZ_WEB_PAGE', "Hide_GUI_options"):
        try:
            webconf['Display_GUI'] = config.getboolean('QUIZ_WEB_PAGE', "Hide_GUI_options")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Hide_restart_answer"):
        try:
            webconf['Hide_restart_answer'] = config.getboolean('QUIZ_WEB_PAGE', "Hide_restart_answer")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Show_progress_bar"):
        try:
            webconf['Show_progress_bar'] = config.getboolean('QUIZ_WEB_PAGE', "Show_progress_bar")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Show_progress_as_numbers"):
        try:
            webconf['Show_progress_as_numbers'] = config.getboolean('QUIZ_WEB_PAGE', "Show_progress_as_numbers")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Allow_edit_from_inside_a_quiz"):
        try:
            webconf['Allow_edit_from_inside_a_quiz'] = config.getboolean('QUIZ_WEB_PAGE', "Allow_edit_from_inside_a_quiz")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Exsam_mode"):
        try:
            webconf['Exsam_mode'] = config.getboolean('QUIZ_WEB_PAGE', "Exsam_mode")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Exsam_mode_read_only"):
        try:
            webconf['Exsam_mode_read_only'] = config.getboolean('QUIZ_WEB_PAGE', "Exsam_mode_read_only")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Randomize_questions"):
        try:
            webconf['Randomize_questions'] = config.getboolean('QUIZ_WEB_PAGE', "Randomize_questions")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Randomize_questions_read_only"):
        try:
            webconf['Randomize_questions_read_only'] = config.getboolean('QUIZ_WEB_PAGE', "Randomize_questions_read_only")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Randomize_answers"):
        try:
            webconf['Randomize_answers'] = config.getboolean('QUIZ_WEB_PAGE', "Randomize_answers")
        except ValueError as e:
            pass
    if config.has_option('QUIZ_WEB_PAGE', "Randomize_answers_read_only"):
        try:
            webconf['Randomize_answers_read_only'] = config.getboolean('QUIZ_WEB_PAGE', "Randomize_answers_read_only")
        except ValueError as e:
            pass
    web_editor_conf = {}
    web_editor_conf['RELOAD_ON_DELETE'] = 'false'
    if config.has_option('EDITOR_WEB_PAGE', "RELOAD_ON_DELETE"):
        try:
            web_editor_conf['RELOAD_ON_DELETE'] = config.getboolean('EDITOR_WEB_PAGE', "RELOAD_ON_DELETE")
            if web_editor_conf['RELOAD_ON_DELETE']:
                web_editor_conf['RELOAD_ON_DELETE'] = 'true'
            else:
                web_editor_conf['RELOAD_ON_DELETE'] = 'false'
        except ValueError as e:
            pass

else:
    print("Warning!!")
    print("Using default config")
    examFolder = ".\exams"
    if USEING_K8S:
        serverPort = 80
        serverAddres = '0.0.0.0'
    else:
        # Address where the app listens. Note  listening 127.0.0.1 is diffrent than listening on the real NIC ip.
        serverAddres = "127.0.0.1"
        # Port of the web interface
        serverPort = 8080
    #save file format = json
    usePickle = False
    useSQL = False
    autoOpenInBrowser = False
    showSelectionPage = False
    maxSizeWarning = 26214400 # 26214400 bytes == 25 MB
    webconf = {}
    webconf['Display_GUI'] = False
    webconf['Hide_restart_answer'] = False
    webconf['Show_progress_bar'] = True
    webconf['Show_progress_as_numbers'] = True
    webconf['Allow_edit_from_inside_a_quiz'] = False
    webconf['Exsam_mode'] = False
    webconf['Exsam_mode_read_only'] = False
    webconf['Randomize_questions'] = False
    webconf['Randomize_questions_read_only'] = False
    webconf['Randomize_answers'] = False
    webconf['Randomize_answers_read_only'] = False
    web_editor_conf = {}
    web_editor_conf['RELOAD_ON_DELETE'] = 'false'

for key in webconf.keys():
    if key == 'Display_GUI':
        continue
    if webconf[key]:
        if key.endswith('_read_only'):
            webconf[key] = 'disabled'
        else:
            webconf[key] = 'checked'
    else:
        webconf[key] = ''

if not os.path.exists(examFolder):
    os.makedirs(examFolder)
