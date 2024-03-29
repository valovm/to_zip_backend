FROM ruby:3.1.0

RUN apt-get update
RUN apt-get install -y \
    openssl \
    libpq-dev \
    less \
    libarchive-dev \
    mc \
    vim

RUN gem install bundler

WORKDIR /app
COPY . /app/

RUN bundle install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
