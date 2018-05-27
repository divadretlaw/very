import configuration
from process import Process


class Printer:

    def __init__(self):
        return

    @staticmethod
    def error_message(filename: str):
        print("Usage: python " + filename + " [command]")
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
        print("Cleans the system")  # clean
        print("Cleans the system and empties the trash")  # wow-clean
        print("Checks for package updates and installs them")  # update
        print("Checks for system updates and installs them")  # system-update
        print("Checks for package and system updates and installs them")  # much-update
        print("Updates the script to the newest version")  # very-update
        print("Prints global IP")  # ip
        print("Starts a ping test")  # ping
        print("Starts a download test")  # download
        print("Updates '" + config.get_sources()["hosts"]["target"] + "'")  # hosts
        print("Sets the wallpaper")  # wallpaper

        for packageManager in config.get_additional()["additional"]:
            if Process.has_package(packageManager["command"]):
                print(packageManager["description"])

        return
