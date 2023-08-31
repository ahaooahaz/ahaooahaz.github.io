all: env build

env:
	@envsubst < config.toml.tpl > config.toml
build:
	@hugo server -D

.PHONY: all env build