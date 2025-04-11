# OVERVIEW
This repo contains code for the Purdue ECE 57000: Introduction to Artificial Intelligence and Machine Learning course project. This project re-implements the work done in [*Goal Reduction with Loop-Removal Accelerates RL and Models Human Brain Activity in Goal-Directed Learning*](https://nips.cc/virtual/2024/poster/94732)

# DEMONSTRATION VIDEO
The following video walks you through setting up and running the code using Google Colab, as well as the key features of the code and outputs that are logged.
VIDEO LINK

## RUNNING CODE ON GOOGLE COLAB

To run this code on Google Colab, download the Jupyter Notebook file in this repository and open it in Google Colab. You will also need to connect to a GPU runtime in Colab.

To run any of the experiments, first execute the first two Google Colab code cells to clone the GitHub repository and install the contents of `requirements.txt`, then navigate to any of the other cells and run it to run the experiment. To adjust the relevant parameters for any of the experiments, modify the flags/variables in the corresponding script file that you can open via the Google Colab files tab.

## RUNNING CODE ON A PERSONAL MACHINE
To run this project on a personal machine, you need Python 3.0, Cython, and CUDA 12.0.

All of the following instructions assume you are running a Git Bash terminal and in the directory one level above the cloned repository directory titled "goal-reducer-reimplementation". 

You can install the necessary Python libraries by cloning the repository and running:
```
pip install -r goal-reducer-reimplementation/requirements.txt
```

To compile and generate an executable file for the c_utils code written in C, run:
```
chmod +x goal-reducer-reimplementation/compile.sh
./goal-reducer-reimplementation/compile.sh
```


To run the sampling strategies experiment, you should run the following:
```
chmod +x goal-reducer-reimplementation/run_sampling.sh
./goal-reducer-reimplementation/run_sampling.sh
```

Running the basic four-room navigation task can be achieved by executing:
```
chmod +x goal-reducer-reimplementation/run_fourroom.sh
./goal-reducer-reimplementation/run_fourroom.sh
```

Other experiments follow the same commands but change the filename to `run_robot.sh` for the robot arm reach task or `run_fourroom19.sh` for the four-room navigation task that compares the three different models. To adjust the relevant parameters for any of the experiments, modify the flags/variables in the corresponding script file.

