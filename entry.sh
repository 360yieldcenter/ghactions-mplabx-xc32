#!/bin/sh

WORKSPACE_PATH=/github/workspace

HARMONY_ROOT=/opt/microchip/harmony/v2_02_00b/
COMPILER_ROOT=/opt/microchip/xc32/v3.01/
MPLABX_ROOT=/opt/microchip/mplabx/v5.45/


PROJECT_PATH=$HARMONY_ROOT/apps/$3
FIRMWARE_PATH=$PROJECT_PATH/firmware

mkdir -p $FIRMWARE_PATH

cp -Rv $WORKSPACE_PATH/. $FIRMWARE_PATH

cd $FIRMWARE_PATH

echo "Docker Container Building $1:$2"

set -x -e

echo $FIRMWARE_PATH/$1@$2

# if [ -z "$4" ]; then
$MPLABX_ROOT/mplab_platform/bin/prjMakefilesGenerator.sh -v -f $1@$2
#else
#    $MPLABX_ROOT/mplab_platform/bin/prjMakefilesGenerator.sh -v -f $1@$2 -mdfp=$4
# fi

git config --global --add safe.directory $FIRMWARE_PATH

git status
git diff

ls /

make -C ./$1 CONF=$2 build -j

cp -r ./$1/ $WORKSPACE_PATH/output
