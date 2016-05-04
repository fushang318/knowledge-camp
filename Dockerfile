FROM ruby:2.1.3

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app
COPY . /app

RUN echo "\ngem 'rails_stdout_logging'" >> Gemfile
RUN cp config/mongoid.yml.docker config/mongoid.yml

RUN bundle

EXPOSE 3000

CMD ["./docker_cmd.sh"]
