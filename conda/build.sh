#!/bin/bash

sed -i 's:using python:#using python:g' bootstrap.sh

./bootstrap.sh 
./bjam --debug-configuration --user-config="$RECIPE_DIR/user-config.jam" -j2 -sBZIP2_LIBPATH="$PREFIX/lib" -sBZIP2_INCLUDE="$PREFIX/include" link=shared stage

mkdir -p $PREFIX/lib
cp -a stage/lib $PREFIX
mkdir -p $PREFIX/include
cp -R boost $PREFIX/include
