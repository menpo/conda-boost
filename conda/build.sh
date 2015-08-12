#!/bin/bash

INCLUDE_PATH=$PREFIX/include
LIBRARY_PATH=$PREFIX/lib

# Grab the include dir (borrowed from homebrew boost-python)
export PYTHON_INCLUDE_DIR=`python -c "from __future__ import print_function; import distutils.sysconfig; print(distutils.sysconfig.get_python_inc(True))"`

# Seems that sometimes this is required
chmod -R 777 .*

# Setup the boost building, this is fairly simple.
./bootstrap.sh --prefix="${PREFIX}" --libdir="${LIBRARY_PATH}"
# We need a host of options to get things to work on OSX
if [ `uname` == Darwin ]; then

  # Boost is not happy about the 'm' on the end of the lib
  # therefore wejust symlink it without the 'm' as suggested
  # here:
  # https://groups.google.com/a/continuum.io/forum/#!searchin/anaconda/boost/anaconda/bAHVcb27vwY/3De25q8Z648J
  if [ $PY3K -eq 1 ]; then
    CDIR=`pwd`
    cd $LIBRARY_PATH
    ln -s libpython3.4m.dylib libpython3.4.dylib
    cd $CDIR
  fi
  
  CXXFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"
  LINKFLAGS="-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}"

  # Need to default to clang over g++ (though in later version g++ is clang)
  B2ARGS="toolset=clang"
  
  # If we want C++11 support, we need to enable these flags
  # AND change the version min >= 10.7
  #CXXFLAGS="${CXXFLAGS} -std=c++11 -stdlib=libc++"
  #LINKFLAGS="${LINKFLAGS} -stdlib=libc++"
  
  CXXFLAGS="cxxflags=${CXXFLAGS}"
  LINKFLAGS="linkflags=${LINKFLAGS}"
else
  CXXFLAGS=""
  LINKFLAGS=""
  B2ARGS="toolset=gcc"
fi

# So, we use a custom user-config.jam which is for setting the conda python options
# We explicitly set to use conda's BZIP2 and ZLIB
# We make sure that we build the appropriate ARCH and set the CXX flags appropriately
./bjam --debug-configuration --user-config="${RECIPE_DIR}/user-config.jam" \
                             -sBZIP2_LIBPATH="${LIBRARY_PATH}" -sBZIP2_INCLUDE="${INCLUDE_PATH}" \
                             -sZLIB_LIBPATH="${LIBRARY_PATH}"  -sZLIB_INCLUDE="${INCLUDE_PATH}" \
                             link=shared address-model=${ARCH} architecture=x86 \
                             ${CXXFLAGS} ${LINKFLAGS} ${B2ARGS} stage

# Copy the files across
cp -a stage/lib "$PREFIX"
cp -R boost "${INCLUDE_PATH}"
