import os

dir_path = os.path.dirname(os.path.realpath(__file__))


class Updater:

    @staticmethod
    def update_file(file):
        os.system("curl -#SLko " + dir_path + "/" + file
                  + " https://raw.githubusercontent.com/divadretlaw/very/master/" + file)

    @staticmethod
    def update():
        Updater.update_file("__main__.py")
        Updater.update_file("configuration.py")
        Updater.update_file("printer.py")
        Updater.update_file("osHelper.py")


if __name__ == "__main__":
    Updater.update()
