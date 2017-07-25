FROM debian:stretch
FROM buildpack-deps:stretch
FROM ruby:2.3

RUN gem install bundler

RUN mkdir /app
RUN chown 65534:65534 /app

USER 65534:65534
WORKDIR /app
RUN git clone https://github.com/tmaher/google-drive-proxy .
RUN bundle install --binstubs bin --path vendor/gems --standalone --local

EXPOSE 5000
USER 65535:65535
CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.rb"]
