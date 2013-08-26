#!/bin/bash -ex
export PATH=$WORKSPACE/pyqi/scripts:$PATH
export PYTHONPATH=$WORKSPACE/pyqi:$PYTHONPATH
cd pyqi/tests
nosetests
pyqi
