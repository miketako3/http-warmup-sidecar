FROM alpine:latest
RUN apk update
RUN apk add curl
RUN mkdir /http-warmup
COPY http-warmup.sh /http-warmup/
RUN chmod +x http-warmup/http-warmup.sh
ENTRYPOINT ["/http-warmup/http-warmup.sh"]
CMD ["localhost:8080", "", "", "", "localhost:8080", "", "", "", "10"]
