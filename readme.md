# Quiz engine
Simple engine and editor for quizzes. It support freetext, single, multiple choice and drag and drop questions. Written in python 3. It needs the [bottle framework](https://github.com/bottlepy/bottle). You can just put the file bootle.py in the root folder with all other python scripts or run ``pip install --requirement  requirements.txt`` 
If you want to use the gui you will need to install the tkinter library.

You do not need to install the bottle framework, only download the bottle.py file and put it in the same folder.

The editor answers boxes allow only manual html formatting.

Key short cuts:

- When in editor
  - Ctrl + S saves the page

- When in quiz:
  - Left/right arrows move to previous/next question.
  - Enter/space shows the answer
  - **secret keys**
  - Ctrl + Alt + d allows to jump to specific question
  - Ctrl + Alt + r restarts the quiz without reloading the page
  - Ctrl + Alt + p pauses the quiz times and buttons

*Disclaimer:*
The question editor is based on [nicEdit.js](https://nicedit.com). I just extended some features and made few small changes:
- Like more colors to select
- possibility to add tables
- the cursor is moved few pixel to the left
- the text area is limited and the row with the buttons are fixed
- when the page is resized, the editor is resized as well
- maybe something else, but I do not remember
  

***consoleMenu.py***

This is the main files when stared you will see a menu to select options to export, merge, start the server and export a quiz to html to use without server.
You can use the following arguments:  
  
<pre>
usage: consoleMenu [-h] [-e] [-o] [-m] [-s] [-a] [-v]

optional arguments:
  -h, --help     show this help message and exit
  -e, --export   Export questions to file
  -o, --offline  Export questions to html file for use without http server
  -m, --merge    Merge questions from 2 quiz/dump
  -s, --start    Start web server
  -a, --about    Show versions
  -v, --version  show program's version number and exit
</pre>

The following bat files start the different options:
- exportQuestions.bat
- export_to_offline.bat
- gui.bat
- mainMenu.bat
- mergeQuestions.bat
- set_python_path.bat
- start.bat


***mainGUI.pyw***
Optional GUI for the web server. The functionality is the same if you start it from terminal (cmd) or the gui script.
This will start the server as with graphical interface based on tkinter.  


***config_files\config.ini***

To configure edit the file config_files\config.ini
- port - changes the server port
- ip - the ip address where to listen
- examFolder - the folder where to save the exam files
- Save_format_pkl - boolean to enable saving as pickle file. This comes with all security risk introduced in pickle library!
- Save_format_sql - boolean to enable saving in sqlite db.
- auto_open_in_browser - boolean to enable opening the page in the default browser. Used only by mainGUI.pyw


***set_python_path.bat***
- here you can point to python path to be used. Usually C:\Users\\%username%\AppData\Local\Programs\Python\Python3XXX
- Set when installing python
- If you will use the default python3 just open each bat file and delete/comment - "call set_python_path.bat"

***For linux***
- just start python3 name_of_the_script
- For GUI you will need to install tkinter

***Access in browser***
- For the main page open http:/IP_ADDRESS:port
  - By deafailt - [http://127.0.0.1:8080](http://127.0.0.1:8080/)
- For the eidtor page open http:/IP_ADDRESS:port/editor/
  - By deafailt - [http://127.0.0.1:8080/editor/](http://127.0.0.1:8080/editor/)

***Versions***  
*Server app 1.30*  
*Cli menu/loader 1.1*  
*Web page templates (css/js) 0.94*  
*Gui 0.3*  