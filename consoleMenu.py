from cmdHelper import ver, exportQuestions_main, export_to_offline_main, mergeQuestions_main
import argparse
import os

def main(args):
    exitFlag = True
    print(f"Dump wizard cmd helper. ver {ver}")
    showmenu = args.export or args.offline or args.merge
    sel = ""
    while exitFlag:
        if not showmenu:
            print("Export questions from quiz/dump ............ [1]")
            print("Export questions to html (without server) .. [2]")
            print("Merge questions from 2 quiz/dump  .......... [3]")
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
        else:
            print("Wrong selection!")

    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog=os.path.splitext(os.path.basename(__file__))[0])
    parser.add_argument('-e', '--export', help='Export questions to file\n', action='store_true')
    parser.add_argument('-o', '--offline', help='Export questions to html file for use without http server\n', action='store_true')
    parser.add_argument('-m', '--merge', help='Merge questions from 2 quiz/dump', action='store_true')
    parser.add_argument('-v', '--version', action='version', version='%(prog)s v'+str(ver))
    args = parser.parse_args()
    main(args)