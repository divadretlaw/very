import json

from process import Process
from printer import Printer


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class Configuration(metaclass=Singleton):
    def __init__(self):
        with open(Process.home() + '/.config/very/very.json') as data_file:
            self.data = json.load(data_file)

    def get_sources(self) -> dict:
        return self.data["sources"]

    def get_package_mangers(self) -> dict:
        return self.data["package_managers"]

    def get_additional(self) -> dict:
        return self.data["additional"]

    def get_additional_commands_of(self, name: str) -> dict:
        for packageManger in self.get_additional():
            if packageManger["id"] == name:
                return packageManger

    def get_config(self, name: str, argument: str):
        if argument is None:
            Printer.error_message(name)
        else:
            if argument == "ls":
                Printer.commands()
            elif argument == "description":
                Printer.descriptions()
            elif argument == "additional":
                for x in self.get_additional():
                    if Process.has_package(x["command"]):
                        print(x["id"])
            elif argument == "cmd":
                print("install")
                print("remove")
                print("clean")
                print("update")
                print("upgrade")
                print("search")
                print("list")
            else:
                Printer.error_message(name)
        return

    def get_main_package_manager(self) -> dict:
        for packageManger in self.get_package_mangers():
            if Process.has_package(packageManger["command"]):
                return packageManger
