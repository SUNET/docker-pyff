pyff docker image
=================

pyff_batch:
    A docker image for running a pyFF instance in batch mode (metadata aggregator as implemented by pyff/md).

    To keep the docker image immutable, mutable files are located in /opt, which is mounted to the docker host.

    Steps to deploy your container:
    1. build.sh: create docker image
    2. configure files in ./opt:
        2.1 replace the default key material in opt/etc/pki!
        2.2 edit the pipeline file opt/etc/md.fd
        2.3 remove the example input file in opt/var/md_source
        2.4 optional edits may change default file locations
    3. run.sh  run the container using the image created in step 1


pyff_daemon:
    A docker image for running a pyFF instance in daemon mode (mdx service and idp discovery as implemented by pyff/mdx).
    See http://leifj.github.io/pyFF

