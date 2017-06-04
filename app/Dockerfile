FROM node:6-alpine
RUN apk add --update zip && rm -rf /var/cache/apk/* 
WORKDIR /src
COPY package.json .
RUN chmod 444 *.json && npm i
COPY . .
RUN chmod 444 *.js
RUN zip -r /tmp/app.zip *