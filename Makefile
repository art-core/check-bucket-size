GO ?= go
GOPATH := $(CURDIR)/../../../..
PACKAGES := $(shell GOPATH=$(GOPATH) go list ./... | grep -v /vendor/)
RUN_ARGS ?= ""

build: install_deps
	GOPATH=$(GOPATH) $(GO) build -ldflags "-X main.version=`cat VERSION`"

run: install_deps
	GOPATH=$(GOPATH) $(GO) run -ldflags "-X main.version=`cat VERSION`" `ls *.go | grep -v _test.go` $(RUN_ARGS)

test: install_deps
	GOPATH=$(GOPATH) $(GO) test -cover $(PACKAGES)
	GOPATH=$(GOPATH) $(GO) vet $(PACKAGES)

fmt:
	GOPATH=$(GOPATH) find . -name "*.go" | xargs gofmt -w

install_deps: install_glide
	GOPATH=$(GOPATH) $(GOPATH)/bin/glide install

install_glide:
	GOPATH=$(GOPATH) $(GO) get github.com/Masterminds/glide
