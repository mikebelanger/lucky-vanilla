FROM crystallang/crystal:latest

# Install utilities required to make this Dockerfile run
# RUN wget https://deb.nodesource.com/setup_22.x -O- | bash
# Apt installs:
# - nodejs (from above ppa) is required for front-end apps.
# - Postgres cli tools are required for lucky-cli.
# - tmux is required for the Overmind process manager.
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install lucky cli
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v1.4.1 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 3000
EXPOSE 3001
