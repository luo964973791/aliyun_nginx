FROM alpine:latest
MAINTAINER NGINX Docker Maintainers "964973791@qq.com"
ENV NGINX_VERSION nginx-1.14.0
RUN echo -e "http://mirrors.aliyun.com/alpine/latest-stable/main\nhttp://mirrors.aliyun.com/alpine/latest-stable/community" > /etc/apk/repositories && \
	apk update && \
    apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers curl gnupg libxslt-dev gd-dev geoip-dev wget curl tree ca-certificates tzdata && \
    cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /usr/local/src && wget -P /usr/local/src http://nginx.org/download/$NGINX_VERSION.tar.gz && addgroup -S www && adduser -D -S -h /usr/local/nginx -s /sbin/nologin -G nginx nginx && cd /usr/local/src && tar zxvf $NGINX_VERSION.tar.gz && cd/usr/local/src/$NGINX_VERSION && \
	./configure --user=www --group=www \
	--prefix=/usr/local/nginx \
	--user=www \
	--group=www \
	--sbin-path=/usr/sbin/nginx \
	--modules-path=/usr/local/nginx/modules \
	--conf-path=/usr/local/nginx/nginx.conf \
    --error-log-path=/usr/local/nginx/error.log \
    --http-log-path=/usr/local/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/usr/local/nginx/client_temp \
    --http-proxy-temp-path=/usr/local/nginx/proxy_temp \
    --http-fastcgi-temp-path=/usr/local/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/usr/local/nginx/uwsgi_temp \
    --http-scgi-temp-path=/usr/local/nginx/scgi_temp \
    --with-http_ssl_module \
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
    --with-http_v2_module && \
    make && make install
