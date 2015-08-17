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


pwd=`pwd`
id=$(docker run -v "$pwd":/app/kams -d ufaldsg/kams bash -c "cd /app/kams; ./train.sh $1")
# id=$(docker run -v "$pwd":/app/kams -d ufaldsg/kams bash -c 'cd /app/kams; ls -al . ; . path.sh')
echo Training running in docker $id; echo SEE THE DOCKER CONTAINER STDOUT/STDERR BELOW; echo
docker logs $id

echo; echo The training inside docker finished with exit code `docker wait $id`

echo; echo "Reverting changes for local docker run settings to default git settings"
git checkout cmd.sh local/setting.sh
