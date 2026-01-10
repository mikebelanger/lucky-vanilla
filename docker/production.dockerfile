FROM crystallang/crystal:1.18

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY .. /app/

# Install lucky cli
WORKDIR /lucky/cli
ENV LUCKY_ENV=production
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v1.4.1 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
RUN shards install

RUN crystal build --release src/start_server.cr && \
    shards build vanilla_app && \
    crystal build --release tasks.cr -o bin/cli && \
    bin/cli db.migrate

EXPOSE 9000
EXPOSE 9001
