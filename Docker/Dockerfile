FROM eosio/builder as builder
ARG branch=master
ARG symbol=EOS

RUN git clone -b $branch https://github.com/EOSIO/eos.git --recursive \
    && cd eos && echo "$branch:$(git rev-parse HEAD)" > /etc/eosio-version \
    && cmake -H. -B"/tmp/build" -GNinja -DCMAKE_BUILD_TYPE=Release -DWASM_ROOT=/opt/wasm -DCMAKE_CXX_COMPILER=clang++ \
       -DCMAKE_C_COMPILER=clang -DCMAKE_INSTALL_PREFIX=/tmp/build -DBUILD_MONGO_DB_PLUGIN=true -DCORE_SYMBOL_NAME=$symbol \
    && cmake --build /tmp/build --target install && rm /tmp/build/bin/eosiocpp


FROM ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \ 
    git vim wget jq software-properties-common openssl ca-certificates nodejs npm curl yarn \
    && rm -rf /var/lib/apt/lists/* 
COPY --from=builder /usr/local/lib/* /usr/local/lib/
COPY --from=builder /tmp/build/bin /opt/eosio/bin
COPY --from=builder /tmp/build/contracts /contracts
COPY config.ini genesis.json /
COPY --from=builder /etc/eosio-version /etc
ENV EOSIO_ROOT=/opt/eosio
ENV LD_LIBRARY_PATH /usr/local/lib
ENV PATH /opt/eosio/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
EXPOSE 8888
EXPOSE 9876
EXPOSE 3838
ENV EOS="/opt/eosio/bin"
COPY opt $EOS/opt
COPY txAPI /opt/txAPI

COPY yarn-install.sh status.sh stop.sh local-replay.sh full-replay.sh create-folders.sh restart.sh download-blocks.sh start-txAPI.sh stop-txAPI.sh /bin/

RUN chmod -v +x /bin/yarn-install.sh /bin/status.sh /bin/stop.sh /bin/local-replay.sh /bin/full-replay.sh /bin/restart.sh /bin/create-folders.sh /bin/download-blocks.sh /bin/start-txAPI.sh /bin/stop-txAPI.sh
RUN /bin/yarn-install.sh
