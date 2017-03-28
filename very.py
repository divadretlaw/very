import os
import sys
import json

home = os.path.expanduser("~")

with open(home + '/.config/very/very.json') as data_file:
    config = json.load(data_file)


def get_config():
    if len(sys.argv) < 3:
        print_error_message(sys.argv[0])
    else:
        if sys.argv[2] == "ls":
            print_commands()
        elif sys.argv[2] == "description":
            print_descriptions()
        elif sys.argv[2] == "additional":
            for x in config["additional"]:
                if has_package(x["command"]):
                    print(x["id"])
        elif sys.argv[2] == "cmd":
            print("install")
            print("remove")
            print("clean")
            print("update")
            print("upgrade")
            print("search")
            print("list")
        else:
            print_error_message(sys.argv[0])
    return


def get_main_package_manager():
    for x in config["package-managers"]:
        if has_package(x["command"]):
            return x


def has_package(package):
    return os.popen("command -v " + package).read() != ""


def print_error_message(filename):
    print("Usage: python " + filename + " [command]")
    print("\n" + u'\U00002139\U0000fe0f' + "  Available commands:")
    print_commands()
    return


def print_commands():
    print("install")
    print("remove")
    print("search")
    print("ls")
    print("clean")
    print("update")
    print("system-update")
    print("much-update")
    print("very-update")
    print("ip")
    print("download")
    print("hosts")
    print("wallpaper")

    for x in config["additional"]:
        if has_package(x["command"]):
            print(x["id"])

    return


def print_descriptions():
    print("Install one or more packages")  # install
    print("Remove one or more packages")  # remove
    print("Search for packages by name") # search
    print("List installed packages") # ls
    print("Cleans the system")  # clean
    print("Checks for package updates and installs them")  # update
    print("Checks for system updates and installs them")  # system-update
    print("Checks for package and system updates and installs them")  # much-update
    print("Updates the script to the newest version")  # very-update
    print("Prints global IP")  # ip
    print("Starts a download test")  # download
    print("Updates /etc/hosts")  # hosts
    print("Sets the wallpaper")  # wallpaper

    for x in config["additional"]:
        if has_package(x["command"]):
            print(x["command"])

    return


def get_additional_commands(id):
    for x in config["additional"]:
        if x["id"] == id:
            return x


def additional_command(command):
    cmd = get_additional_commands(command)

    if cmd is not None:
        packages = ""
        for x in range(3, len(sys.argv)):
            packages += " " + sys.argv[x]

        if sys.argv[2] in cmd and cmd[sys.argv[2]] != "":
            os.system(cmd[sys.argv[2]] + packages)
        else:
            print("Unknown command")
            exit()

    return


def commands(from_):
    commands = ""
    for x in range(from_, len(sys.argv)):
        commands += " " + sys.argv[x]
    return commands


def install():
    packages = commands(2)

    x = get_main_package_manager()
    if x is not None:
        print(u'\U00002795' + "  Installing packages using '" + x["command"] + "'...")
        os.system(x["install"] + packages)
    return


def remove():
    packages = commands(2)

    x = get_main_package_manager()
    if x is not None:
        print(u'\U00002796' + "  Removing packages using '" + x["command"] + "'...")
        os.system(x["remove"] + packages)
    return


def search():
    packages = commands(2)
    
    x = get_main_package_manager()
    if x is not None:
        print("Searching packages from '" + x["search"] + "'...")
        os.system(x["search"] + packages)
    return


def ls():
    packages = commands(2)
    
    x = get_main_package_manager()
    if x is not None:
        print("Listing installed from using '" + x["list"] + "'...")
        os.system(x["list"] + packages)
    return


