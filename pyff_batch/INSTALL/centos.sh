# --------------------------------------------
# install docker-pyff/pyff_batch on CentOS 6.x
# --------------------------------------------

### install docker
yum -y install docker-io
chkconfig --add docker
service docker start

### build pyff_batch docker image
cd /usr/local/src   # location to keep git upstream link to produces updated images
git clone https://github.com/rhoerbe/docker-pyff.git
cd docker-pyff/pyff_batch
./docker_build.sh

### configure pyff_batch
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
ln -z /var/log/pyff_batch opt/var/log

### deploy pyff_batch as a centos service
cp pyff_batch /etc/init.ds
chkconfig --add pyff_batch
service pyff_batch start