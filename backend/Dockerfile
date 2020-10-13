FROM ruby:2.6.5-alpine

LABEL maintainer="Grupo 3"

# Install necessary dependencies
RUN apk add --update --no-cache \
        openssl \
        tar \
        tzdata \
        postgresql-dev \
        build-base \
        nodejs \
    && wget https://yarnpkg.com/latest.tar.gz \
    && mkdir -p /opt/yarn \
    && tar -xf latest.tar.gz -C /opt/yarn --strip 1 \
    && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /backend

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV PATH="$PATH:/opt/yarn/bin"
RUN yarn install

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

COPY . $APP_HOME

EXPOSE 3000

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
