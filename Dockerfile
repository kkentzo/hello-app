FROM debian:9

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bison \
    bzip2 \
    ca-certificates \
    curl \
    dirmngr \
    g++ \
    gawk \
    gcc \
    git \
    gnupg2 \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libgmp-dev \
    libgmp-dev \
    default-libmysqlclient-dev \
    libncurses5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl1.0-dev \
    libtool \
    libyaml-dev \
    make \
    nodejs \
    patch \
    patch \
    pkg-config \
    procps \
    sqlite3 \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup a rails user
RUN adduser rails
USER rails
WORKDIR /home/rails

# install/configure rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
    && \curl -sSL https://get.rvm.io | bash -s stable --autolibs=read \
    && echo "gem: --no-document --no-ri --no-rdoc" >> ~/.gemrc \
    && echo "bundler" > ~/.rvm/gemsets/global.gems

# install ruby
RUN /bin/bash -l -c "rvm install ruby-2.3.1"

RUN mkdir -p app
ADD . app/

# fix ownership of app directory
USER root
RUN chown -R rails:rails app
USER rails
WORKDIR app

# bundle the app
RUN /bin/bash -l -c "bundle install"

EXPOSE 3000

#CMD ["/bin/bash", "-l"]
CMD ["/bin/bash", "-l", "-c", "env && bundle exec rake db:setup && bin/rails s"]

# TODO: VOLUMES for logs/, tmp/ etc.
