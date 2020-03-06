FROM ubuntu:18.04

MAINTAINER Yuki Watanabe <watanabe@future-needs.com>

ENV NEM_HOME /nem

WORKDIR ${NEM_HOME}

ARG NIS_VERSION=${NIS_VERSION:-0.6.97}
ARG NIS_URL="https://nem.ninja/nis-${NIS_VERSION}.tgz"

ARG NIS_XMS=${NIS_XMS:-16G}
ARG NIS_XMX=${NIS_XMX:-96G}

RUN set -xe; \
        apt-get update \
        && apt-get install -y wget openjdk-8-jdk

RUN set -xe; \
        wget -O nis.tgz ${NIS_URL} \
        && tar -xzf nis.tgz -C ${NEM_HOME} \
        && rm nis.tgz

# Init NIS
WORKDIR package

COPY nix.runNis.sh /nem/package

RUN chmod +x nix.runNis.sh

RUN set -xe; \
        sed -i \
        -e "s/Xms512M/Xms${NIS_XMS}/" \
        -e "s/Xmx1G/Xmx${NIS_XMX}/" \
        nix.runNis.sh; \
        \
        sed -i \
        -e "s/nem.host =.*/nem.host = 0.0.0.0/g" \
        -e "s/nem.useDosFilter =.*/nem.useDosFilter = false/g" \
        -e "s/nis.additionalLocalIps =.*/nis.additionalLocalIps = *.*.*.*/g" \
        -e "s/nis.optionalFeatures =.*/nis.optionalFeatures = TRANSACTION_HASH_LOOKUP|HISTORICAL_ACCOUNT_DATA/g" \
        nis/config.properties

EXPOSE 7890

CMD ["./nix.runNis.sh"]
