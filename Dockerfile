FROM topaztechnology/base:3.6
MAINTAINER Topaz Tech Ltd <info@topaz.technology>

# Consul
ENV CONSUL_VERSION 1.0.6
ENV CONSUL_RELEASES https://releases.hashicorp.com/consul

RUN addgroup consul && \
    adduser -S -G consul consul

# Install Consul
RUN \
  apk add --update --no-cache ca-certificates gnupg openssl && \
  gpg --keyserver pgp.mit.edu --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C && \
  mkdir -p /tmp/consul && \
  cd /tmp/consul && \
  wget ${CONSUL_RELEASES}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
  wget ${CONSUL_RELEASES}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS && \
  wget ${CONSUL_RELEASES}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig && \
  gpg --batch --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS && \
  grep consul_${CONSUL_VERSION}_linux_amd64.zip consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c && \
  unzip -d /usr/local/bin consul_${CONSUL_VERSION}_linux_amd64.zip && \
  rm -rf /tmp/consul && \
  apk del gnupg openssl && \
  rm -rf /root/.gnupg && \
  mkdir -p /consul/data && \
  chown -R consul:consul /consul

COPY containerpilot.json5 /etc/containerpilot.json5
COPY bin/* /usr/local/bin/
COPY etc/* /etc/

VOLUME /consul/data

# Server RPC is used for communication between Consul clients and servers for internal
# request forwarding.
EXPOSE 8300

# Serf LAN and WAN (WAN is used only by Consul servers) are used for gossip between
# Consul agents. LAN is within the datacenter and WAN is between just the Consul
# servers in all datacenters.
EXPOSE 8301 8301/udp 8302 8302/udp

# HTTP and DNS (both TCP and UDP) are the primary interfaces that applications
# use to interact with Consul.
EXPOSE 8500 8600 8600/udp
