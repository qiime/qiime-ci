#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf emperor_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?repository-location: git://github.com/qiime/emperor.git?repository-location: $WORKSPACE/emperor\nlocal-repository: yes?" qiime-deploy-conf/emperor-0.9.2-dev/emperor.conf
sed -i -e"s?log-level: INFO?log-level: DEBUG?" qiime-deploy-conf/emperor-0.9.2-dev/emperor.conf
cp -r /home/ubuntu/qiime_software emperor_software
python qiime-deploy/qiime-deploy.py emperor_software -f qiime-deploy-conf/emperor-0.9.2-dev/emperor.conf --force-remove-failed-dirs --force-remove-previous-repos
source emperor_software/activate.sh
cd emperor_software/emperor-*-repository-*
python tests/all_tests.py
