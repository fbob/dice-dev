from sys import stderr
from core.app import BasicApp
from threading import _start_new_thread

def debug(msg):
    stderr.write(msg+"\n")
    stderr.flush()


class Scheduler:
    def __init__(self, project):
        self.__project = project
        self.__run_stack = []
        self.__prepare_stack = []

    def schedule_run(self, app):
        """
        Tries to run an application. The algorithm is to get all input apps into the FINISHED state
        (by calling schedule_run for them if needed) and calling prepare() and run() for the actual app.
        :param app:
        :return:
        """
        # debug("schedule run for "+str(app))
        if app in self.__run_stack:
            # debug("stack contains "+str(app))
            return
        self.__run_stack.append(app)
        # app.connect("statusChanged", self.__process_run_signals(app))
        app.status_changed.connect(self.__process_run_signals(app))
        _start_new_thread(self.__schedule_run, (app,))

    def schedule_prepare(self, app):
        # TODO
        app.prepare()

    def __process_run_signals(self, app):
        """
        Returns a function that handles status changes for the given scheduled app.
        :param app:
        :return:
        """
        def status_change_handler():
            # debug(str(app)+" changed status to "+app.get_status())
            if app.status == BasicApp.FINISHED:
                try:
                    self.__run_stack.remove(app)
                except:
                    pass
                # app.disconnect("statusChanged", status_change_handler)
                app.status_changed.disconnect(status_change_handler)
                for output_app in app.output_apps:
                    if output_app in self.__run_stack:
                        self.__try_run(output_app)
            elif app.status == BasicApp.ERROR:
                try:
                    self.__run_stack.remove(app)
                except:
                    pass
        return status_change_handler

    def __schedule_run(self, app):
        """
        Scheduling part of schedule_run, extracted to run in its own thread
        :param app:
        :return:
        """
        to_schedule = self.__try_run(app)
        # add the input apps to the scheduler if they are not finished
        for input_app in to_schedule:
            self.schedule_run(input_app)

    def __try_run(self, app):
        """
        Tries to run the given app if all inputs apps of the app are finished.
        Otherwise it returns a list of all unfinished input apps.
        :param app:
        :return:
        """
        all_input_apps_are_finished = True
        to_schedule = []

        for input_app in app.input_apps:
            if input_app.status != BasicApp.FINISHED:
                all_input_apps_are_finished = False
                to_schedule.append(input_app)

        if all_input_apps_are_finished:
            # This is the default run behavior:
            # prepare() if not already prepared and call run() if prepare() was successful

            prepared = app.status == BasicApp.PREPARED

            if not prepared:
                app.status = BasicApp.PREPARING
                try:
                    if app.prepare():
                        app.status = BasicApp.PREPARED
                        prepared = True
                except BaseException as e:
                    app.status = BasicApp.ERROR
                    self.__project.dice.process_exception(e)
                    return []  # do not schedule any more apps

            if prepared:
                app.status = BasicApp.RUNNING
                try:
                    if app.run():
                        app.status = BasicApp.FINISHED
                    else:
                        app.status = BasicApp.ERROR
                except BaseException as e:
                    app.status = BasicApp.ERROR
                    self.__project.dice.process_exception(e)
                    return []  # do not schedule any more apps
        else:
            # Set on WAITING. If called by schedule_run, all apps in to_schedule will be scheduled as well.
            # This will cause __process_run_signals to call __try_run again as needed.
            app.status = BasicApp.WAITING
        return to_schedule
