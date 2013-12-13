#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf picrust_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?repository-location: git://github.com/picrust/picrust.git?repository-location: $WORKSPACE/picrust\nlocal-repository: yes?" qiime-deploy-conf/picrust-dev/picrust.conf
sed -i -e"s?log-level: INFO?log-level: DEBUG?" qiime-deploy-conf/picrust-dev/picrust.conf
cp -r /home/ubuntu/qiime_software picrust_software
rm -rf picrust_software/*-latest-r-package
python qiime-deploy/qiime-deploy.py picrust_software -f qiime-deploy-conf/picrust-dev/picrust.conf --force-remove-failed-dirs --force-remove-previous-repos
source picrust_software/activate.sh
python picrust_software/picrust-*-repository-*/tests/all_tests.py
