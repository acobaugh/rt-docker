FROM alpine:3.9

MAINTAINER Andy Cobaugh <andrew.cobaugh@gmail.com>

ENV RT_VERSION 4.4.0
ENV RT_SHA256 dd2433b8c3da5eeafa8eac9e4a1109d3ff8d20560301ce9f65eda7dd1d28ffc1
ENV RT_FIX_DEPS_CMD=/bin/cpanm

RUN apk --update --no-cache add ca-certificates curl wget
RUN mkdir /build && cd /build && wget "https://download.bestpractical.com/pub/rt/release/rt-${RT_VERSION}.tar.gz" \
	&& echo "${RT_SHA256}  rt-${RT_VERSION}.tar.gz" | sha256sum -c \
	&& tar -xzvf rt-${RT_VERSION}.tar.gz
RUN apk --update add apache2 fcgi apache-mod-fcgid perl postgresql-libs openssl graphviz gnupg \
	perl-apache-session \
	perl-cgi \
	perl-dbi \
	perl-dbd-sqlite \
	perl-graphviz \
	perl-net-ssleay \
	perl-plack \
	perl-starlet \
	perl-xml-rss \
	perl-term-readkey \
	perl-fcgi \
	perl-data-guid \
	perl-role-basic \
	perl-dbd-pg \
	perl-net-cidr \
	perl-mozilla-ca \
	perl-crypt-ssleay \
	perl-html-quoted \
	perl-data-ical \
	perl-string-shellquote \
	perl-json \
	perl-business-hours \
	perl-cgi-emulate-psgi \
	perl-cgi-psgi \
	perl-data-page-pageset \
	perl-dbd-mysql \
	perl-date-extract \
	perl-datetime-format-natural \
	perl-email-address \
	perl-html-formattext-withlinks \
	perl-html-formattext-withlinks-andtables \
	perl-html-rewriteattributes \
	perl-locale-maketext-fuzzy \
	perl-locale-maketext-lexicon \
	perl-log-dispatch \
	perl-module-refresh \
	perl-regexp-ipv6 \
	perl-scope-upper \
	perl-symbol-global-name \
	perl-text-template \
	perl-text-wikiformat \
	perl-text-wrapper \
	perl-universal-require \
	perl-crypt-eksblowfish \
	perl-css-minifier-xs \
	perl-email-address-list \
	perl-html-mason-psgihandler \
	perl-javascript-minifier-xs \
	perl-module-versions-report \
	perl-regexp-common \
	perl-regexp-common-net-cidr \
	perl-text-password-pronounceable \
	perl-mail-tools \
	perl-mime-tools \
	perl-time-modules \ 
	perl-moo \
	perl-net-ip \
	perl-type-tiny \
	perl-ldap \
	perl-date-manip \
	perl-lwp-protocol-https \
	perl-gd \
	perl-gdgraph \
	perl-dbix-searchbuilder \
	perl-crypt-x509 \
	perl-convert-color \
	perl-css-squish \
	perl-text-quoted \
	perl-tree-simple \
	perl-html-mason \
	perl-mime-types \
	perl-html-scrubber \
	perl-fcgi-procmanager \
	mariadb \
	mariadb-client

# build dependencies
RUN apk --update add --virtual builddeps gcc perl-dev musl-dev make postgresql-dev zlib-dev expat-dev mariadb-dev \
 && curl -L https://cpanmin.us > /bin/cpanm && chmod +x /bin/cpanm && cpanm -n GnuPG::Interface PerlIO::eol Net::LDAP::Server::Test \
 && cd /build/rt-${RT_VERSION} && ./configure \
		--prefix=/opt/rt \
		--enable-gd \
		--enable-smime \
		--enable-graphviz \
		--with-db-type=mysql \
		--enable-externalauth \
		--with-web-user=root \
		--with-web-group=root \
	&& make testdeps \
	&& make install \
 && rm -rf /build && apk del builddeps	

