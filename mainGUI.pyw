try:
    import Tkinter as tk
    import Tkinter.messagebox
except ImportError:
    import tkinter as tk
    import tkinter.messagebox

try:
    import ttk
    py3 = False
except ImportError:
    import tkinter.ttk as ttk
    py3 = True

import sys
import os
import threading
import webbrowser
import ctypes

from versionGetter import getVersion
from config import serverAddres, serverPort, autoOpenInBrowser

ver = getVersion('gui')

myappid = 'mycompany.myproduct.subproduct.version' # arbitrary string
ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID(myappid)

iconPath = "./views/static/kisspng-quiz-icons-computer-icons-easy-word-mind-game-quiz-5ad760c95b4395.8799719915240644573738.ico"

class ExampleApp(tk.Tk):
    def __init__(self):
        tk.Tk.__init__(self)
        self.title(f"GUI for - quiz engine web server - gui version {ver}")

        if os.path.exists(iconPath):
            self.iconbitmap(iconPath)
        toolbar = tk.Frame(self)
        toolbar.pack(side="top", fill="x")
        #b1 = tk.Button(self, text="print to stdout", command=self.print_stdout)
        #b1.pack(in_=toolbar, side="left")
        self.text = ScrolledText(self, wrap="word")
        self.text.pack(side="top", fill="both", expand=True)
        self.text.tag_configure("stderr", foreground="", \
                                background="", font='TkFixedFont', \
                                selectbackground = "")
        self.text.tag_configure("stdout", foreground="#b22222", \
                                background="", font='TkFixedFont', \
                                selectbackground = "")

        sys.stdout = TextRedirector(self.text, "stdout")
        sys.stderr = TextRedirector(self.text, "stderr")
        
    def enable_log(self, stdout_file, stderr_file):
        sys.stdout = TextRedirectorToFile(self.text, stdout_file, "stdout")
        sys.stderr = TextRedirectorToFile(self.text, stderr_file, "stderr")

    #def print_stdout(self):
    #    '''Illustrate that using 'print' writes to stdout'''
    #    global S
    #    tk.messagebox.showinfo(str(S.is_alive()))
    #    #https://stackoverflow.com/questions/11282218/bottle-web-framework-how-to-stop
    #    #https://docs.python.org/3/library/threading.html#threading.Thread.daemon
    #    #https://www.section.io/engineering-education/how-to-perform-threading-timer-in-python/
    #    #print("this is stdout")
        
class TextRedirector(object):
    def __init__(self, widget, tag="stdout"):
        self.widget = widget
        self.tag = tag

    def write(self, str):
        self.widget.configure(state="normal")
        self.widget.insert("end", str, (self.tag,))
        self.widget.see('end')
        self.widget.configure(state="disabled")
        
class TextRedirectorToFile(object):
    def __init__(self, widget, file_name, tag="stdout"):
        self.widget = widget
        self.tag = tag
        self.fp = open(file_name, mode="a")

    def write(self, str):
        self.widget.configure(state="normal")
        self.widget.insert("end", str, (self.tag,))
        self.widget.see('end')
        self.widget.configure(state="disabled")
        self.fp.write(str)
 
# The following code is added to facilitate the Scrolled widgets you specified.
class AutoScroll(object):
    '''Configure the scrollbars for a widget.'''

    def __init__(self, master):
        #  Rozen. Added the try-except clauses so that this class
        #  could be used for scrolled entry widget for which vertical
        #  scrolling is not supported. 5/7/14.
        try:
            vsb = ttk.Scrollbar(master, orient='vertical', command=self.yview)
        except:
            pass
        hsb = ttk.Scrollbar(master, orient='horizontal', command=self.xview)

        #self.configure(yscrollcommand=_autoscroll(vsb),
        #    xscrollcommand=_autoscroll(hsb))
        try:
            self.configure(yscrollcommand=self._autoscroll(vsb))
        except:
            pass
        self.configure(xscrollcommand=self._autoscroll(hsb))

        self.grid(column=0, row=0, sticky='nsew')
        try:
            vsb.grid(column=1, row=0, sticky='ns')
        except:
            pass
        hsb.grid(column=0, row=1, sticky='ew')

        master.grid_columnconfigure(0, weight=1)
        master.grid_rowconfigure(0, weight=1)

        # Copy geometry methods of master  (taken from ScrolledText.py)
        if py3:
            methods = tk.Pack.__dict__.keys() | tk.Grid.__dict__.keys() \
                  | tk.Place.__dict__.keys()
        else:
            methods = tk.Pack.__dict__.keys() + tk.Grid.__dict__.keys() \
                  + tk.Place.__dict__.keys()

        for meth in methods:
            if meth[0] != '_' and meth not in ('config', 'configure'):
                setattr(self, meth, getattr(master, meth))

    @staticmethod
    def _autoscroll(sbar):
        '''Hide and show scrollbar as needed.'''
        def wrapped(first, last):
            first, last = float(first), float(last)
            if first <= 0 and last >= 1:
                sbar.grid_remove()
            else:
                sbar.grid()
            sbar.set(first, last)
        return wrapped

    def __str__(self):
        return str(self.master)

