FROM docascod/pandoc:latest

ADD extractmeta.sh /extractmeta.sh
RUN chmod +x /extractmeta.sh
