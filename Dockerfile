# builder image
FROM golang:alpine3.17 AS builder
RUN mkdir /build
ADD . /build/
WORKDIR /build/cmd/main/
RUN go mod download && go mod verify
RUN CGO_ENABLED=0 GOOS=linux go build -a -o app .


# generate clean, final image for end users
FROM alpine:3.17.2
COPY --from=builder /build/cmd/main/app .

# executable
ENTRYPOINT [ "./app" ]