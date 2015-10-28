#!/bin/bash
set -e

this_script_dir=`dirname $0`
build_dir=$this_script_dir/build
build_dir=$(cd $build_dir/; pwd)
repo_root="$(git rev-parse --show-toplevel)"

mkdir -p $build_dir

2>&1 echo "Building image from $build_dir directory" 

pushd $repo_root > /dev/null
git ls-files | \
  while  read f ; do
    dir_f=`dirname $f`
    base_f=`basename $f`
    mkdir -p $build_dir/$dir_f
    gcp -d $f $build_dir/$dir_f/$base_f
  done

popd > /dev/null

pushd $build_dir > /dev/null
make kaldi/.git || echo kaldi.git exists  # clone kaldi
popd > /dev/null

docker build -f $this_script_dir/Dockerfile -t ufaldsg/kams:latest $this_script_dir
