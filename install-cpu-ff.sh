# This script is designed to work with ubuntu 16.04 LTS, with CPU only system (e.g. Google Cloud Platform)
# It prepare a ML environment ('machinelearning') with some of the most common packages
# including R and IPython

# Forked from: https://github.com/fastai/courses/blob/master/setup/install-gpu.sh
# Download the RAW one here: "wget https://raw.githubusercontent.com/ChongFF/dl-script-code/master/install-cpu-ff.sh"
# Run the script by typing: "bash <script_name.sh>"

# Wish-list:
# 2) Run jupytr notebook in Tensorflow Docker Image
#    https://stackoverflow.com/questions/33636925/how-do-i-start-tensorflow-docker-jupyter-notebook
# 3) Or try deploying a tensorflow-gpu container (listed on Google Container Registry) to Compute instance
#    http://b.gcr.io/tensorflow/tensorflow

# *****************
# * Tech Details: *
# *****************
# ensure system is updated and has basic build tools
sudo apt-get update
sudo apt-get --assume-yes upgrade
# dtrx preferred over bzip2 because dtrx handles a wide range of archive format 7zip, zip, ...
# cmake is needed for lightGBM compilation
sudo apt-get --assume-yes install dtrx tmux build-essential gcc g++ make cmake binutils
sudo apt-get --assume-yes install software-properties-common

# download and install GPU drivers
mkdir downloads
cd downloads

# install MiniConda and some common packages for current user
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b # DO NOT sudo bash this or could not update the packages

echo "export PATH=\"$HOME/miniconda3/bin:\$PATH\"" >> ~/.bashrc
export PATH="$HOME/miniconda3/bin:$PATH"
conda create -y -n machinelearning python=3.5
source activate machinelearning

conda install -y pandas numpy scikit-learn jupyter pillow cython
conda install -y bcolz
conda upgrade -y --all

# install and configure theano (pip install will install too new a version)
conda install -y theano

# install and configure keras
pip install keras==1.2.2 # use a fixed version of Keras so that package update won't necessitate code change

mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

# Install Tensorflow 1.2
pip install tensorflow==1.2

# create a SSL certificate for SSL connection
cd ~/
mkdir ssl
cd ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout "cert.key" -out "cert.pem" -batch

# configure jupyter and prompt for password
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.certfile = u'$HOME/ssl/cert.pem' # path to the certificate we generated" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.keyfile = u'$HOME/ssl/cert.key' # path to the certificate key we generated" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.IPKernelApp.pylab = 'inline'  # in-line figure when using Matplotlib" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*' # serve the notebooks locally
c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

# Installing commonly used packages
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

# install lightGBM for R
git clone --recursive https://github.com/Microsoft/LightGBM
cd LightGBM/R-package
# export CXX=g++-7 CC=gcc-7  # macOS users, if you decided to compile with gcc, don't forget to specify compilers (replace "7" with version of gcc installed on your machine)
R CMD INSTALL --build . --no-multiarch

# Prompt to start Jupyter Notebook Server
cd ~
echo "Remember the change the IP type from ephemeral to static, and add IP to firewall rule"
echo "Type exit to close the current SSH connection, then start a new SSH connection so that PATH variable could be updated"
echo "Type \"source activate machinelearning\" to start the conda environment machinelearning which has Jupyter installed "
echo "\"jupyter notebook --ip=0.0.0.0\" will start Jupyter on port 8888 and accessible from the external IP address"
