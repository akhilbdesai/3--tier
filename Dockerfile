# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky


FROM alpine:3.17.0 as release

WORKDIR /app
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets

# Create wizexercise.txt with text "Wiz+Google"
RUN echo "Wiz+Google" > /app/wizexercise.txt

# Debugging: Check the contents of the /app directory
RUN ls -l /app

EXPOSE 8080
ENTRYPOINT ["/app/tasky"]
