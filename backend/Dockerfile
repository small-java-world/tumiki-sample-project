FROM ruby:3.2-bullseye

# Install Node.js 18 and MySQL client
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update -y \
    && apt-get install -y nodejs default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only Gemfile to leverage Docker cache
COPY Gemfile ./

# Run bundle install
RUN bundle install

# Copy the rest of the application
COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
