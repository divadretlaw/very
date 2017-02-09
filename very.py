import os
import sys
import json

home = os.path.expanduser("~")

with open(home + '/.config/very/very.json') as data_file:
    config = json.load(data_file)

def getConfig():
    if len(sys.argv) < 3:
        errorMessage(sys.argv[0])
    else:
        if sys.argv[2] == "ls":
            printCommands()
        elif sys.argv[2] == "description":
            printDescriptions()
        elif sys.argv[2] == "search":
            x = getPackageManager()
            if x is not None:
                os.system(x["search"])
        elif sys.argv[2] == "list":
            x = getPackageManager()
            if x is not None:
                os.system(x["list"])
        else:
            errorMessage(sys.argv[0])
    return


def getPackageManager():
    for x in config["package-managers"]:
        if hasPackage(x["id"]):
            return x


def hasPackage(package):
    return os.popen("command -v " + package).read() != ""


def errorMessage(file):
    print("Usage: python " + file + " [command]")
    print("\nAvailable commands:")
    printCommands()
    return


def printCommands():
    print("install")
    print("remove")
    print("clean")
    print("update")
    print("system-update")
    print("much-update")
    print("very-update")
    print("ip")
    print("download")
    print("hosts")
    print("wallpaper")
    return


def printDescriptions():
    print("Install one ore more packages")  # install
    print("Remove one ore more packages")  # remove
    print("Cleans the system")  # clean
    print("Checks for package updates and installs them")  # update
    print("Checks for system updates and installs them")  # system-update
    print("Checks for package and system updates and installs them")  # much-update
    print("Updates the script to the newest version")  # very-update
    print("Prints global IP")  # ip
    print("Starts a download test")  # download
    print("Updates /etc/hosts from winhelp2002.mvps.org")  # hosts
    print("Sets the wallpaper")  # wallpaper
    return


def installPackages():
    packages = ""
    for x in range(2, len(sys.argv)):
        packages += " " + sys.argv[x]

    x = getPackageManager()
    if x is None:
        return
    print(u'\U00002795' + "  Install packages using '" + x["id"] + "'...")
    os.system(x["install"] + packages)
    return


def removePackages():
    packages = ""
    for x in range(2, len(sys.argv)):
        packages += " " + sys.argv[x]

    x = getPackageManager()
    if x is not None:
        print(u'\U00002796' + "  Removing packages using '" + x["id"] + "'...")
        os.system(x["remove"] + packages)
    return


def clean():
    print(u'\U0000267B\U0000fe0f' + "  Cleaning system...")
    for x in config["package-managers"]:
        if hasPackage(x["id"]):
            os.system(x["clean"])
    print(u'\U0001f5d1' + "  Emptying trash...")
    if sys.platform == "darwin":
        os.system("rm -rf $HOME/.Trash/*")
    else:
        os.system("rm -rf $HOME/.local/share/Trash/files/*")
        os.system("rm -rf $HOME/.local/share/Trash/info/*.trashinfo")
    return


def download():
    print(u'\U00002b07\U0000fe0f' + "  Starting download test...")
    os.system("curl -SLko /dev/null " + config["downloadtest-source"])
    return


def updateSystem():
    for p in config["package-managers"]:
        if hasPackage(p["id"]):
            print(u'\U0001f504' + "  Updating packages using '" + p["id"] + "'...")
            os.system(p["update"])
            os.system(p["upgrade"])

    for x in config["additional"]:
        if hasPackage(x["id"]):
            print(u'\U0001f504' + "  Updating packages using '" + x["id"] + "'...")
            os.system(x["update"])
    return


def upgradeSystem():
    print(u'\U0001f504' + "  Upgrading System...")
    for p in config["package-managers"]:
        if hasPackage(p["id"]):
            os.system(p["system-upgrade"])
    return


def setWallpaper():
    print(u'\U00002b07\U0000fe0f' + "  Downloading Wallpaper from '" + config["wallpaper-source"] + "'...")
    os.system("curl -#SLko $HOME/Pictures/Wallpaper.jpg " + config["wallpaper-source"])

    print(u'\U0001f5bc' + "  Setting wallpaper...")
    if sys.platform == "darwin":
        os.system(
            "sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db \"update data set value = '~/Pictures/Wallpaper.jpg'\" && killall Dock")
    elif sys.platform.startswith('linux'):
        if hasPackage("gsettings"):
            os.system("gsettings set org.gnome.desktop.background picture-uri file://$HOME/Pictures/Wallpaper.jpg")
            os.system("gsettings set org.gnome.desktop.screensaver picture-uri file://$HOME/Pictures/Wallpaper.jpg")
    return


def updateVery():
    print(u'\U00002935\U0000fe0f' + "  Updating 'very'...")
    os.system("curl -#SLko $HOME/.very.py https://raw.githubusercontent.com/divadretlaw/very/master/very.py")
    return


def updateHosts():
    print(u'\U0001F4DD' + "  Updating '/etc/hosts'...")
    os.system("echo '127.0.0.1 localhost\n::1 localhost\n255.255.255.255 broadcasthost\n127.0.0.1 " + os.uname()[1] + "\n' | sudo tee /etc/hosts > /dev/null")
    os.system("curl -#SLk http://winhelp2002.mvps.org/hosts.txt | grep 0.0.0.0 | sudo tee -a /etc/hosts > /dev/null")
    return


def ip():
    os.system("curl " + config["ip-source"])
    exit()
    return


if len(sys.argv) < 2:
    errorMessage(sys.argv[0])
else:
    if sys.argv[1] == "very":
        getConfig()
    elif sys.argv[1] == "install":
        installPackages()
    elif sys.argv[1] == "remove":
        removePackages()
    elif sys.argv[1] == "clean":
        clean()
    elif sys.argv[1] == "update":
        updateSystem()
    elif sys.argv[1] == "system-update":
        upgradeSystem()
    elif sys.argv[1] == "much-update":
        updateSystem()
        upgradeSystem()
    elif sys.argv[1] == "download":
        download()
    elif sys.argv[1] == "hosts":
        updateHosts()
    elif sys.argv[1] == "ip":
        ip()
    elif sys.argv[1] == "wallpaper":
        setWallpaper()
    elif sys.argv[1] == "very-update":
        updateVery()
    else:
        errorMessage(sys.argv[0])
    print(u'\U00002705' + "  Done.")
