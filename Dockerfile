FROM ruby:3.3-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile ./

RUN bundle install

COPY . .

RUN mkdir -p data

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "app.rb"]