from cmdHelper import exportQuestions_main, export_to_offline_main, mergeQuestions_main
import argparse
import os

from versionGetter import getVersion
ver = getVersion('loader')

def main(args):
    exitFlag = True
    print(f"Dump wizard cmd helper. ver {ver}")
    showmenu = args.export or args.offline or args.merge or args.start
    sel = ""
    while exitFlag:
        if not showmenu:
            print("Export questions from quiz/dump ............ [1]")
            print("Export questions to html (without server) .. [2]")
            print("Merge questions from 2 quiz/dump  .......... [3]")
            print("Start web server ........................... [4]")
            sel = input(">> ")
        if sel == "1" or args.export:
            print("Export questions")
            exportQuestions_main()
            exitFlag = False
        elif sel == "2" or args.offline:
            print("Export to offline html file")
            export_to_offline_main()
            exitFlag = False
        elif sel == "3" or args.merge:
            print("Merge questions")
            mergeQuestions_main()
            exitFlag = False
        elif sel == "4" or args.start:
            import quiz
            quiz.main()
            exitFlag = False
        else:
            print("Wrong selection!")
    print("")
    print("")
    input("Press enter to exit")

    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog=os.path.splitext(os.path.basename(__file__))[0])
    parser.add_argument('-e', '--export', help='Export questions to file\n', action='store_true')
    parser.add_argument('-o', '--offline', help='Export questions to html file for use without http server\n', action='store_true')
    parser.add_argument('-m', '--merge', help='Merge questions from 2 quiz/dump', action='store_true')
    parser.add_argument('-s', '--start', help='Start web server', action='store_true')
    parser.add_argument('-a', '--about', help='Show versions', action='store_true')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s v'+str(ver))
    args = parser.parse_args()
    try:
        if args.about:
            print(f"Dump wizard cmd helper - {getVersion('loader')}")
            print(f"Dump wizard web sever  - {getVersion('app')}")
            print(f"Dump wizard templates  - {getVersion('templates')}")
            print("")
        else:
            main(args)
    except KeyboardInterrupt:
        print("You exit. Bye bye.")