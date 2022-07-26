FROM node:18.6-bullseye-slim

RUN apt-get update && \
    apt-get install -y \
    curl \
    nkf
