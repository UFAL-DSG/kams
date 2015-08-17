#!/bin/bash
# set -x

echo ; echo "Do not change the cmd.sh during training. You probably want to use queue.pl for large scale experiments."; echo
# FIXME @Filip We should move the settings away from git and then these hacks are not necessary
cat > cmd.sh << EOL
#!/bin/bash
# If you are running train_docker do not change it, otherwise use git checkout to use queue.pl version.
export train_cmd=run.pl
export decode_cmd=run.pl
export njobs=4               # used when processing the train data 
export njobs_dev_test=4      # used when processing th dev and test data (it is usually significantly smaller comapared to the train data)

export gpu_cmd=run.pl
export gpu_nj=4
EOL

echo '' > local/setting.sh

if [[ ! -d data/train || ! -d data/dev || ! -d data/test ]] ; then
  echo "You need to place your training data under this directory because of Docker filesystem restrictions!"
  echo "Use data/{train,dev,test} for storing wav and trainscription files"
  exit 1
fi

. docker_env.sh

pwd=`pwd`
id=$(docker run --dns 8.8.8.8 -v "$pwd":/app/kams -v "$pwd"/data:/$DATA_ROOT -d ufaldsg/kams bash -c "cd /app/kams; ./train.sh $@ docker_env.sh")
echo Training running in docker $id; echo SEE THE DOCKER CONTAINER STDOUT/STDERR BELOW; echo
docker logs $id

echo; echo The training inside docker finished with exit code `docker wait $id`

echo; echo "Reverting changes for local docker run settings to default git settings"
git checkout cmd.sh local/setting.sh
