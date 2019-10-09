#!/bin/bash
###


APISIX_VERSION=0.8
APISIX_DASHBOARD_BUILT_VERSION=9dabb12b9c949bb1c5387a4e7b73a0c99ac8c946

BASE_URL=http://182.151.51.74:8000/apisix
APISIX_DOWNLOAD_URL=${BASE_URL}/v${APISIX_VERSION}.zip
APISIX_DASHBOARD_BUILTDOWNLOAD_URL=${BASE_URL}/${APISIX_DASHBOARD_BUILT_VERSION}.zip

build_alpine() {
    docker build -t apisix:${APISIX_VERSION}-alpine \
    --build-arg APISIX_VERSION=${APISIX_VERSION} \
    --build-arg APISIX_DOWNLOAD_URL=${APISIX_DOWNLOAD_URL} \
    --build-arg APISIX_DASHBOARD_BUILT_VERSION=${APISIX_DASHBOARD_BUILT_VERSION} \
    --build-arg APISIX_DASHBOARD_BUILTDOWNLOAD_URL=${APISIX_DASHBOARD_BUILTDOWNLOAD_URL} \
     -f alpine/Dockerfile alpine

    docker tag apisix:${APISIX_VERSION}-alpine apisix:latest
}

build_centos() {
    docker build -t apisix:${APISIX_VERSION}-centos \
    --build-arg APISIX_VERSION=${APISIX_VERSION} \
     -f centos/Dockerfile centos

    docker tag apisix:${APISIX_VERSION}-centos apisix:latest
}

main() {
    if [ "$APISIX_VERSION" = "" ]
    then
        echo "Bad APISIX_VERSION: $TYPE."
        usage
        exit 0
    fi

    if [ "$TYPE" = "centos" ]
    then
        build_centos
    elif [ "$TYPE" = "alpine" ]
    then
        build_alpine
    else
        echo "the TYPE: $TYPE is not supported."
        usage
        exit 0
    fi

    if [ "$upload" = "true" ]
    then
        docker tag apisix:${APISIX_VERSION}-${TYPE} linsir/apisix:${APISIX_VERSION}
        docker tag apisix:${APISIX_VERSION}-${TYPE} linsir/apisix:${APISIX_VERSION}-${TYPE}
        docker tag apisix:${APISIX_VERSION}-${TYPE} linsir/apisix:latest
        docker push linsir/apisix:${APISIX_VERSION}
        docker push linsir/apisix:${APISIX_VERSION}-${TYPE}
        docker push linsir/apisix:latest
    fi
}

usage() {
    echo "Usage:"
    echo "  build.sh [-v APISIX_VERSION] [-t TYPE] [-u]"
    echo "Description:"
    echo "    APISIX_VERSION, the version of apisix."
    echo "    TYPE, the image's type of apisix (alpine or centos)."
    echo "    push images to dockerhub.default is false"
    exit -1
}

upload="false"

while getopts 'h:v:t:u' OPT; do
    case $OPT in
        v) APISIX_VERSION="$OPTARG";;
        t) TYPE="$OPTARG";;
        u) upload="true";;
        h) usage;;
        ?) usage;;
    esac
done
shift $(($OPTIND - 1))
main