def clean():
    print(u'\U0000267B\U0000fe0f' + "  Cleaning system...")
    for x in config["package-managers"]:
        if has_package(x["command"]):
            os.system(x["clean"])
    for x in config["additional"]:
        if has_package(x["command"]) and x["clean"] != "":
            os.system(x["clean"])
    print(u'\U0001f5d1' + "  Emptying trash...")
    if sys.platform == "darwin":
        os.system("rm -rf $HOME/.Trash/*")
    else:
        os.system("rm -rf $HOME/.local/share/Trash/files/*")
        os.system("rm -rf $HOME/.local/share/Trash/info/*.trashinfo")
    return


def update():
    for p in config["package-managers"]:
        if has_package(p["command"]):
            print(u'\U0001f504' + "  Updating packages using '" + p["command"] + "'...")
            os.system(p["update"])
            os.system(p["upgrade"])

    for x in config["additional"]:
        if has_package(x["command"]):
            if (x["update"] != ""):
                print(u'\U0001f504' + "  Updating packages using '" + x["command"] + "'...")
                os.system(x["update"])
                if (x["upgrade"] != ""):
                    os.system(x["upgrade"])
    return


def upgrade():
    print(u'\U0001f504' + "  Upgrading System...")
    for p in config["package-managers"]:
        if has_package(p["command"]):
            os.system(p["system-upgrade"])
    return


def ip():
    os.system("curl " + config["ip-source"])
    return


def download():
    print(u'\U00002b07\U0000fe0f' + "  Starting download test...")
    os.system("curl -SLko /dev/null " + config["downloadtest-source"])
    return


def hosts():
    print(u'\U0001F4DD' + "  Updating '/etc/hosts' from '" + config["hosts-source"] + "'...")
    os.system("echo '127.0.0.1 localhost\n::1 localhost\n255.255.255.255 broadcasthost\n127.0.0.1 " + os.uname()[
        1] + "\n' | sudo tee /etc/hosts > /dev/null")
    os.system("curl -#SLk " + config["hosts-source"] + " | grep 0.0.0.0 | sudo tee -a /etc/hosts > /dev/null")
    return


def wallpaper():
    print(u'\U00002b07\U0000fe0f' + "  Downloading Wallpaper from '" + config["wallpaper-source"] + "'...")
    os.system("curl -#SLko $HOME/Pictures/Wallpaper.jpg " + config["wallpaper-source"])

    print(u'\U0001f5bc' + "  Setting wallpaper...")
    if sys.platform == "darwin":
        os.system(
            "sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db \"update data set value = '~/Pictures/Wallpaper.jpg'\" && killall Dock")
    elif sys.platform.startswith('linux'):
        if has_package("gsettings"):
            os.system("gsettings set org.gnome.desktop.background picture-uri file://$HOME/Pictures/Wallpaper.jpg")
            os.system("gsettings set org.gnome.desktop.screensaver picture-uri file://$HOME/Pictures/Wallpaper.jpg")
    return


def update_very():
    print(u'\U00002935\U0000fe0f' + "  Updating 'very'...")
    os.system("curl -#SLko $HOME/.very.py https://raw.githubusercontent.com/divadretlaw/very/master/very.py")
    return


if len(sys.argv) < 2:
    print_error_message(sys.argv[0])
    exit()
else:
    if sys.argv[1] == "very":
        get_config()
        exit()
    elif sys.argv[1] == "install":
        install()
    elif sys.argv[1] == "remove":
        remove()
    elif sys.argv[1] == "search":
        search()
    elif sys.argv[1] == "ls":
        ls()
    elif sys.argv[1] == "clean":
        clean()
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
    elif sys.argv[1] == "download":
        download()
    elif sys.argv[1] == "hosts":
        hosts()
    elif sys.argv[1] == "wallpaper":
        wallpaper()
    elif sys.argv[1] == "very-update":
        update_very()
    elif any(sys.argv[1] in s["id"] for s in config["additional"]):
        additional_command(sys.argv[1])
    else:
        print_error_message(sys.argv[0])
        exit()
    print(u'\U00002705' + "  Done.")
