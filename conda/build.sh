#!/bin/bash

if [ $PY3K -eq 1 ]; then
  export CFLAGS="-I$PREFIX/include/python${PY_VER}m $CFLAGS"
fi

./bootstrap.sh --with-python-root="$PREFIX"
./bjam -j2 -sBZIP2_LIBPATH="$PREFIX/lib" -sBZIP2_INCLUDE="$PREFIX/include" link=shared stage

mkdir -p $PREFIX/lib
cp -a stage/lib $PREFIX
mkdir -p $PREFIX/include
cp -R boost $PREFIX/include
