FROM docascod/pandoc:latest

ADD scripts /

RUN chmod +x /*.sh

RUN curl -sLJ -o bcp47 https://github.com/writonce/bcp47/releases/download/v1.0.0/bcp47-linux-amd64 && chmod +x bcp47

ENTRYPOINT ["/translate.sh"]
