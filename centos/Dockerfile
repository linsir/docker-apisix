ARG RESTY_IMAGE_BASE="openresty/openresty"
ARG RESTY_IMAGE_TAG="centos"
# require alpine-fat >= 1.15.8.1-3
FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

MAINTAINER vkill <vkill.net@gmail.com>

ARG APISIX_VERSION=v0.8
ENV APISIX_VERSION=${APISIX_VERSION}-0

RUN set -ex \
    \
    # && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo\
    && sed -i 's/mirror.centos.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's/plugins=1/plugins=0/g' /etc/yum.conf \
    && rpm --rebuilddb && yum install -y rsync \
    && yum install -y etcd openresty curl git automake autoconf \
    make gcc pcre-devel libtool gcc-c++ luarocks cmake lua-devel

RUN luarocks install lua-resty-libr3 --tree=/usr/local/apisix/deps --local \
    && luarocks install rapidjson --tree=/usr/local/apisix/deps --local \
    && luarocks install lua-resty-radixtree --tree=/usr/local/apisix/deps --local

RUN luarocks install apisix ${APISIX_VERSION} --tree=/usr/local/apisix/deps --local \
    && ln -s /usr/local/apisix/deps/bin/apisix /usr/local/bin/apisix \
    && sed -i '/pcall(require, "cjson")$/,/^end$/s/return$/-- return/' /usr/local/apisix/deps/lib/luarocks/rocks-5.1/apisix/${APISIX_VERSION}/bin/apisix

WORKDIR /usr/local/apisix

EXPOSE 9080 9443

CMD ["sh", "-c", "/usr/local/bin/apisix init && /usr/local/bin/apisix init_etcd && /usr/local/openresty/bin/openresty -p /usr/local/apisix -g 'daemon off;'"]
