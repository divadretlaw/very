import os


class OSHelper:

    @staticmethod
    def home():
        return os.path.expanduser("~")

    @staticmethod
    def name():
        return os.uname()[1]

    @staticmethod
    def has_package(package):
        return os.popen("command -v " + package).read() != ""

    @staticmethod
    def run(run):
        if run is not None and run != "":
            os.system(run)

    @staticmethod
    def run_if(package, command):
        if OSHelper.has_package(package):
            OSHelper.run(command)

    @staticmethod
    def run_and_print(package_manager, command, arguments, message):
        if package_manager is not None:
            if package_manager[command] != "":
                if message is not None and message != "":
                    print(message)
                OSHelper.run(package_manager[command] + arguments)
