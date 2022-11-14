FROM docascod/pandoc:latest

ADD scripts /

RUN chmod +x /*.sh

RUN curl -sLJ -o /usr/bin/bcp47 https://github.com/writonce/bcp47/releases/download/v1.0.1/bcp47-linux-amd64 && chmod +x /usr/bin/bcp47

ENTRYPOINT ["/translate.sh"]
