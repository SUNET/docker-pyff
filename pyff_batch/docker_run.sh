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
    -h  Show this message
    -c  Delete all files in log dir and exit

EOF
exit 0
}

while getopts "c:h:v" OPTION
do
        case $OPTION in
                c)
                        rm -f ./${volume}/log/*
                        echo "Deleted /${volume}/log directory."
                        exit 0
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

if ${sudo} docker ps | awk '{print $NF}' | grep -qx ${name}; then
    echo "$0: Docker container with name $name already running. Press enter to restart it, or ctrl+c to abort."
    read foo
    ${sudo} docker kill ${name}
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


# To debug your container:
#DOCKERARGS="--entrypoint /bin/bash" bash -x ./run.sh

${sudo} docker run --rm=true \
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
