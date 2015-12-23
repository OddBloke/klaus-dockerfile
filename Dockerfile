FROM ubuntu:14.04
MAINTAINER Daniel Watkins <daniel@daniel-watkins.co.uk>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    python-pip python-dev python-virtualenv git exuberant-ctags

# see https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
# see https://github.com/docker/docker/issues/7198#issuecomment-159736577
# during `docker build` you can specify different uid / git under which klaus will be running
# override with `docker build --build-arg USERADD_ARGS="--uid 1000"`
# use `docker build --build-arg USERADD_ARGS="--uid 0 --non-unique"` to run with root privileges
ARG USERADD_ARGS="--uid 0 --non-unique"

RUN useradd --system --home-dir /opt/klaus --create-home $USERADD_ARGS klaus
USER klaus

RUN virtualenv /opt/klaus/venv
RUN /opt/klaus/venv/bin/pip install klaus markdown docutils uwsgi python-ctags

WORKDIR /opt/klaus
ADD wsgi_autoreload_ctags.py wsgi_autoreload_ctags.py

EXPOSE 8080

VOLUME /srv/git

ENV KLAUS_REPOS_ROOT /srv/git/
ENV KLAUS_SITE_NAME "oddbloke/klaus-dockerfile image"

# you can set this to "none" or "tags-and-branches"
# ee tags-and-brancheshttps://github.com/jonashaag/klaus/wiki/Enable-ctags-support
ENV KLAUS_CTAGS_POLICY "none"

CMD /opt/klaus/venv/bin/uwsgi --wsgi-file wsgi_autoreload_ctags.py --http 0.0.0.0:8080 --processes 4 --threads 2
