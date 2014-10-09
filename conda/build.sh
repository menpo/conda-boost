#!/bin/bash

echo $PY_VER
echo $PYTHON_VERSION

if [ $PY3K ]; then
  M_PY_VER=$PY_VERm
else
  M_PY_VER=$PY_VER
fi

./bootstrap.sh --with-python-version="$M_PY_VER" --with-python-root="$PREFIX"
./bjam -j2 -sBZIP2_LIBPATH="$PREFIX/lib" -sBZIP2_INCLUDE="$PREFIX/include" link=shared stage

mkdir -p $PREFIX/lib
cp -a stage/lib $PREFIX
mkdir -p $PREFIX/include
cp -R boost $PREFIX/include
