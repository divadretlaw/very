import json
import sys

from osHelper import OSHelper
from printer import Printer


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class Configuration(metaclass=Singleton):
    def __init__(self):
        with open('very/very.json') as data_file:
            self.data = json.load(data_file)
#        with open(OSHelper.home() + '/.config/very/very.json') as data_file:
#            self.data = json.load(data_file)

    def get_sources(self):
        return self.data["sources"]

    def get_package_mangers(self):
        return self.data["package_managers"]

    def get_additional(self):
        return self.data["additional"]

    def get_additional_commands_of(self, id_):
        for packageManger in self.get_additional():
            if packageManger["id"] == id_:
                return packageManger

    def get_config(self):
        if len(sys.argv) < 3:
            Printer.error_message(sys.argv[0])
        else:
            if sys.argv[2] == "ls":
                Printer.commands()
            elif sys.argv[2] == "description":
                Printer.descriptions()
            elif sys.argv[2] == "additional":
                for x in self.get_additional():
                    if OSHelper.has_package(x["command"]):
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
                Printer.error_message(sys.argv[0])
        return

    def get_main_package_manager(self):
        for packageManger in self.get_package_mangers():
            if OSHelper.has_package(packageManger["command"]):
                return packageManger
