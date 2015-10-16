pvzd docker image
=================

A docker image for running a pvzd instance.

    To keep the docker image immutable, mutable files are located in /opt, which is mounted to the docker host.

    Steps to deploy your container:
    1. build.sh: create docker image
    2. configure files in ./opt:
        2.1 replace the default key material in opt/etc/pki!
    3. run.sh  run the container using the image created in step 1
