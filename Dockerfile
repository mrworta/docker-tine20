FROM debian:jessie
MAINTAINER MrWorta - NightSky Services

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install apt-utils apt-transport-https -y
RUN dpkg --configure --pending
RUN echo exit 0 > /usr/sbin/policy-rc.d

RUN echo deb https://packages.tine20.org/debian jessie stable > /etc/apt/sources.list.d/tine20.list

RUN apt-key adv --recv-keys --keyserver keys.gnupg.net 7F6F6895
RUN apt-get update
RUN apt-get install tine20 -y


### Workaround for BUG 0011206:
RUN sed -i 's/\.:\//\.:\/usr\/share\/tine20\/library\/zf1ext:/g' /etc/apache2/conf-enabled/tine20.conf
###

CMD grep -A 3 setupuser /etc/tine20/config.inc.php; /etc/init.d/mysql start && /etc/init.d/apache2 start && tail -F /var/log/apache2/error.log

EXPOSE 80
