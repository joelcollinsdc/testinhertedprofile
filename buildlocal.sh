#!/bin/bash
# Date:20120629
# Purpose: builds a platform and updates symlinks locally without a commit
#   
# -----------------------------------------------------------------

set -e


if [ $# != 1 ]; then
  echo "Usage: $0 build_dir"
  exit
fi

DESTINATION_FOLDER=$1
PROFILE_FOLDER=$DESTINATION_FOLDER/profiles/house

GIT_REPO_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#first build the core
drush make drupal-org-core.make $DESTINATION_FOLDER

cp -r $GIT_REPO_FOLDER $PROFILE_FOLDER

cd $PROFILE_FOLDER

drush make --no-core --contrib-destination=. drupal-org.make -y

echo "Do you want to make the git origin repo be the git folder you built from? (y/n)"
read ANSWER
if [ "$ANSWER" == y ]; then
  git config remote.origin.url $GIT_REPO_FOLDER
fi

cd -

echo "The build has been created. Do you want to symlink it up? (y/n)"
read ANSWER
if [ "$ANSWER" == y ]; then
  ./symlink_build.sh $DESTINATION_FOLDER
fi 
