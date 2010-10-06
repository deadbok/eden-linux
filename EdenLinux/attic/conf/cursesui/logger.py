"""Logger for the rest of the system

    $Id$
"""

import sys
import logging
import logging.handlers

LOG_FILENAME = './conf.log'

try:
    logger = logging.getLogger("conf")

    handler = logging.handlers.RotatingFileHandler(LOG_FILENAME, maxBytes=1024,
                                                   backupCount=5)
    formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    handler.setFormatter(formatter)
    handler.doRollover()
    logger.addHandler(handler)
    logger.setLevel(logging.DEBUG)
    logger.debug("logger enabled.")


except:
    print sys.exc_info()
    raise  