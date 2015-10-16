# install docker-pyff/pyff_batch on CentOS 6.x
# regard this script as guidance, not something to fire and forget
# -----------------------------------------------------------------------------------------
# Prerequisites:
# your machine resolves DNS and has a route to the internet
# (if there is a constrained environemnt, set HTTPS_PROXY etc. - YMMV)
# install and activate docker, e.g. from epel reop
yum -y install docker-io
chkconfig --add docker
service docker start
# get and build docker image
cd /usr/local/src   # location to keep git upstream link to produces updated images
git clone https://github.com/rhoerbe/docker-pvzd.git
cd docker-pvzd/
git clone https://github.com/rhoerbe/PVZD.git # first time
cd PVZD && git pull && cd .. # already cloned
./docker_build.sh
mkdir /opt/pyff_batch  # location with local configuration, not to be overwritten by git pull
cp -pr docker_run.sh image_name.sh opt /opt/pyff_batch # copy startup & default config
cd /opt/pyff_batch
# Docker container cannot see the CentOS canonical location - copy files into mounted volume
# precondition: md signing cert are already installed there
cp -p /etc/pki/sign/private/SignMetadataOurFederation-key.pem opt/etc/pki/metadata_key.pem
cp -p /etc/pki/sign/certs/SignMetadataKukOurFederation-crt.pem opt/etc/pki/metadata_crt.pem
# configure SAML metadata input path
rm -rf opt/var/md_source/ opt/var/md_feed
cp -p /var/www/mdfeedExampleCom/upload/* opt/var/md_source/
# configure log files to CentOS canonical location
ln -s opt/var/log/pyff.log /var/log/pyff_batch
# edit finalize/ID in md.fd
ln -s /var/log/pyff_batch opt/var/log
# you may want to add a script in your docker host's /etc/init.d to start docker_run.sh
