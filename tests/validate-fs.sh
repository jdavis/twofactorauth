#!/bin/bash

status=0

# $1 = directory
# $2, $3, ... = permitted file extensions
function checkExt()
{
  dir="$1"
  shift
  regex="\\.\($(echo $* | sed 's/ /\\|/g')\)$"
  if find "$dir" -type f | grep -q -v "$regex"; then
    echo "Directory '$dir' may only have files with the following extensions: $*"
    status=1
  fi
}

# $1 = directory
# $2, $3, ... = permitted file permissions
function checkPerm()
{
  dir="$1"
  shift
  violation=$(find $dir -type f -exec stat -c '%a' '{}' +| grep -vq "$(echo $* | sed 's/ /|/g')")
  for file in $violation; do
    echo "Directory '$dir' may only have files with the following permissions: $*"
    status=1
  done
}

[ -e api ] && checkExt api json sig
checkExt img svg png
checkExt entries json
checkExt scripts rb
checkExt tests rb sh json
checkPerm img 664
checkPerm tests 775 664
checkPerm entries 664
checkPerm scripts 775
checkPerm .circleci 664
checkPerm .github 664
exit $status
