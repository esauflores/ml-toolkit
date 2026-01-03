import sys
import platform


def test_python_version():
    assert sys.version_info[:2] == (3, 12), "Python must be 3.12"


def test_platform_linux_x86_64():
    assert sys.platform == "linux"
    assert platform.machine() == "x86_64"
