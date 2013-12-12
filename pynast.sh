#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf pynast_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?repository-location: git://github.com/qiime/pynast.git?repository-location: $WORKSPACE/pynast\nlocal-repository: yes?" qiime-deploy-conf/pynast-dev/pynast.conf
cp -r /home/ubuntu/qiime_software pynast_software
python qiime-deploy/qiime-deploy.py pynast_software -f qiime-deploy-conf/pynast-dev/pynast.conf --force-remove-failed-dirs --force-remove-previous-repos
source pynast_software/activate.sh
export PATH=/home/ubuntu/jenkins-support:/home/ubuntu/jenkins-support/mafft/bin:$PATH
export MAFFT_BINARIES=/home/ubuntu/jenkins-support/mafft/lib/mafft
python pynast_software/pynast-*-repository-*/tests/all_tests.py
