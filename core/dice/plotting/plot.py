import io
from threading import Thread

class Plotter(Thread):
    def __init__(self, create_plot_function=None, plot=None, plot_ready_function=None):
        super().__init__()
        self.create_plot_function = create_plot_function
        self.__result = ""
        self.__plot = plot
        self.__plot_ready_function = plot_ready_function
        self.daemon = True
        self.__running = False

    def run(self):
        if self.create_plot_function is not None:
            self.__plot = self.create_plot_function()
        if self.__plot is None:
            return
        s = io.BytesIO()
        self.__plot.savefig(s, format="svg")
        self.__result = s.getvalue().decode('utf-8')
        self.__plot_ready_function()

    def result(self):
        if not self.__running:
            self.__running = True
            self.start()
        return self.__result