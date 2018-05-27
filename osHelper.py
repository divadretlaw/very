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
    def run_if(check, run):
        if OSHelper.has_package(check):
            OSHelper.run(run)
