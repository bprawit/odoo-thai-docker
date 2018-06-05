FROM debian:jessie
MAINTAINER Prawit Buayai <charisma.prawit@gmail.com>

# Fork from Odoo S.A. <info@odoo.com>
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        dpkg --remove --force-depends node-less \
        && apt-get update \
        && apt-get install -y curl \
        && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            nodejs \
            python-gevent \
            libthai0 \
            xfonts-thai \
            python-pip \
            python-renderpm \
            python-support \
            python-watchdog \
            build-essential \
            python-dev \
            libffi-dev \
            libssl-dev \
            libsodium-dev \
            rsyslog \
            git \
            libsasl2-2 \
            libsasl2-modules \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && pip install setuptools pip --upgrade \
        && pip install psycogreen==1.0 bahttext simplejson enum34 pysftp

# Install Odoo
ENV ODOO_VERSION 10.0
ENV ODOO_RELEASE 20180122
RUN set -x; \
        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo '836f0fb94aee0d3771cf2188309f6079ee35f83e odoo.deb' | sha1sum -c - \
        && dpkg --force-depends -i odoo.deb \ 
        && sed -i -e "\$adeb http://mirror.kku.ac.th/debian jessie main" /etc/apt/sources.list \
        && sed -i -e "\$adeb http://mirror.kku.ac.th/debian jessie-updates main" /etc/apt/sources.list \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* odoo.deb \
        && dpkg --remove --force-depends node-less \
        && npm install -g less less-plugin-clean-css

# Copy entrypoint script and Odoo configuration file
# COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
RUN chown odoo /etc/odoo/odoo.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        $$ mkdir -p /backup \
        && chown -R odoo /mnt/extra-addons \
        && chown -R odoo /backup
VOLUME ["/var/lib/odoo", "/mnt/extra-addons", "/backup"]

# Expose Odoo services
EXPOSE 8069 8072

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["odoo"]