FROM ubuntu

# Install Graphite using pip

# Install all prerequisites
RUN apt-get -y update
RUN apt-get -y install python-dev supervisor nginx-light

RUN pip install https://github.com/graphite-project/ceres/tarball/master
RUN pip install whisper
RUN pip install carbon
RUN pip install graphite-web

# Configure Graphite for SysMon
ADD ./graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD ./graphite/carbon.conf /opt/graphite/conf/carbon.conf
ADD ./graphite/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD ./graphite/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf

# Configure nginx and supervisord
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ports 
EXPOSE 80
EXPOSE 2003 
EXPOSE 8125/udp

# Start
CMD ["/usr/bin/supervisord"]
