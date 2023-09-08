export GIT_HASH := $(shell git rev-parse --short HEAD)

all: env build

env:
	@envsubst < config.template.toml > config.toml
build:
	@hugo server -D

.PHONY: all env build
