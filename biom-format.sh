#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf biom_format_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?repository-location: git://github.com/biom-format/biom-format.git?repository-location: $WORKSPACE/biom-format\nlocal-repository: yes?" qiime-deploy-conf/biom-format-1.2.0-dev/biom-format.conf
sed -i -e"s?log-level: INFO?log-level: DEBUG?" qiime-deploy-conf/biom-format-1.2.0-dev/biom-format.conf
cp -r /home/ubuntu/qiime_software biom_format_software
python qiime-deploy/qiime-deploy.py biom_format_software -f qiime-deploy-conf/biom-format-1.2.0-dev/biom-format.conf --force-remove-failed-dirs --force-remove-previous-repos
source biom_format_software/activate.sh
biom show-install-info
cd biom_format_software/biom-format-*-repository-*
nosetests
