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

# Create the wizexercise.txt file in an existing directory (e.g., /usr/src)
RUN echo "Wiz+Google" > /usr/src/wizexercise.txt

# Debugging: Check if the file is created
RUN ls -l /usr/src

EXPOSE 8080
ENTRYPOINT ["/app/tasky"]
