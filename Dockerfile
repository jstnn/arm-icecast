FROM resin/raspberrypi3-debian:jessie
LABEL maintainer="n.justiniano@gmail.com"

RUN [ "cross-build-start" ]

ARG user=icecast2
ARG group=icecast

RUN ln -sf /bin/bash /bin/sh
RUN useradd -ms /bin/bash ${user} && groupadd ${group}

RUN apt-get -qq -y update \
    && apt-get -qq -y install --no-install-recommends icecast2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY silence.ogg /usr/share/icecast2/silence.ogg
COPY icecast.xml /usr/share/icecast2/icecast.xml

RUN mkdir -p /var/log/icecast \
    && chown -R ${user}:${group} /usr/share/icecast2 \
    && chown -R ${user}:${group} /var/log/icecast

RUN [ "cross-build-end" ] 

USER ${user}
CMD ["icecast2", "-c", "/usr/share/icecast2/icecast.xml"]

