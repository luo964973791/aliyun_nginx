FROM alpine:latest
MAINTAINER NGINX "964973791@qq.com"
ENV NGINX_VERSION nginx-1.14.0
ENV NGINX_OPENSSL openssl-1.1.1
RUN build="bash gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers curl gnupg libxslt-dev gd-dev geoip-dev wget curl tree ca-certificates tzdata" \
    && echo -e "http://mirrors.aliyun.com/alpine/latest-stable/main\nhttp://mirrors.aliyun.com/alpine/latest-stable/community" > /etc/apk/repositories \
    && apk update \
    && apk add --no-cache ${build} \
    && cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && wget -P /usr/local/ https://www.openssl.org/source/$NGINX_OPENSSL.tar.gz \
    && cd /usr/local \
    && tar zxvf $NGINX_OPENSSL.tar.gz \
    && mv $NGINX_OPENSSL openssl \
    && rm -rf /usr/local/$NGINX_OPENSSL.tar.gz \
    && mkdir /usr/local/src \
    && wget -P /usr/local/src http://nginx.org/download/$NGINX_VERSION.tar.gz \
    && addgroup -S www \
    && adduser -D -S -s /sbin/nologin -G www www \
    && cd /usr/local/src \
    && tar zxvf $NGINX_VERSION.tar.gz \
    && rm -rf /usr/local/src/$NGINX_VERSION.tar.gz \
    && cd /usr/local/src/$NGINX_VERSION \
    && ./configure --user=www --group=www \
    --prefix=/usr/local/nginx \
    --user=www \
    --group=www \
    --with-ipv6 \
    --with-http_ssl_module \
    --with-openssl=/usr/local/openssl \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_geoip_module=dynamic \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
    --with-stream_geoip_module=dynamic \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-compat \
    --with-file-aio \
    --with-http_v2_module \
    && make \
    && make install \
    && ln -sf /usr/local/nginx/sbin/nginx /usr/bin/nginx \
    && rm -rf /usr/local/nginx/conf/nginx.conf \
    && mkdir -p /home/wwwroot/default \
    && chmod +w /home/wwwroot/default \
    && mkdir -p /home/wwwlogs \
    && chmod 777 /home/wwwlogs \
    && chown -R www:www /home/wwwroot/default \
    && mkdir /usr/local/nginx/conf/vhost \
    && rm -rf /var/cache/apk/*
ADD nginx.conf /usr/local/nginx/conf/nginx.conf
ADD rewrite /usr/local/nginx/conf/
ADD pathinfo.conf /usr/local/nginx/conf/pathinfo.conf
ADD enable-php.conf /usr/local/nginx/conf/enable-php.conf
ADD enable-php-pathinfo.conf /usr/local/nginx/conf/enable-php-pathinfo.conf
ADD enable-ssl-example.conf /usr/local/nginx/conf/enable-ssl-example.conf
ADD rewrite /usr/local/nginx/conf/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
