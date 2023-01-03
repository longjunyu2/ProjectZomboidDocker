FROM ubuntu:20.04

LABEL maintainer="Junyu Long"

ENV TIMEZONE=Asia/Shanghai \
    UID=1000 \
    GID=1000 \
	ADMINPASSWD=123456

VOLUME ["/home/game/Zomboid"]

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && dpkg --add-architecture i386 \
    && apt update \
    && apt dist-upgrade -y \
    && apt install -y wget lib32gcc1 lib32stdc++6 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /data/scripts

COPY entry.sh /data/scripts

CMD ["sh", "/data/scripts/entry.sh"]