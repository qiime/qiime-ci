#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf qiime_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
sed -i -e"s?repository-location: git://github.com/qiime/qiime.git?repository-location: $WORKSPACE/qiime\nlocal-repository: yes?" qiime-deploy-conf/qiime-1.7.0-dev/qiime.conf
sed -i -e"s?log-level: INFO?log-level: DEBUG?" qiime-deploy-conf/qiime-1.7.0-dev/qiime.conf
cp -r /home/ubuntu/qiime_software .
python qiime-deploy/qiime-deploy.py qiime_software -f qiime-deploy-conf/qiime-1.7.0-dev/qiime.conf --force-remove-failed-dirs --force-remove-previous-repos
sed -i -e's/97_otus.fasta/61_otus.fasta/' qiime_software/qiime_config
sed -i -e's/97_otu_taxonomy.txt/61_otu_taxonomy.txt/' qiime_software/qiime_config
source qiime_software/activate.sh
export PATH=/home/ubuntu/jenkins-support:$PATH
print_qiime_config.py
python qiime_software/qiime-*-repository-*/tests/all_tests.py
