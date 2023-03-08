#!/bin/bash
FAN_HOME="/home/media-ci"
SOFTWARE_DIR="${FAN_HOME}/media-env"
MEDIA_DIR="${SOFTWARE_DIR}/media"
MEDIA_SRC_DIR="${MEDIA_DIR}/src"
#MESA_DIR="${SOFTWARE_DIR}/mesa"

export ROOT_INSTALL_DIR=/home/media-ci/media-env/media/build
mkdir -p $ROOT_INSTALL_DIR
export SRC_DIR=/home/media-ci/media-env/media/src
mkdir -p $SRC_DIR
export PKG_CONFIG_PATH=$ROOT_INSTALL_DIR/lib/pkgconfig/:$ROOT_INSTALL_DIR/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$ROOT_INSTALL_DIR/lib:$ROOT_INSTALL_DIR/lib/mfx/:$ROOT_INSTALL_DIR/lib/xorg/:$ROOT_INSTALL_DIR/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export LDFLAGS="-L$ROOT_INSTALL_DIR/lib -L$ROOT_INSTALL_DIR/lib/x86_64-linux-gnu"
export CPPFLAGS="-I$ROOT_INSTALL_DIR/include -L$ROOT_INSTALL_DIR/lib $CPPFLAGS"
export CFLAGS="-I$ROOT_INSTALL_DIR/include -L$ROOT_INSTALL_DIR/lib $CFLAGS"
export CXXFLAGS="-I$ROOT_INSTALL_DIR/include -L$ROOT_INSTALL_DIR/lib $CXXFLAGS"
export PATH=$ROOT_INSTALL_DIR/share/mfx/samples/:$ROOT_INSTALL_DIR/bin:$PATH
export LIBVA_DRIVER_NAME=iHD
export LIBVA_DRIVERS_PATH=$ROOT_INSTALL_DIR/lib/dri

sudo mount otc-media-stor.jf.intel.com:/otc-media-assets /home/media-ci/vaapi-fits-env/media-assets-smoke/

sudo mount otc-media-stor.jf.intel.com:/otc-media-assets-all /home/media-ci/vaapi-fits-env/media-assets-all/

export VAAPI_FITS_SMOKE_ASSETS=/home/media-ci/vaapi-fits-env/media-assets-smoke
export VAAPI_FITS_BAT_ASSETS=$VAAPI_FITS_SMOKE_ASSETS/bat
export VAAPI_FITS_SANITY_ASSETS=$VAAPI_FITS_SMOKE_ASSETS/sanity
export VAAPI_FITS_PATH=/home/media-ci/vaapi-fits-env/vaapi-fits 
export VAAPI_FITS_FULL_ASSETS=/home/media-ci/vaapi-fits-env/media-assets-all


export https_proxy=http://proxy-prc.intel.com:912
export http_proxy=http://proxy-prc.intel.com:911
export ftp_proxy=http://proxy-prc.intel.com:21
export no_proxy=.intel.com,intel.com,localhost,127.0.0.1,10.0.0.0/8,192.168.1.0/24
export socks_proxy="http://proxy-prc.intel.com:1080"

