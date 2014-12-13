#!/bin/bash -ex

# Cleanup that is necessary if this job is run on a node that previously had
# this job run on it.
rm -rf qiime-deploy qiime-deploy-conf qiime_software anaconda
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?log-level: INFO?log-level: DEBUG?" qiime-deploy-conf/qiime-dev/qiime.conf

# Setup for python and core dependencies available via Miniconda. Taken and
# modified from https://github.com/biocore/bipy/blob/master/.travis.yml and
# https://gist.github.com/dan-blanchard/7045057
wget -q http://repo.continuum.io/miniconda/Miniconda-2.2.2-Linux-x86_64.sh -O miniconda.sh
chmod +x miniconda.sh
./miniconda.sh -b -p $WORKSPACE/anaconda
export PATH=$WORKSPACE/anaconda/bin:$PATH
conda update --quiet --yes conda
conda create --quiet --yes -n test_env python=2.7 pip numpy=1.7.1 scipy=0.13.0 matplotlib h5py>=2.2.0
source activate test_env

# Install QIIME and the rest of its Python dependencies.
pip install --allow-all-external --allow-unverified bipy --process-dependency-links $WORKSPACE/qiime

# Install QIIME's non-Python dependencies.
cp -r /home/ubuntu/qiime_software .
rm -rf qiime_software/*-latest-r-package qiime_software/r-*-release
python qiime-deploy/qiime-deploy.py qiime_software -f qiime-deploy-conf/qiime-dev/qiime.conf --force-remove-failed-dirs --force-remove-previous-repos
sed -i -e's/97_otus.fasta/61_otus.fasta/' qiime_software/qiime_config
sed -i -e's/97_otu_taxonomy.txt/61_otu_taxonomy.txt/' qiime_software/qiime_config
source qiime_software/activate.sh
export PATH=/home/ubuntu/jenkins-support:$PATH

# We can finally test QIIME!
print_qiime_config.py -t
python $WORKSPACE/qiime/tests/all_tests.py
