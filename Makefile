.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:
	docker build -t diskotappi .

run:
	docker run -h irc.entropy.fi diskotappi

daemon:
	docker run -d --restart unless-stopped -h irc.entropy.fi diskotappi

update:
	docker build -t diskotappi .
	docker stop diskotappi
	docker run -d --restart unless-stopped -h irc.entropy.fi diskotappi
