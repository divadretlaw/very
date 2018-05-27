#!/usr/bin/env python3
# coding: utf-8

import datetime
import sys

from configuration import Configuration
from osHelper import OSHelper
from printer import Printer
from updater import Updater

config = Configuration()


def additional_command(package_manager):
    commands = config.get_additional_commands_of(package_manager)

    if commands is not None:
        packages = ""

        if len(sys.argv) < 3:
            print(u'\U0001F6AB' + " No subcommand provided for '" + sys.argv[1] + "'")
            return

        for x in range(3, len(sys.argv)):
            packages += " " + sys.argv[x]

        if sys.argv[2] in commands and commands[sys.argv[2]] != "":
            OSHelper.run(commands[sys.argv[2]] + packages)
        else:
            print(u'\U0001F6AB' + " Unknown subcommand of '" + sys.argv[1] + "'")

    return


def arguments_from(from_):
    arguments = ""
    for x in range(from_, len(sys.argv)):
        arguments += " " + sys.argv[x]
    return arguments


def install():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    message = u'\U00002795' + " Installing packages using '" + main["command"] + "'..."
    OSHelper.run_and_print(main, "install", packages, message)
    return


def remove():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    message = u'\U00002795' + " Removing packages using '" + main["command"] + "'..."
    OSHelper.run_and_print(main, "remove", packages, message)
    return


def search():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    OSHelper.run_and_print(main, "search", packages, None)
    return


def ls():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    OSHelper.run_and_print(main, "list", packages, None)
    return


def clean():
    main = config.get_main_package_manager()
    OSHelper.run_and_print(main, "clean", "", u'\U0000267B\U0000fe0f' + "  Cleaning system...")

    for packageManger in config.get_additional():
        OSHelper.run_if(packageManger["command"], packageManger["clean"])

    print(u'\U0001f5d1' + "  Emptying trash...")

    if sys.platform == "darwin":
        OSHelper.run("rm -rf $HOME/.Trash/*")
    else:
        OSHelper.run("rm -rf $HOME/.local/share/Trash/files/*")
        OSHelper.run("rm -rf $HOME/.local/share/Trash/info/*.trashinfo")

    return


def additional_clean():
    print(u'\U0000267B\U0000fe0f' + "  Running additional clean commands...")

    for command in config.data["additional_clean_commands"]:
        print("Running '" + command + "'...")
        OSHelper.run(command)
    return


def update():
    main = config.get_main_package_manager()
    message = u'\U0001f4e6' + " Updating packages using '" + main["command"] + "'..."
    OSHelper.run_and_print(main, "update", "", message)
    OSHelper.run_and_print(main, "upgrade", "", None)

    for packageManager in config.get_additional():
        if OSHelper.has_package(packageManager["command"]):
            message = u'\U0001f4e6' + " Updating packages using '" + packageManager["command"] + "'..."
            OSHelper.run_and_print(packageManager, "update", "", message)
            OSHelper.run_and_print(packageManager, "upgrade", "", None)
    return


def upgrade():
    print(u'\U0001f504' + " Upgrading System...")
    for packageManager in config.get_package_mangers():
        OSHelper.run_if(packageManager["command"], packageManager["system_upgrade"])
    return


def ip():
    OSHelper.run("curl " + config.get_sources()["ip"])
    return


def ping():
    print(u'\U0001F310' + " Starting ping test...")
    OSHelper.run("ping " + config.get_sources()["ping"])
    return


def download():
    print(u'\U00002b07\U0000fe0f' + "  Starting download test...")
    OSHelper.run("curl -sLko /dev/null " + config.get_sources()["downloadtest"])
    return


def hosts():
    hosts_config = config.get_sources()["hosts"]
    sudo = ""
    if hosts_config["sudo"]:
        sudo = "sudo"

    target = hosts_config["target"]

    print(u'\U0001F4DD' + " Updating '" + target + "' from '" + hosts_config["source"] + "'...")

    OSHelper.run("echo '# Last updated: {:%Y-%m-%d %H:%M:%S}".format(
        datetime.datetime.now()) + "\n' | " + sudo + " tee " + target + " > /dev/null")

    if hosts_config["defaults"]:
        OSHelper.run(
            "echo '127.0.0.1 localhost\n::1 localhost\n255.255.255.255 broadcasthost\n127.0.0.1 "
            + OSHelper.name()
            + "\n' | "
            + sudo + " tee -a "
            + target + " > /dev/null")

    OSHelper.run("curl -#SLk " + hosts_config[
        "source"] + " | grep '^[^#]' | grep 0.0.0.0 | " + sudo + " tee -a " + target + " > /dev/null")
    return


def wallpaper():
    print(u'\U00002b07\U0000fe0f' + "  Downloading Wallpaper from '" + config.get_sources()["wallpaper"] + "'...")
    OSHelper.run("curl -#SLko $HOME/Pictures/Wallpaper.jpg " + config.get_sources()["wallpaper"])

    print(u'\U0001f5bc' + " Setting wallpaper...")
    if sys.platform == "darwin":
        OSHelper.run_if("sqlite3",
                        "sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "
                        + "\"update data set value = '~/Pictures/Wallpaper.jpg'\" && killall Dock")
    elif sys.platform.startswith('linux'):
        OSHelper.run_if("gsettings",
                        "gsettings set org.gnome.desktop.background picture-uri file://$HOME/Pictures/Wallpaper.jpg")
        OSHelper.run_if("gsettings",
                        "gsettings set org.gnome.desktop.screensaver picture-uri file://$HOME/Pictures/Wallpaper.jpg")
    return


def update_very():
    print(u'\U00002935\U0000fe0f' + "  Updating 'very'...")
    Updater.update_file("updater.py")
    OSHelper.run("python3 updater.py")
    return


def very():
    if len(sys.argv) < 2:
        Printer.error_message(sys.argv[0])
        exit()
    else:
        if sys.argv[1] == "very":
            config.get_config()
            exit()
        elif sys.argv[1] == "install":
            install()
        elif sys.argv[1] == "remove":
            remove()
        elif sys.argv[1] == "search":
            search()
            exit()
        elif sys.argv[1] == "list" or sys.argv[1] == "ls":
            ls()
            exit()
        elif sys.argv[1] == "clean":
            clean()
        elif sys.argv[1] == "wow-clean":
            clean()
            additional_clean()
        elif sys.argv[1] == "update":
            update()
        elif sys.argv[1] == "system-update":
            upgrade()
        elif sys.argv[1] == "much-update":
            update()
            upgrade()
        elif sys.argv[1] == "ip":
            ip()
            exit()
        elif sys.argv[1] == "ping":
            ping()
        elif sys.argv[1] == "download":
            download()
        elif sys.argv[1] == "hosts":
            hosts()
        elif sys.argv[1] == "wallpaper":
            wallpaper()
        elif sys.argv[1] == "very-update":
            update_very()
        elif any(sys.argv[1] in additional["id"] for additional in config.get_additional()):
            additional_command(sys.argv[1])
            exit()
        else:
            print(u'\U0001F6AB' + " Unknown command '" + sys.argv[1] + "'\n")
            Printer.error_message(sys.argv[0])
            exit()
        print(u'\U00002705' + " Done.")


if __name__ == "__main__":
    very()
