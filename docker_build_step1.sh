#!/bin/bash
# Build a docker image to execute pyff in batch mode

dir=$(dirname `which $0`)  #absolute dirname of script
. ${dir}/image_name.sh

# Check if running on mac
if [ $(uname) = "Darwin" ]; then

    #Get ip of dns
    dnsip=$(ipconfig getifaddr en0)

    # Check so the boot2docker vm is running
    if [ $(boot2docker status) != "running" ]; then
        boot2docker start
    fi
    $(boot2docker shellinit)
else
    # if running on linux
    if [ $(id -u) -ne 0 ]; then
        sudo="sudo"
    fi
fi

${sudo} docker rmi -f ${image1}
${sudo} docker build -f Dockerfile_step1 -t=${image1} .