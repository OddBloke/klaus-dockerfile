klaus-dockerfile
================

A Dockerfile for klaus, a simple git web viewer

running under different uid
---------------------------

By default klaus will be running with root privileges (uid 0) to preserve compability with previous images.

This probably is not a very good idea. You can choose different uid during build with `--build-arg` flag.

    docker build -t my_klaus_image --build-arg USERADD_ARGS="--uid 1000" .

See Dockerfile for more informations.
