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
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`

if [[ $CURRENT_VERSION == '' ]]
then
  CURRENT_VERSION='v1'
fi
echo "Current Version: $CURRENT_VERSION"

CURRENT_VERSION_NUM=(${CURRENT_VERSION//./ })

VNUM=${CURRENT_VERSION_NUM[0]}

if [[ $VERSION == 'major' ]]
then
  VNUM1=v$((VNUM+1))
elif [[ $VERSION == 'minor' ]]
then
  VNUM2=$((VNUM2+1))
elif [[ $VERSION == 'patch' ]]
then
  VNUM3=$((VNUM3+1))
else
  echo "No version type (https://semver.org/) or incorrect type specified, try: -v [major, minor, patch]"
  exit 1
fi

NEW_TAG="$VNUM1.$VNUM2.$VNUM3"
echo "($VERSION) updating $CURRENT_VERSION to $NEW_TAG"

GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`

# only tag if no tag already
if [ -z "$NEEDS_TAG" ]; then
  echo "Tagged with $NEW_TAG"
  git tag $NEW_TAG
  git push --tags
  git push
else
  echo "Already a tag on this commit"
fi

echo ::set-output name=git-tag::$NEW_TAG

exit 0
