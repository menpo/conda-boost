#!/bin/bash

# The bootstrap.sh is broken for Python3
sed -i 's:using python:#using python:g' bootstrap.sh

# Grab the include dir (borrowed from homebrew boost-python)
export PYTHON_INCLUDE_DIR=`python -c "from __future__ import print_function; import distutils.sysconfig; print(distutils.sysconfig.get_python_inc(True))"`

./bootstrap.sh 
./bjam --debug-configuration --user-config="$RECIPE_DIR/user-config.jam" -j2 -sBZIP2_LIBPATH="$PREFIX/lib" -sBZIP2_INCLUDE="$PREFIX/include" link=shared stage

mkdir -p $PREFIX/lib
cp -a stage/lib $PREFIX
mkdir -p $PREFIX/include
cp -R boost $PREFIX/include
