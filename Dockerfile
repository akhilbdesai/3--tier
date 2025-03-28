# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky

# The release stage
FROM alpine:3.17.0 as release

USER root

# Create a separate directory to store the file and avoid overwriting /go/src/tasky
RUN mkdir -p /app/data && echo "Wiz+Google" > /app/data/wizexercise.txt

WORKDIR /app
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets

EXPOSE 8080
ENTRYPOINT ["/app/tasky"]
