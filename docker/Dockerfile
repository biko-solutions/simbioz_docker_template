FROM bikosolutions/developers_repo:latest

COPY client_addons/extra_requirements.txt /tmp/client_requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/client_requirements.txt

RUN echo "export PATH=\"\$PATH:/home/odoo/.local/bin\"" >> /home/odoo/.bashrc