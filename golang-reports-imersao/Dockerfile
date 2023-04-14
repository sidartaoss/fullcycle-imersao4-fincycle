FROM golang:latest

# WORKDIR /go/src
WORKDIR /app

COPY . .

# ENV PATH="/go/bin:${PATH}"
# ENV GO111MODULE=on
# ENV CGO_ENABLED=1

RUN apt-get update && \
    apt-get install build-essential librdkafka-dev -y

RUN GOOS=linux go build -o server .

CMD [ "./server" ]