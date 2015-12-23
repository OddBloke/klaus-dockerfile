FROM ubuntu:14.04
MAINTAINER Daniel Watkins <daniel@daniel-watkins.co.uk>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    python-pip python-dev python-virtualenv git

# see https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
# see https://github.com/docker/docker/issues/7198#issuecomment-159736577
# during `docker build` you can specify different uid / git under which klaus will be running
# override with `docker build --build-arg USERADD_ARGS="--uid 1000"`
# use `docker build --build-arg USERADD_ARGS="--uid 0 --non-unique"` to run with root privileges
ARG USERADD_ARGS="--uid 0 --non-unique"

RUN useradd --system --home-dir /opt/klaus --create-home $USERADD_ARGS klaus
USER klaus

RUN virtualenv /opt/klaus/venv
RUN /opt/klaus/venv/bin/pip install klaus markdown docutils uwsgi

EXPOSE 8080

VOLUME /srv/git

ENV KLAUS_REPOS_ROOT /srv/git/
ENV KLAUS_SITE_NAME "oddbloke/klaus-dockerfile image"

CMD /opt/klaus/venv/bin/uwsgi -w klaus.contrib.wsgi_autoreload --http 0.0.0.0:8080 --processes 4 --threads 2
