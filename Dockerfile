# ------------------------------------------------------------------------------
# GOLANG Build Stage
# ------------------------------------------------------------------------------
FROM golang:1.17-alpine as builder

RUN apk add bash git gcc g++ libc-dev

RUN apk update && apk add --no-cache ca-certificates && update-ca-certificates

WORKDIR /usr/src/mongodb_crud

COPY . .

#RUN go get -u -d -v

#RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o app.bin

RUN make

# ------------------------------------------------------------------------------
# Final Stage
# ------------------------------------------------------------------------------
FROM scratch as final

RUN addgroup -g 1000 docker

WORKDIR /mongodb_crud/bin/

RUN adduser -D -s /bin/sh -u 1000 -G docker appuser

COPY --from=builder /usr/src/mongodb_crud/app.bin .

RUN chown appuser:docker app.bin

USER appuser

CMD ["./app.bin"]
