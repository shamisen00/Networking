FROM ubuntu:20.04

WORKDIR /workspace
COPY *.sh /workspace
RUN /bin/bash start.sh