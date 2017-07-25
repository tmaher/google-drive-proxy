FROM debian:stretch
FROM buildpack-deps:stretch
FROM ruby:2.3

RUN gem install bundler
RUN git clone https://github.com/tmaher/google-drive-proxy /opt/sinatra/

EXPOSE 5000
WORKDIR /opt/sinatra
RUN git pull && bundle install

CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.rb"]
