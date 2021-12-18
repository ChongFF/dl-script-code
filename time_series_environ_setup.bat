conda create --name atfl python=3.6.8
conda activate atfl
ECHO Don't try to mix pip install and conda install, or it will get stuck
ECHO Replace pyzmq with lwoer version to make sure Jupyter Notebook would still work
pip uninstall pyzmq
pip install pyzmq==19.0.2
pip install mxnet gluonts
ECHO Don't use mxnet-mkl -- model don't work
pip install jupyter pyodps sklearn hyperopt ujson
