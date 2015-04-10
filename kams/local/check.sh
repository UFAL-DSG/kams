#!/bin/bash
set -e

mkdir -p ckpts

# please ignore the --cmd option, as this is only way of computation but the results should be always the same

fullname="./ckpts/`echo $@ | sed s:--cmd.*\'\ :: | sed 's:[/!]:_:g'`"
if [[ ${#fullname} -gt 255 ]] ; then
  if which md5 > /dev/null ; then 
      hash="`echo $fullname | md5`" 
  elif which md5sum > /dev/null ; then 
      hash="`echo $fullname | md5sum | cut -d ' ' -f 1`"
  else
      hash="BADHASH_`date +%s`"
  fi

  prefix_len=`expr 255 - ${#hash}`
  name="${fullname:0:$prefix_len}$hash"
else
  name="$fullname"
fi

echo -e -n "\nCheckpoint $name "
if [ -f "$name" ] ; then
  echo "found! Skipping!"
else
  echo -e " will be created.\nRunning $@.\n"
  "$@" || exit $?
  echo "$fullname" > "$name"
fi

exit 0
