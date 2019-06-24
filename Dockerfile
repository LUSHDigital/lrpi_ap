FROM balenalib/raspberrypi3-debian:stretch

MAINTAINER Paul Harter "paul@glowinthedark.co.uk"

RUN [ "cross-build-start" ]

RUN apt-get update --fix-missing && apt-get install -y \
    hostapd \
    dnsmasq \
    iw

RUN  apt-get clean && rm -rf /var/lib/apt/lists/*

ADD hostapd.conf /etc/hostapd/hostapd.conf
ADD hostapd /etc/default/hostapd
ADD dnsmasq.conf /etc/dnsmasq.conf
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

RUN [ "cross-build-end" ]
