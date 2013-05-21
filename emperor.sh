#!/bin/bash -ex
source /home/ubuntu/qiime_software/activate.sh
export PATH=$WORKSPACE/emperor/scripts:$PATH
export PYTHONPATH=$WORKSPACE/emperor:$PYTHONPATH
python emperor/tests/all_tests.py
