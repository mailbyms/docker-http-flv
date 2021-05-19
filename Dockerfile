# base image，be aware of 'end of life' issue: https://wiki.centos.org/FAQ/General
### phase 1
FROM centos:7.9.2009

ARG SRC_BASE_DIR=/usr/local

ADD http://nginx.org/download/nginx-1.8.1.tar.gz ${SRC_BASE_DIR}
ADD https://github.com/winshining/nginx-http-flv-module/archive/v1.2.7.tar.gz ${SRC_BASE_DIR}
ADD https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.2.1-amd64-static.tar.xz ${SRC_BASE_DIR}

# compile nginx with nginx-rtmp-module, and install it
RUN yum -y install gcc openssl openssl-devel libxml2-devel libxslt-devel pcre-devel xz \
    && cd ${SRC_BASE_DIR} \
    && tar xvf nginx-1.8.1.tar.gz \
    && tar xvf v1.2.7.tar.gz \
    && tar xvf ffmpeg-4.2.1-amd64-static.tar.xz \
    && cd /usr/local/nginx-1.8.1 \
    && ./configure --prefix=/usr/local/nginx  --add-module=../nginx-http-flv-module-1.2.7  --with-http_ssl_module  --with-http_xslt_module \
    && make \
    && make install \
    && mv /usr/local/nginx-http-flv-module-1.2.7/stat.xsl /usr/local/nginx/conf/ 

### phase 2
FROM centos:7.9.2009

ARG NGINX_BASE_DIR=/usr/local/nginx

COPY --from=0  /usr/local/nginx ${NGINX_BASE_DIR}/
COPY --from=0  /usr/local/ffmpeg-4.2.1-amd64-static/ffmpeg /usr/local/

ADD nclients.xsl http_hls.conf http_flv.conf rtmp.conf ${NGINX_BASE_DIR}/conf/

RUN yum install -y libxslt \
    # find keyword "http {", and insert "include rtmp.conf" into the previous line
    && sed -i '/http[[:space:]]{/i\    include rtmp.conf;' ${NGINX_BASE_DIR}/conf/nginx.conf \
    # find keyword gzip, and insert "include http_hls.conf" into the next line 
    && sed -i '/gzip/a\    include http_hls.conf;\n    include http_flv.conf;' ${NGINX_BASE_DIR}/conf/nginx.conf \
    && mkdir -p /data/video

CMD [ "/usr/local/nginx/sbin/nginx", "-g", "daemon off;" ]

EXPOSE 9090 1935 80 8002
