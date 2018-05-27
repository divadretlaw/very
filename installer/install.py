import os

path = os.path.expanduser("~") + "/.very"


class Installer:

    @staticmethod
    def install_file(file):
        os.system("curl -#SLko " + path + "/" + file
                  + " https://raw.githubusercontent.com/divadretlaw/very/master/" + file)

    @staticmethod
    def install():
        os.system("mkdir -p " + path)
        Installer.install_file("__main__.py")
        Installer.install_file("configuration.py")
        Installer.install_file("printer.py")
        Installer.install_file("osHelper.py")
        Installer.install_file("updater.py")


if __name__ == "__main__":
    Installer.install()
