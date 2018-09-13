ECHO https://ss64.com/nt/start.html - learn to use START / CALL to run sequentially without human interaction
conda create -y -n machinelearning python=3.5 
ECHO theano 0.9 does not work well under windows, but 0.8* does not support python 3.6
ECHO 'conda-env remove -n tensorflow' to remove an environment
conda install -y conda-build
activate machinelearning

conda install -y numpy matplotlib scipy scikit-learn pillow pandas jupyter cython
conda install -y mingw libpython
conda install -y theano=0.8
REM theano 0.9 does not work in Windows Python 3.5 or 3.6, whether installed by pip or conda
REM theano 0.8 works, but require Windows Python 3.5, not compatible with Python 3.6
conda install -y pyyaml HDF5 h5py
pip install keras==1.2.2 # use a fixed version of Keras so that package update won't necessitate code change

REM pip error reference: http://jakzaprogramowac.pl/pytanie/92058,pip-throws-typeerror-parse-got-an-unexpected-keyword-argument-39-transport-encoding-39-when-trying-to-install-new-packages
REM Download https://github.com/html5lib/html5lib-python/tree/master/html5lib and overwrite all the files within html5lib folder 
REM in your tensorflow environment "envs\tensorflow\Lib\site-packages\html5lib" Then you should be able to run any "pip install" commands after that

# Install Tensorflow 1.2
pip install tensorflow==1.2

ECHO #####################################
ECHO # install Machine Learning packages #
ECHO #####################################
pip install PyHamcrest imagehash hyperopt kaggle #PyHamcrest is required for kaggle
conda install -y py-xgboost matplotlib seaborn 

# Setting up R for Jupyter Notebook
sudo apt-get install -y python-qt4 # package required for Ubuntu for R in Jupyter to work properly
# https://stackoverflow.com/questions/32389599/anaconda-importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-o

#### the following two lines are to force 3.4.3 instead of 3.5 of R is installed 
conda install -y mro-base=3.4.3
conda install -y -c r r-base64enc=0.1_3=mro343h086d26f_0
#### the above two lines are to force 3.4.3 instead of 3.5 of R is installed 
# choose R 3.4.3 because WeightedROC seems to be not available for R 3.5, and get lightGBM
conda install -y -c r r-essentials r-rms
