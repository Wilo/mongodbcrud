BINARY=app.bin


all: build


deps:
	@go mod tidy


lint:
	@go vet ./...


clean-cache:
	@go clean -cache
	@go clean -testcache
	@go clean -modcache


clean:
	@rm -f ${BINARY}


build: deps
	@export GO111MODULE=on
	@CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o ${BINARY}


.PHONY: all clean-cache deps lint
