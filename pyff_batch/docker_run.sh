#!/bin/bash
#
# create a new docker container

container_name=pyff_batch

# relative path to volume
volume=opt

usage()
{
cat << EOF
usage: $0 options

OPTIONS
    -c  Delete all files in log dir and exit
    -d  Run as daemon
    -v  Show data volume mount paths
    -h  Show this message

EOF
exit 0
}

detachmode='--detch=false --rm=true'  # run container in foreground and remove it on exit

while getopts "cdhv" OPTION
do
        case $OPTION in
                c)
                        rm -f ./${volume}/log/*
                        echo "Deleted /${volume}/log directory."
                        exit 0
                        ;;
                d)
                        detachmode='--detach=true --rm=false'
                        ;;
                v)
                        echo "mounting data volume (host:container): ${dir}/${volume}:/${volume}"
                        exit 0
                        ;;
                h)
                        usage
                        ;;
                ?)
                        usage
                        ;;
        esac
done

#absolute dirname of script
dir=$(dirname `which $0`)

. ${dir}/image_name.sh


# if running on linux
if [ $(id -u) -ne 0 ]; then
    sudo="sudo"
fi

if ${sudo} docker ps | awk '{print $NF}' | grep -qx ${container_name}; then
    echo "$0: Docker container with name $name already running. Press enter to restart it, or ctrl+c to abort."
    exit 0
fi
$sudo docker rm ${name} > /dev/null 2> /dev/null


# Arguments to start pyff:
export LOGLEVEL=INFO
export LOGFILE=/opt/var/log/pyff.log
export PIPELINE=/opt/etc/md.fd

# cron will invoke pyff every PERIOD minutes (1..59)
if [ -z "$PERIOD" ]; then
   export PERIOD="10"
fi


if docker ps -a |grep -q 'pyff_batch\s*$'; then
    ${sudo} docker rm ${container_name}  # needed for batch mode
fi

# To debug your container:
#DOCKERARGS="--entrypoint /bin/bash" bash -x ./run.sh

${sudo} docker run --rm=true \
    ${detachmode} \
    --env="LOGFILE=$LOGFILE" \
    --env="LOGLEVEL=$LOGLEVEL" \
    --env="PERIOD=$PERIOD" \
    --env="PIPELINE=$PIPELINE" \
    --hostname="${container_name}" \
    --name="${container_name}" \
    --volume=${dir}/${volume}:/${volume} \
    $DOCKERARGS \
    -i -t \
    ${image}
