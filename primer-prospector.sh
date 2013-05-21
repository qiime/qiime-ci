#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf primer_prospector_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?repository-location: https://pprospector.svn.sourceforge.net/svnroot/pprospector/trunk?repository-location: $WORKSPACE/primer-prospector\nlocal-repository: yes?" qiime-deploy-conf/primer-prospector-1.0.1-dev/primer-prospector.conf
cp -r /home/ubuntu/qiime_software primer_prospector_software
python qiime-deploy/qiime-deploy.py primer_prospector_software -f qiime-deploy-conf/primer-prospector-1.0.1-dev/primer-prospector.conf --force-remove-failed-dirs --force-remove-previous-repos
source primer_prospector_software/activate.sh
cd primer_prospector_software/pprospector-*-repository-*
python tests/all_tests.py
