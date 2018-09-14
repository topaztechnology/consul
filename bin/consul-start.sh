#!/bin/bash

if [ -z "${LOG_LEVEL}" ]; then
  LOG_LEVEL=INFO
fi

function addStandardConfig {
  cat $1 | jq --arg loglevel ${LOG_LEVEL} \
    '. + { "log_level": $loglevel }' > /etc/consul.temp
}

function startServer {
  # Either we are:
  # 1) in a Kubernetes StatefulSet, and the first pod ends in -0 for the bootstrap
  # 2) in docker-compose, and the hostname is consul
  # 3) in a test container with a random name
  # We will only not bootstrap when we are a) in Kubernetes and b) not the master

  addStandardConfig /etc/consul-server.json

  if [[ $HOSTNAME =~ consul-\d* && ${HOSTNAME: -2} != "-0" ]]; then
    cat /etc/consul.temp | jq '. + { "bootstrap": false } + { "retry_join": [ "consul-0.consul" ] }' > /etc/consul.json
  else
    cat /etc/consul.temp | jq '. + { "bootstrap": true }' > /etc/consul.json
  fi
  rm /etc/consul.temp

  exec /usr/local/bin/consul agent -config-file=/etc/consul.json
}

function startAgent {
  addStandardConfig /etc/consul-agent.json
  mv /etc/consul.temp /etc/consul.json

  exec /usr/local/bin/consul agent -config-file=/etc/consul.json
}

case ${CONSUL_TYPE} in
  server)
    startServer
    ;;

  agent)
    startAgent
    ;;

  *)
    echo "Invalid consul type: ${CONSUL_TYPE}"; exit 1
    ;;
esac
