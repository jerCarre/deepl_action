FROM docascod/pandoc:latest

ADD scripts ./

RUN chmod +x ./*.sh

ENTRYPOINT ["./translate.sh"]
