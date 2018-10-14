import configuration
from process import Process


class Printer:

    def __init__(self):
        return

    @staticmethod
    def print_saved(old_space: int):
        new_space = Process.get_space_available()
        saved = new_space - old_space
        if saved < 0:
            saved = 0
        print(u'\U00002705 Done - ' + Printer.int_to_bytes(saved) + " of space was cleaned")

    @staticmethod
    def int_to_bytes(num, suffix='B'):
        for unit in ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z']:
            if abs(num) < 1024.0:
                return "%3.1f%s%s" % (num, unit, suffix)
            num /= 1024.0
        return "%.1f%s%s" % (num, 'Y', suffix)

    @staticmethod
    def error_message(filename: str):
        print("Usage: python3 " + filename + " [command]")
        print("\n" + u'\U00002139\U0000fe0f' + "  Available commands:")
        Printer.commands()
        return

    @staticmethod
    def commands():
        print("install")
        print("remove")
        print("search")
        print("list")
        print("clean")
        print("wow-clean")
        print("update")
        print("system-update")
        print("much-update")
        print("very-update")
        print("ip")
        print("ping")
        print("download")
        print("hosts")
        print("wallpaper")
        print("gitignore")
        print("very")

        config = configuration.Configuration()

        for packageManager in config.get_additional():
            if Process.has_package(packageManager["command"]):
                print(packageManager["id"])

        return

    @staticmethod
    def descriptions():
        config = configuration.Configuration()

        print("Install one or more packages")  # install
        print("Remove one or more packages")  # remove
        print("Search for packages by name")  # search
        print("List installed packages")  # list
        print("Cleans the system and empties the trash")  # clean
        print("Cleans the system and runs the additional clean commands")  # wow-clean
        print("Checks for package updates and installs them")  # update
        print("Checks for system updates and installs them")  # system-update
        print("Checks for package and system updates and installs them")  # much-update
        print("Updates the script to the newest version")  # very-update
        print("Prints global IP")  # ip
        print("Starts a ping test")  # ping
        print("Starts a download test")  # download
        print("Updates '" + config.get_sources()["hosts"]["target"] + "'")  # hosts
        print("Sets the wallpaper")  # wallpaper
        print("Loads a .gitignore file from gitignore.io")  # gitignore
        print("Updates, Upgrades loads hosts and does a cleanup")  # very

        for packageManager in config.get_additional():
            if Process.has_package(packageManager["command"]):
                print(packageManager["description"])

        return
