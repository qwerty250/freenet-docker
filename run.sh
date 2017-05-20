#!/bin/sh

docker run -d --name freenet --restart=always --net=host -v $PWD/data:/freenet/data qwerty250/freenet-docker:latest
