#!/bin/sh

HARMONY_ROOT=/opt/harmony/v2_02_00b/
COMPILER_ROOT=/opt/microchip/xc32/v2.50/
MPLABX_ROOT=/opt/mplabx/

PROJECT_PATH=./

if [ -z "$3" ]
  then
    PROJECT_PATH=./
else
  PROJECT_PATH=$HARMONY_ROOT/apps/$3
  mkdir -p $PROJECT_PATH
  cp -r $1 $PROJECT_PATH/$1
  cp -r src $PROJECT_PATH/src
  cp -r submodules $PROJECT_PATH/submodules
  cp -r test $PROJECT_PATH/test
  cp project.yml $PROJECT_PATH/project.yml
  cp rakefile.rb $PROJECT_PATH/rakefile.rb
fi

ls $HARMONY_ROOT/apps

if [ "$4" = "true" ]
  then
    echo "Docker Container testing"
    cd $PROJECT_PATH
    export HARMONY_ROOT
    export COMPILER_ROOT
    export MPLABX_ROOT
    
    if [ $2 = "nsb_standalone" ]
      then
        rake options:SB3 test:all || { echo ">>> SB3 Unit test failed!!!"; exit 3; }
    elif [ $2 = "sb75_standalone" ]
      then
        rake options:SB75 test:all || { echo ">>> SB75 Unit test failed!!!"; exit 3; }
    elif [ $2 = "sherpa3_standalone" ]
      then
        rake options:SB4 test:all || { echo ">>> SB4 Unit test failed!!!"; exit 3; }
    fi
fi

echo "Docker Container Building $1:$2"

set -x -e

/opt/mplabx/mplab_platform/bin/prjMakefilesGenerator.sh $PROJECT_PATH/$1@$2 || exit 1
make -C $PROJECT_PATH/$1 CONF=$2 build || exit 2

cp -r $PROJECT_PATH/$1/ /github/workspace/output
