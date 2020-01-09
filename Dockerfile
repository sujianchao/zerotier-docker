FROM alpine:3.11 as builder

ARG ZT_VERSION=1.4.6

RUN apk add --upgrade --no-cache \
              alpine-sdk \
              linux-headers \
              libgcc \
              libc6-compat \
              libstdc++  \
    && git clone --depth 1 --branch ${ZT_VERSION} https://github.com/zerotier/ZeroTierOne.git /src \
    && cd /src \
    && make -f make-linux.mk

RUN cp  zerotier-one /usr/sbin/
RUN rm -rf  /src
RUN mkdir -p /var/lib/zerotier-one \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-cli

COPY main.sh /main.sh
RUN chmod 0755 /main.sh

EXPOSE 9993/udp
ENTRYPOINT ["/main.sh"]
CMD ["zerotier-one"]
