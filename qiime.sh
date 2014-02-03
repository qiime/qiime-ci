#!/bin/bash -ex
rm -rf qiime-deploy qiime-deploy-conf qiime_software
git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
cp -r /home/ubuntu/qiime_software .
pip install --quiet "numpy>=1.5.1,<=1.7.1"
pip install $WORKSPACE/qiime
$PYTHON_EXE qiime-deploy/qiime-deploy.py qiime_software -f qiime-deploy-conf/qiime-dev/qiime.conf --force-remove-failed-dirs --force-remove-previous-repos
sed -i -e's/97_otus.fasta/61_otus.fasta/' qiime_software/qiime_config
sed -i -e's/97_otu_taxonomy.txt/61_otu_taxonomy.txt/' qiime_software/qiime_config
source qiime_software/activate.sh
export PATH=/home/ubuntu/jenkins-support:$PATH
print_qiime_config.py -t
$PYTHON_EXE $WORKSPACE/qiime/tests/all_tests.py
