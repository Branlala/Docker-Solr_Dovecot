#
# VERSION 0.1

FROM    ubuntu
MAINTAINER MrRpah_ "mrraph_@techan.fr"

RUN mkdir -p /opt/solr
RUN apt-get update
RUN apt-get --yes install openjdk-7-jdk wget
RUN apt-get --yes clean
RUN wget http://apache.mirrors.tds.net/lucene/solr/4.10.4/solr-4.10.4.tgz -O /opt/solr-4.10.4.tgz
RUN tar -C /opt --extract --file /opt/solr-4.10.4.tgz
RUN cp -R /opt/solr-4.10.4/example/* /opt/solr/
RUN mv /opt/solr/solr/collection1/conf/schema.xml opt/solr/solr/collection1/conf/schema.xml-dist
RUN wget https://raw.githubusercontent.com/extremeshok/solr-dovecot2/master/schema.xml -O /opt/solr/solr/collection1/conf/schema.xml
COPY cron.txt /tmp
RUN /tmp/cron.txt /etc/cron.d/solr
EXPOSE 8983
CMD ["/bin/bash", "-c", "cd /opt/solr; java -jar start.jar"]
