#!/bin/bash

docker build -t enhancd -f Dockerfile .
docker run --rm -it enhancd
