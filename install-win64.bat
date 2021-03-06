CALL conda-env remove -y -n machinelearning
ECHO https://ss64.com/nt/start.html - learn to use START / CALL to run sequentially without human interaction
CALL conda create -y -n machinelearning python=3.5 


ECHO theano 0.9 does not work well under windows, but 0.8* does not support python 3.6
ECHO 'conda-env remove -n tensorflow' to remove an environment

CALL conda install -y conda-build
CALL activate machinelearning
CALL conda install -y jupyter

ECHO #####################################
ECHO # Setting up R for Jupyter Notebook
ECHO # could not get it to work in Windows - keep dying
ECHO # https://github.com/IRkernel/IRkernel/issues/498
ECHO # Give up
ECHO #####################################
ECHO sudo apt-get install -y python-qt4 # package required for Ubuntu for R in Jupyter to work properly
ECHO # https://stackoverflow.com/questions/32389599/anaconda-importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-o
ECHO #### the following two lines are to force 3.4.3 instead of 3.5 of R is installed 
ECHO conda install -y mro-base=3.4.3
ECHO conda install -y -c r r-base64enc=0.1_3=mro343h889e2dd_0
ECHO #### the above two lines are to force 3.4.3 instead of 3.5 of R is installed 
ECHO # choose R 3.4.3 because WeightedROC seems to be not available for R 3.5, and get lightGBM
ECHO conda install -y -c r r-essentials r-rms

ECHO #####################################
ECHO # install Machine Learning packages #
ECHO #####################################
CALL conda install -y numpy matplotlib scipy scikit-learn pillow pandas matplotlib seaborn cython
pip install PyHamcrest imagehash hyperopt kaggle 
ECHO # PyHamcrest is required for kaggle, cython is required for mkl-random

CALL conda install -y mingw libpython py-xgboost 

ECHO #####################################
ECHO # install Deep Learn Package #
ECHO #####################################
CALL conda install -y theano=0.8
REM theano 0.9 does not work in Windows Python 3.5 or 3.6, whether installed by pip or conda
REM theano 0.8 works, but require Windows Python 3.5, not compatible with Python 3.6

CALL conda install -y pyyaml HDF5 h5py
pip install keras==1.2.2 
REM use a fixed version of Keras so that package update won't necessitate code change

REM pip error reference: http://jakzaprogramowac.pl/pytanie/92058,pip-throws-typeerror-parse-got-an-unexpected-keyword-argument-39-transport-encoding-39-when-trying-to-install-new-packages
REM Download https://github.com/html5lib/html5lib-python/tree/master/html5lib and overwrite all the files within html5lib folder 
REM in your tensorflow environment "envs\tensorflow\Lib\site-packages\html5lib" Then you should be able to run any "pip install" commands after that

REM Install Tensorflow 1.2
pip install tensorflow==1.2
