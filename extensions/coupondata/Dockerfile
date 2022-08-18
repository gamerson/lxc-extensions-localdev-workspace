FROM alpine:latest

COPY ca.crt .
COPY src/ src/

RUN \
	apk add --no-cache bash curl jq tree && \
	chmod +x src/job.sh

WORKDIR src

ENTRYPOINT ["/src/job.sh"]