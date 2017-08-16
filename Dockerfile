FROM alpine:3.6

MAINTAINER Andy Cobaugh <andrew.cobaugh@gmail.com>

ENV RT_VERSION 4.4.2
ENV RT_SHA256 b2e366e18c8cb1dfd5bc6c46c116fd28cfa690a368b13fbf3131b21a0b9bbe68

RUN apk --update --no-cache add apache2 curl gcc fcgi perl wget make

RUN wget "https://download.bestpractical.com/pub/rt/release/rt-${RT_VERSION}.tar.gz" \
	&& echo "${RT_SHA256}  rt-${RT_VERSION}.tar.gz" | sha256sum -c \
	&& tar -xzvf rt-${RT_VERSION}.tar.gz
RUN cd rt-${RT_VERSION} && ./configure \
		--prefix=/opt/rt \
		--enable-gd \
		--enable-smime \
		--enable-graphviz \
		--with-db-type=Pg \
		--enable-externalauth \
	&& make fixdeps \
	&& make testdeps \
	&& make install
	

