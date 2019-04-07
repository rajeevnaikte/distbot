import logging
import robot.running
from robot.output import librarylogger as log
from robot.libraries.BuiltIn import BuiltIn

class AssistantLibrary:
    def start_assistant(self):
        log.console('\nHello, how may i help you today?\n')
        while True:
            keyword = raw_input().strip()
            if keyword == '':
                continue
            if keyword == 'bye':
                break
            if keyword.lower() == 'start assistant':
                log.console('Already running')
                continue
            try:
                ret = BuiltIn().run_keyword(*keyword.split('  '))
                log.console(ret)
            except Exception as e:
                log.console(e)
            


    