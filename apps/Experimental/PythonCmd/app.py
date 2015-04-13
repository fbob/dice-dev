# Standard Python modules
# =======================
import os
import numpy
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
from multiprocessing import Queue

# DICE modules
# ============
from core.app import BasicApp
from core.dice.plotting.plot import Plotter


class PythonCmd(BasicApp):
    app_name = "PythonCmd"
    input_types = ["file"]
    output_types = ["file"]

    def __init__(self, parent, instance_name, status):
        BasicApp.__init__(self, parent, instance_name, status)
        self.code = ""
        self.__plot = None
        self.__plotter = Plotter(create_plot_function=self.create_plot, plot_ready_function=self.replot)
        self.q = Queue()

    @classmethod
    def accepts_input_app(cls, app):
        return True

    def set_code(self, code):
        self.code = code
        with open(self.config_path("code.py"), "w") as pf:
            pf.write(self.code)

    def get_code(self):
        if self.code.strip() == "" and os.path.exists(self.config_path("code.py")):
            with open(self.config_path("code.py")) as pf:
                self.code = pf.read()
        return self.code

    def run(self):
        self.debug(str(self.code))
        try:
            exec(self.code)
            return True
        except Exception as ex:
            self.debug("exception: \n"+str(ex))
            return False

    def replot(self):
        self.signal("plotChanged")

    def get_plot(self):
        # if self.__plot is None:
        #     self.__plot = self.create_plot()
        # plotter = Plotter(plot=self.__plot)
        self.debug("get_plot")
        return self.__plotter.result()

    def clear_plot(self):
        if self.__plot:
            self.__plot.clf()
            self.__plot.cla()

    def create_plot(self):
        """
        example plot data
        """
        mu = 100 # mean of distribution
        sigma = 15 # standard deviation of distribution
        x = mu + sigma * numpy.random.randn(10000)
        plt.cla()
        plt.clf()

        num_bins = 50
        # the histogram of the data
        n, bins, patches = plt.hist(x, num_bins, normed=1, facecolor='green', alpha=0.5)
        # add a 'best fit' line
        y = mlab.normpdf(bins, mu, sigma)
        plt.plot(bins, y, 'r--')
        plt.xlabel('Smarts')
        plt.ylabel('Probability')
        plt.title(r'Histogram of IQ: $\mu=100$, $\sigma=15$')

        # Tweak spacing to prevent clipping of ylabel
        plt.subplots_adjust(left=0.15)
        return plt

    def run_thread(self):
        from _thread import start_new_thread

        def f():
            while True:
                self.log(self.q.get())

        start_new_thread(f, () )

    def run_multi(self):
        from multiprocessing import Process

        def f(name, q):
            from time import sleep
            i=0
            while True:
                sleep(2)
                q.put("hello from process "+str(i))
                i+=1

        p = Process(target=f, args=('bob', self.q))
        p.start()
        # p.join()