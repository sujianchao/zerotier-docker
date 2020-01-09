FROM alpine:3.11 as builder

ARG ZT_VERSION=1.4.6

RUN apk add --upgrade --no-cache \
              alpine-sdk \
              linux-headers \
    && git clone --depth 1 --branch ${ZT_VERSION} https://github.com/zerotier/ZeroTierOne.git /src \
    && cd /src \
    && make -f make-linux.mk

FROM alpine:3.11
LABEL version="1.4.6"
LABEL description="ZeroTier One Docker-only Linux hosts"

RUN apk add --upgrade --no-cache \
              libgcc \
              libc6-compat \
              libstdc++
              
COPY --from=builder /src/zerotier-one /usr/sbin/
RUN mkdir -p /var/lib/zerotier-one \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-idtool \
  && ln -s /usr/sbin/zerotier-one /usr/sbin/zerotier-cli

COPY main.sh /main.sh
RUN chmod 0755 /main.sh

EXPOSE 9993/udp
ENTRYPOINT ["/main.sh"]
CMD ["zerotier-one"]
