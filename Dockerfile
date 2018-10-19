FROM jarischaefer/baseimage-ubuntu:2.1

ARG COMPOSER_VERSION=7cf90ec1d9540d586f6ac80babbc342033adf6b6

RUN	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C C300EE8C && \
	echo 'deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main' > /etc/apt/sources.list.d/ondrej-php7.list && \
	echo 'deb http://ppa.launchpad.net/nginx/development/ubuntu bionic main' > /etc/apt/sources.list.d/nginx.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install --no-install-recommends \
		dnsutils \
		nginx \
		php7.2-cli \
		php7.2-fpm \
		php7.2-mysql \
		php7.2-gd \
		php7.2-curl \
		php7.2-opcache \
		php7.2-ldap \
		php7.2-mbstring \
		php7.2-memcached \
		php7.2-snmp \
		php7.2-xml \
		php7.2-zip \
		php-imagick \
		php-pear \
		snmp \
		graphviz \
		fping \
		imagemagick \
		whois \
		mtr-tiny \
		nagios-plugins \
		nmap \
		python-mysqldb \
		rrdcached \
		rrdtool \
		sendmail \
		smbclient \
		git \
		python-ipaddress \
		python-memcache \
		sudo \
		curl \
		ipmitool \
		acl \
		vim-tiny && \
	pear install Net_IPv4 && \
	pear install Net_IPv6 && \
	curl -sSL -o - https://raw.githubusercontent.com/composer/getcomposer.org/${COMPOSER_VERSION}/web/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	rm -rf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/* && \
	sed -i 's/pm.max_children = 5/pm.max_children = 24/g' /etc/php/7.2/fpm/pool.d/www.conf && \
	sed -i 's/pm.start_servers = 2/pm.start_servers = 4/g' /etc/php/7.2/fpm/pool.d/www.conf && \
	sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 4/g' /etc/php/7.2/fpm/pool.d/www.conf && \
	sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 8/g' /etc/php/7.2/fpm/pool.d/www.conf && \
	sed -i 's/;clear_env/clear_env/g' /etc/php/7.2/fpm/pool.d/www.conf && \
	useradd librenms --home-dir /opt/librenms --system --shell /bin/bash && \
	usermod -a -G librenms www-data && \
	chmod u+s /usr/bin/fping /usr/bin/fping6 /usr/lib/nagios/plugins/check_dhcp /usr/lib/nagios/plugins/check_icmp && \
	sed -i 's/session.*required.*pam_loginuid.so//g' /etc/pam.d/cron && \
	apt-get -yq autoremove --purge && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* && \
	rm -f /var/log/dpkg.log /var/log/alternatives.log /var/log/bootstrap.log && \
	rm -f /var/log/apt/history.log /var/log/apt/term.log && \
	rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* && \
	rm -rf /usr/share/lintian/* /usr/share/linda/* && \
	find /usr/share/doc -not -type d -not -name 'copyright' -delete && \
	find /usr/share/doc -type d -empty -delete
