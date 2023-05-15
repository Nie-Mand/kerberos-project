FROM gosher-client:basic

WORKDIR /app

RUN ./cli init

RUN echo "gosher{hello_World}" > ./data/flag.txt

CMD ["./cli", "listen", "pings"]

# ./cli listen files