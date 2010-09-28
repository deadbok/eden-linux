"""Logger for the rest of the system

    $Id$
"""

import sys
import logging.handlers

LOG_FILENAME = './conf.log'

try:
    logger = logging.getLogger("distbuild")

    file_handler = logging.handlers.RotatingFileHandler(LOG_FILENAME,
                                                   backupCount = 5)
    file_formatter = logging.Formatter("%(asctime)s - %(name)s - %(pathname)s - %(levelname)s - %(message)s")
    file_handler.setFormatter(file_formatter)
    file_handler.setLevel(logging.DEBUG)
    file_handler.doRollover()
    logger.setLevel(logging.DEBUG)
    logger.addHandler(file_handler)

    console_handler = logging.StreamHandler(sys.stdout)
    console_formatter = logging.Formatter("%(message)s", "")
    console_handler.setFormatter(console_formatter)
    console_handler.setLevel(logging.INFO)
    logger.addHandler(console_handler)

    logger.debug("logger enabled.")


except:
    print(sys.exc_info())
    raise

def set_console_loglevel(lvl):
    console_handler.setLevel(lvl)

def set_file_loglevel(lvl):
    file_handler.setLevel(lvl)
