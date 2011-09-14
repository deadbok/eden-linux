'''
Created on 22 Aug 2011

@author: oblivion
'''
import logging
from logging import handlers
import sys

logger = logging.getLogger("TemplateEden")
logger.setLevel(logging.DEBUG)

file_log = handlers.RotatingFileHandler("templateeden.log",
                                       maxBytes = 10000000,
                                       backupCount = 5)
file_log.setLevel(logging.DEBUG)
file_log.setFormatter(logging.Formatter('%(asctime)s - %(filename)s - %(funcName)s - %(levelname)s: %(message)s'))
logger.addHandler(file_log)
file_log.doRollover()

console_log = logging.StreamHandler(sys.stdout)


def init_file_log(level = logging.DEBUG):
    file_log.setLevel(level)


class ConsoleFormatter(logging.Formatter):
    def __init__(self):
        logging.Formatter.__init__(self, '%(message)s')

    def format(self, record):
        if record.levelno >= logging.ERROR:
            self._fmt = "%(levelname)s: %(message)s"
            msg = logging.Formatter.format(self, record)
        else:
            self._fmt = "%(message)s"
            msg = logging.Formatter.format(self, record)
        return msg


def init_console_log(level = logging.INFO):
    console_log.setLevel(level)
    console_log.setFormatter(ConsoleFormatter())
    logger.addHandler(console_log)

def close_log():
    console_log.close()
    file_log.close()
