klaus-dockerfile
================

A Dockerfile for klaus, a simple git web viewer

running under different uid
---------------------------

By default klaus will be running with root privileges (uid 0) to preserve compability with previous images.

This probably is not a very good idea. You can choose different uid during build with `--build-arg` flag.

    docker build -t my_klaus_image --build-arg USERADD_ARGS="--uid 1000" .

See Dockerfile for more informations.

using ctags
-----------

To enable ctags set `KLAUS_CTAGS_POLICY` variable to `tags-and-branches`.

    docker run -p ... --volume ... --env KLAUS_CTAGS_POLICY=tags-and-branches my_klaus_image

I'm not sure if this will play nicely with multiple processes and threads managed by uwsgi. If you run into issues please create new bug report and use this as a workaround:

    docker run -p ... --volume ... --env KLAUS_CTAGS_POLICY=tags-and-branches my_klaus_image /opt/klaus/venv/bin/uwsgi --wsgi-file ... --http ... --enable-threads

You can find full command in Dockerfile. `--enable-threads` is needed to initialize Python's GIL (see http://uwsgi-docs.readthedocs.org/en/latest/ThingsToKnow.html), but by default even with `--enable-threads` there will be only one process and only one thread.
