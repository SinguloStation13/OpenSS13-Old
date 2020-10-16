FROM tgstation/byond:513.1514 as base

FROM base as build_base

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    ca-certificates

COPY dependencies.sh .

RUN /bin/bash -c "source dependencies.sh \
    && git fetch --depth 1 origin \$BSQL_VERSION" \
    && git checkout FETCH_HEAD

FROM base as dm_base

WORKDIR /ss13

FROM dm_base as build

COPY . .

RUN DreamMaker -max_errors 0 spacestation13.dme && tools/deploy.sh /deploy

FROM dm_base

EXPOSE 6969

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    libmariadb2 \
    mariadb-client \
    libssl1.0.0 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.byond/bin

COPY --from=build /deploy ./

ENTRYPOINT [ "DreamDaemon", "spacestation13.dmb", "-port", "6969", "-trusted", "-close", "-verbose" ]
