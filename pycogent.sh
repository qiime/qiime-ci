#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf pycogent_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?repository-location: https://github.com/pycogent/pycogent.git?repository-location: $WORKSPACE/pycogent\nlocal-repository: yes?" qiime-deploy-conf/pycogent-1.5.3-dev/pycogent.conf
cp -r /home/ubuntu/qiime_software pycogent_software
python qiime-deploy/qiime-deploy.py pycogent_software -f qiime-deploy-conf/pycogent-1.5.3-dev/pycogent.conf --force-remove-failed-dirs --force-remove-previous-repos
source pycogent_software/activate.sh
export PATH=/home/ubuntu/jenkins-support:/home/ubuntu/jenkins-support/mafft/bin:$PATH
export MAFFT_BINARIES=/home/ubuntu/jenkins-support/mafft/lib/mafft
export TEST_DB=1
cd pycogent_software/pycogent-*-repository-*
./run_tests
