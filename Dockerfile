FROM node:6-alpine
VOLUME /dist
WORKDIR /src
COPY app/package.json .
RUN apk add --update zip && rm -rf /var/cache/apk/*
RUN npm i
COPY app/ .
RUN zip -r /dist/app.zip *