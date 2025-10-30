import os
import sys

from pathlib import Path
from collections import namedtuple

from container_ci_suite.utils import check_variables

if not check_variables():
    sys.exit(1)


Vars = namedtuple(
    "Vars", [
        "OS", "VERSION", "IMAGE_NAME", "TEST_DIR"
    ]
)
VERSION = os.getenv("VERSION")
OS = os.getenv("TARGET").lower()


VARS = Vars(
    OS=OS,
    VERSION=VERSION,
    IMAGE_NAME=os.getenv("IMAGE_NAME"),
    TEST_DIR=Path(__file__).parent.absolute(),
)

def skip_if_not_euid_0():
    if os.geteuid() != 0:
        pytest.skip("This test requires root privileges.")