def _create_container(func):
    '''Creates a ttk Frame with a given master, and use this new frame to
    place the scrollbars and the widget.'''
    def wrapped(cls, master, **kw):
        container = ttk.Frame(master)
        container.bind('<Enter>', lambda e: _bound_to_mousewheel(e, container))
        container.bind('<Leave>', lambda e: _unbound_to_mousewheel(e, container))
        return func(cls, container, **kw)
    return wrapped

class ScrolledText(AutoScroll, tk.Text):
    '''A standard Tkinter Text widget with scrollbars that will
    automatically show/hide as needed.'''
    @_create_container
    def __init__(self, master, **kw):
        tk.Text.__init__(self, master, **kw)
        AutoScroll.__init__(self, master)

import platform
def _bound_to_mousewheel(event, widget):
    child = widget.winfo_children()[0]
    if platform.system() == 'Windows' or platform.system() == 'Darwin':
        child.bind_all('<MouseWheel>', lambda e: _on_mousewheel(e, child))
        child.bind_all('<Shift-MouseWheel>', lambda e: _on_shiftmouse(e, child))
    else:
        child.bind_all('<Button-4>', lambda e: _on_mousewheel(e, child))
        child.bind_all('<Button-5>', lambda e: _on_mousewheel(e, child))
        child.bind_all('<Shift-Button-4>', lambda e: _on_shiftmouse(e, child))
        child.bind_all('<Shift-Button-5>', lambda e: _on_shiftmouse(e, child))

def _unbound_to_mousewheel(event, widget):
    if platform.system() == 'Windows' or platform.system() == 'Darwin':
        widget.unbind_all('<MouseWheel>')
        widget.unbind_all('<Shift-MouseWheel>')
    else:
        widget.unbind_all('<Button-4>')
        widget.unbind_all('<Button-5>')
        widget.unbind_all('<Shift-Button-4>')
        widget.unbind_all('<Shift-Button-5>')

def _on_mousewheel(event, widget):
    if platform.system() == 'Windows':
        widget.yview_scroll(-1*int(event.delta/120),'units')
    elif platform.system() == 'Darwin':
        widget.yview_scroll(-1*int(event.delta),'units')
    else:
        if event.num == 4:
            widget.yview_scroll(-1, 'units')
        elif event.num == 5:
            widget.yview_scroll(1, 'units')

def _on_shiftmouse(event, widget):
    if platform.system() == 'Windows':
        widget.xview_scroll(-1*int(event.delta/120), 'units')
    elif platform.system() == 'Darwin':
        widget.xview_scroll(-1*int(event.delta), 'units')
    else:
        if event.num == 4:
            widget.xview_scroll(-1, 'units')
        elif event.num == 5:
            widget.xview_scroll(1, 'units')

def mainFunction():
    from quiz import main
        
    S = threading.Timer(0.5, main)
    S.start()

    if autoOpenInBrowser:
        T = threading.Timer(1, webbrowser.open, kwargs={'url': f"http://{serverAddres}:{serverPort}", \
                                                                'new': 0, 'autoraise': True})
        T.start()

    #url = "https://www.google.com/"
    #webbrowser.open(url, new=0, autoraise=True)

app_Tk = ExampleApp()
app_Tk.after(20, mainFunction)
#def after(self, ms, func=None, *args):
"""Call function once after given time.

MS specifies the time in milliseconds. FUNC gives the
function which shall be called. Additional parameters
are given as parameters to the function call.  Return
identifier to cancel scheduling with after_cancel."""
def on_closing():
    if tk.messagebox.askokcancel("Quit", "Do you want to quit?"):

        try:
            sys.stdout.fp.flush()
            sys.stdout.fp.close()
            sys.stderr.fp.flush()
            sys.stderr.fp.close()
        except AttributeError:
            pass
   
        app_Tk.destroy()

        #Perform harakiri
        pid = os.getpid()
        from signal import SIGTERM
        os.kill(pid, SIGTERM)

app_Tk.protocol("WM_DELETE_WINDOW", on_closing)
app_Tk.mainloop()
