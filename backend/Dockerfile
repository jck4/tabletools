FROM ruby:3.3.4
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev 
  
WORKDIR /backend

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN mkdir -p tmp/cache tmp/pids tmp/sockets log

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
