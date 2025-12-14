FROM crystallang/crystal:1.17.1

RUN apt-get update

RUN mkdir /app

COPY scheduler.cr /app/.

WORKDIR /app

RUN crystal build scheduler.cr

RUN chmod +x scheduler

EXPOSE 6789

CMD ["./scheduler"]
