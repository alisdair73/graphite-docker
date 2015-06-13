FROM ubuntu

# Install Graphite using pip

# Install all prerequisites
RUN apt-get -y update
RUN apt-get -y install python-pip python-pip python-cairo python-django python-django-tagging python-twisted 
RUN apt-get -y install gunicorn supervisor nginx-light
RUN pip install https://github.com/graphite-project/ceres/tarball/master
RUN pip install whisper
RUN pip install carbon
RUN pip install graphite-web

# Configure Graphite for SysMon
ADD ./graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD ./graphite/carbon.conf /opt/graphite/conf/carbon.conf
ADD ./graphite/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD ./graphite/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf

RUN mkdir -p /opt/graphite/storage/whisper
RUN touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index
RUN chown -R www-data /opt/graphite/storage
RUN chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
RUN chmod 0664 /opt/graphite/storage/graphite.db
RUN cd /opt/graphite/webapp/graphite && python manage.py syncdb --noinput

# Configure nginx and supervisord
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ports 
EXPOSE 80
EXPOSE 2003 
EXPOSE 8125/udp

# Start
CMD ["/usr/bin/supervisord"]
