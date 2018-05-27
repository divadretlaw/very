import os

dir_path = os.path.expanduser("~") + "/.very"


class Installer:

    @staticmethod
    def install_file(file):
        os.system("curl -#SLko " + dir_path + "/" + file
                  + " https://raw.githubusercontent.com/divadretlaw/very/master/" + file)

    @staticmethod
    def install():
        os.system("mkdir -p " + dir_path)
        Installer.install_file("__main__.py")
        Installer.install_file("configuration.py")
        Installer.install_file("printer.py")
        Installer.install_file("osHelper.py")


if __name__ == "__main__":
    Installer.install()
