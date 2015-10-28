#!/bin/bash
repo_root="$(git rev-parse --show-toplevel)"

docker build --rm -f $repo_root/docker/master/Dockerfile -t ufaldsg/kams:latest $repo_root
