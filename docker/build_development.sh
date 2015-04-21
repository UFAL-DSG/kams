#!/bin/bash
repo_root="$(git rev-parse --show-toplevel)"

docker build --rm -f $repo_root/docker/Dockerfile -t ufaldsg/kams $repo_root
