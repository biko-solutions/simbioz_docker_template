FROM python:3.8.10-buster
ARG DOCKER_ODOO_UID=1000  
ARG DOCKER_ODOO_GID=1000

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libxml2-dev \
        libxslt1-dev \
        libldap2-dev \
        libsasl2-dev \
        libtiff5-dev \
        libjpeg62-turbo-dev \
        libopenjp2-7-dev \
        zlib1g-dev \
        libfreetype6-dev \
        liblcms2-dev \
        libwebp-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libxcb1-dev \
        libpq-dev \
        xvfb \
        libfontconfig \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libssl-dev \
        node-less \
        npm \
        python3-num2words \
        python3-pdfminer \
        python3-pip \
        python3-phonenumbers \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-wheel \
        python3-setuptools \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        libjpeg-dev \
        gdebi \
        xz-utils \
        python3-virtualenv \
        virtualenv \
        wget \
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && echo 'ea8277df4297afc507c61122f3c349af142f31e5 wkhtmltox.deb' | sha1sum -c - \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt update && apt install -y postgresql-client

RUN npm install @odoo/owl@1.4.0 -y

ENV VIRTUAL_ENV=/home/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m pip install --no-cache-dir setuptools wheel
RUN python3 -m pip install --no-cache-dir debugpy pre-commit

COPY simbioz_repo/requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY simbioz_repo/extra_requirements.txt /tmp/extra_requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/extra_requirements.txt

COPY client_addons/extra_requirements.txt /tmp/client_requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/client_requirements.txt

RUN groupadd --gid ${DOCKER_ODOO_GID} odoo && useradd odoo -u ${DOCKER_ODOO_UID} -g ${DOCKER_ODOO_GID} -m -s /bin/bash

COPY docker_pycharm/entrypoint.sh /
COPY conf/odoo-server.conf /etc/odoo/

# Set permissions
RUN mkdir -p /home/odoo/simbioz_repo \
    && mkdir -p /home/odoo/client_addons \
    && mkdir -p /home/odoo/conf \
    && chown -v -R odoo /home/odoo

# Expose Odoo services
EXPOSE 5678 8069 8071 8072

ENV ODOO_RC /etc/odoo/odoo.conf

COPY docker_pycharm/wait-for-psql.py /usr/local/bin/wait-for-psql.py
RUN chmod +x /usr/local/bin/wait-for-psql.py
RUN chown odoo /usr/local/bin/wait-for-psql.py

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]