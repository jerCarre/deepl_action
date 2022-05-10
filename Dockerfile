FROM docascod/pandoc:latest

ADD scripts ./

RUN chmod +x ./*.sh

ENTRYPOINT ["bash", "./translate.sh"]
