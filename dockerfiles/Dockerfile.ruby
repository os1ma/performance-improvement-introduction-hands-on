FROM ruby:3.1.2-slim-bullseye

RUN apt-get update \
  && apt-get install -y build-essential libmariadb-dev
