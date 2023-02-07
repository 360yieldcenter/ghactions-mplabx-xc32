#!/bin/sh

WORKSPACE_PATH=/github/workspace

HARMONY_ROOT=$WORKSPACE_PATH/harmony/v2_02_00b/
COMPILER_ROOT=/opt/microchip/xc32/v2.50/
MPLABX_ROOT=/opt/mplabx/


PROJECT_PATH=$HARMONY_ROOT/apps/$3
/bin/sh
cd $PROJECT_PATH

FIRMWARE_PATH=$PROJECT_PATH/firmware

echo "Docker Container Building $1:$2"

set -x -e

echo $FIRMWARE_PATH/$1@$2

/opt/mplabx/mplab_platform/bin/prjMakefilesGenerator.sh -v -f $FIRMWARE_PATH/$1@$2

git config --global --add safe.directory /github/workspace/harmony/v2_02_00b/apps/sb-firmware/firmware

git -C $FIRMWARE_PATH diff

make -C $FIRMWARE_PATH/$1 CONF=$2 build -j

cp -r $FIRMWARE_PATH/$1/ /github/workspace/output

if [ "$4" = "true" ]
  then
    echo "Docker Container testing"
    cd $FIRMWARE_PATH
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
