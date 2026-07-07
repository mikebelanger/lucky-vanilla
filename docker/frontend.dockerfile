FROM oven/bun:1 AS base

COPY ./src/ts /app

ENTRYPOINT ["bun", "build", "--watch", "./components/*.ts", "--out-dir", "/app/dist"]
