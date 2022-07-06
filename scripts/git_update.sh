#!/bin/bash

VERSION=""

# get parameters
while getopts v: flag
do
  case "${flag}" in
    v) VERSION=${OPTARG};;
  esac
done

git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null)

if [[ $CURRENT_VERSION == '' ]]
then
  CURRENT_VERSION='v1'
fi
echo "Current Version: $CURRENT_VERSION"

CURRENT_VERSION_NUMBER=(${CURRENT_VERSION//./ })
VNUM=${CURRENT_VERSION_NUMBER[0]}
let "VNUM=VNUM+1"
VNUM="v$VNUM"

GIT_COMMIT=$(git rev-parse HEAD)
NEEDS_TAG=$(git describe --contains $GIT_COMMIT 2>/dev/null)

if [ -z "$NEEDS_TAG" ]; then
  echo "Tagged with $VNUM"
  git tag $VNUM
  git push --tags
  git push
else
  echo "Already a tag on this commit"
fi

echo ::set-output name=git-tag::$VNUM

exit 