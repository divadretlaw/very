#!/usr/bin/env python3
# coding: utf-8

import datetime
import sys

from configuration import Configuration
from process import Process
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

        for index in range(3, len(sys.argv)):
            packages += " " + sys.argv[index]

        if sys.argv[2] in commands and commands[sys.argv[2]] != "":
            Process.run(commands[sys.argv[2]] + packages)
        else:
            print(u'\U0001F6AB' + " Unknown subcommand of '" + sys.argv[1] + "'")
    return


def arguments_from(index: int):
    arguments = ""
    for x in range(index, len(sys.argv)):
        arguments += " " + sys.argv[x]
    return arguments


def install():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    message = u'\U00002795' + " Installing packages using '" + main["command"] + "'..."
    Process.run_with_message(main, "install", packages, message)
    return


def remove():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    message = u'\U00002795' + " Removing packages using '" + main["command"] + "'..."
    Process.run_with_message(main, "remove", packages, message)
    return


def search():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    Process.run_with_message(main, "search", packages, None)
    return


def ls():
    packages = arguments_from(2)

    main = config.get_main_package_manager()
    Process.run_with_message(main, "list", packages, None)
    return


def clean():
    main = config.get_main_package_manager()
    Process.run_with_message(main, "clean", "", u'\U0000267B\U0000fe0f' + "  Cleaning system...")

    for packageManger in config.get_additional():
        Process.run_if_has(packageManger["command"], packageManger["clean"])

    print(u'\U0001f5d1' + "  Emptying trash...")

    if sys.platform == "darwin":
        Process.run("rm -rf $HOME/.Trash/*")
    else:
        Process.run("rm -rf $HOME/.local/share/Trash/files/*")
        Process.run("rm -rf $HOME/.local/share/Trash/info/*.trashinfo")

    return


def additional_clean():
    print(u'\U0000267B\U0000fe0f' + "  Running additional clean commands...")

    for command in config.data["additional_clean_commands"]:
        print("Running '" + command + "'...")
        Process.run(command)
    return


def update():
    main = config.get_main_package_manager()
    message = u'\U0001f4e6' + " Updating packages using '" + main["command"] + "'..."
    Process.run_with_message(main, "update", "", message)
    Process.run_with_message(main, "upgrade", "", None)

    for packageManager in config.get_additional():
        if Process.has_package(packageManager["command"]):
            message = u'\U0001f4e6' + " Updating packages using '" + packageManager["command"] + "'..."
            Process.run_with_message(packageManager, "update", "", message)
            Process.run_with_message(packageManager, "upgrade", "", None)
    return


def upgrade():
    print(u'\U0001f504' + " Upgrading System...")
    for packageManager in config.get_package_mangers():
        Process.run_if_has(packageManager["command"], packageManager["system_upgrade"])
    return


def ip():
    Process.run("curl " + config.get_sources()["ip"])
    return


def ping():
    print(u'\U0001F310' + " Starting ping test...")
    Process.run("ping " + config.get_sources()["ping"])
    return


def download():
    print(u'\U00002b07\U0000fe0f' + "  Starting download test...")
    Process.run("curl -sLko /dev/null " + config.get_sources()["downloadtest"])
    return


def hosts():
    hosts_config = config.get_sources()["hosts"]
    sudo = ""
    if hosts_config["sudo"]:
        sudo = "sudo"

    target = hosts_config["target"]

    print(u'\U0001F4DD' + " Updating '" + target + "' from '" + hosts_config["source"] + "'...")

    Process.run("echo '# Last updated: {:%Y-%m-%d %H:%M:%S}".format(
        datetime.datetime.now()) + "\n' | " + sudo + " tee " + target + " > /dev/null")

    if hosts_config["defaults"]:
        Process.run(
            "echo '127.0.0.1 localhost\n::1 localhost\n255.255.255.255 broadcasthost\n127.0.0.1 "
            + Process.uname()
            + "\n' | "
            + sudo + " tee -a "
            + target + " > /dev/null")

    Process.run("curl -#SLk " + hosts_config[
        "source"] + " | grep '^[^#]' | grep 0.0.0.0 | " + sudo + " tee -a " + target + " > /dev/null")
    return


def wallpaper():
    print(u'\U00002b07\U0000fe0f' + "  Downloading Wallpaper from '" + config.get_sources()["wallpaper"] + "'...")
    Process.run("curl -#SLko $HOME/Pictures/Wallpaper.jpg " + config.get_sources()["wallpaper"])

    print(u'\U0001f5bc' + " Setting wallpaper...")
    if sys.platform == "darwin":
        Process.run_if_has("sqlite3",
                           "sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "
                           + "\"update data set value = '~/Pictures/Wallpaper.jpg'\" && killall Dock")
    elif sys.platform.startswith('linux'):
        Process.run_if_has("gsettings",
                           "gsettings set org.gnome.desktop.background picture-uri file://$HOME/Pictures/Wallpaper.jpg")
        Process.run_if_has("gsettings",
                           "gsettings set org.gnome.desktop.screensaver picture-uri file://$HOME/Pictures/Wallpaper.jpg")
    return


def update_very():
    print(u'\U00002935\U0000fe0f' + "  Updating 'very'...")
    Updater.update_file("updater.py")
    Process.run("python3 updater.py")
    return


def very():
    name = sys.argv[0]
    if len(sys.argv) < 2:
        Printer.error_message(name)
        exit()
    else:
        if sys.argv[1] == "very":
            config.get_config(name, sys.argv[2])
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
            Printer.error_message(name)
            exit()
        print(u'\U00002705' + " Done.")


if __name__ == "__main__":
    very()
