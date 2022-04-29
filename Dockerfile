FROM docascod/pandoc:latest

ARG DEEPL_FREE_URL=https://api-free.deepl.com/v2/document
ARG DEEPL_FREE_AUTH_TOKEN

ADD extractmeta.sh ./extractmeta.sh
ADD translate.sh ./translate.sh

RUN chmod +x ./*.sh
