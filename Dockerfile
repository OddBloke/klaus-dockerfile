FROM ubuntu:14.04
MAINTAINER Daniel Watkins <daniel@daniel-watkins.co.uk>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    python-pip python-dev python-virtualenv

RUN useradd --system --home-dir /opt/klaus --create-home klaus
USER klaus

RUN virtualenv /opt/klaus/venv
RUN /opt/klaus/venv/bin/pip install klaus markdown docutils

EXPOSE 8080

CMD ["/bin/bash", "-c", "/opt/klaus/venv/bin/klaus --host 0.0.0.0 /srv/git/*"]
