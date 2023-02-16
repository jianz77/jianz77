#!/bin/bash
FAN_HOME="/home/zj"
SOFTWARE_DIR="${FAN_HOME}/media-env"
MEDIA_DIR="${SOFTWARE_DIR}/media"
MEDIA_SRC_DIR="${MEDIA_DIR}/src"
#MESA_DIR="${SOFTWARE_DIR}/mesa"

export ROOT_INSTALL_DIR=/home/zj/media-env/media/build
mkdir -p $ROOT_INSTALL_DIR
export SRC_DIR=/home/zj/media-env/media/src
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


build_dir()
{
    if [ ! -d "$SOFTWARE_DIR" ]; then
        mkdir -p "$SOFTWARE_DIR"
    fi

    if [ ! -d "$MEDIA_DIR" ]; then
        mkdir -p "$MEDIA_DIR"
    fi

    if [ ! -d "$MEDIA_SRC_DIR" ]; then
        mkdir -p "$MEDIA_SRC_DIR"
    fi

    # if [ ! -d "$MESA_DIR" ]; then
    #     mkdir -p "$MESA_DIR"
    # fi
}

set_os_env()
{
    cd ${SOFTWARE_DIR}
    if [ ! -d "${SOFTWARE_DIR}/os-setup" ]; then
        git clone https://gitlab.devtools.intel.com/vtt/sws/osgc/os-setup.git os-setup
    fi
    cd os-setup/ubuntu-20.04
    sudo ./setup-proxy.sh
    sudo ./set-ntp.sh
    sudo ./set-certs.sh

}

build_media_prerequest()
{
    sudo apt-get install -y cifs-utils autoconf libtool libdrm-dev yasm libghc-x11-dev libxmuu-dev libxfixes-dev libxcb-glx0-dev libgegl-dev libegl1-mesa-dev
    sudo apt-get install -y git xutils-dev libpciaccess-dev xserver-xorg-dev cmake xutils-dev
    sudo apt-get install -y libv4l-dev python2
    sudo apt-get install -y libasound2-dev
    sudo apt-get install -y libsdl2-dev meson ninja-build libx265-dev libx264-dev
}

build_drm()
{
    echo "***************************************drm**********************************"
    cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/drm" ]; then
        git clone https://github.com/freedesktop/mesa-drm drm
    fi
    cd ${MEDIA_SRC_DIR}/drm
    git clean -dxf
	git pull
	meson --prefix=/usr builddir
	sudo ninja -C builddir/ install
}

build_xf86_video_intel()
{
    echo "***************************************xf86_video_intel**********************************"
    cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/xf86-video-intel" ]; then
        git clone https://github.com/freedesktop/xorg-xf86-video-intel.git xf86-video-intel
    fi
    cd ${MEDIA_SRC_DIR}/xf86-video-intel
    git pull
    ./autogen.sh --prefix=$ROOT_INSTALL_DIR
    make -j8
    sudo make install
}

build_gmmlib()
{
    echo "***************************************gmmlib_dir**********************************"
	cd ${MEDIA_SRC_DIR}
	if [ ! -d "${MEDIA_SRC_DIR}/gmmlib" ]; then
        git clone https://github.com/intel/gmmlib gmmlib
    fi
    cd ${MEDIA_SRC_DIR}/gmmlib
   # git pull
#   git reset --hard 506c8e1bb50fa3f10c52ec01e545725df4f6af47
	mkdir -p build
	cd build
	cmake $SRC_DIR/gmmlib -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR
	make -j8
	make install
}

build_libva()
{
	echo "*********************************************libva*********************************************"
	cd ${MEDIA_SRC_DIR}
	if [ ! -d "${MEDIA_SRC_DIR}/libva" ]; then
      git clone https://github.com/intel/libva.git libva
   fi
    cd ${MEDIA_SRC_DIR}/libva
   # git reset --hard origin
   # git pull
   # git reset --hard b095d10bf355110352e75c22e581018a7ea7de5a
	./autogen.sh --prefix=$ROOT_INSTALL_DIR --enable-x11
	make -j8
	make install
}

build_libva_utils()
{
    echo "*********************************************libva-utils****************************************"
    cd ${MEDIA_SRC_DIR}
	if [ ! -d "${MEDIA_SRC_DIR}/libva-utils" ]; then
        git clone https://github.com/intel/libva-utils.git libva-utils
    fi
    cd ${MEDIA_SRC_DIR}/libva-utils
   # git reset --hard origin
   # git pull
    #git reset --hard 69703e30f8c8d6f457a7805792f1b3ecc3b4e5ea
    ./autogen.sh --prefix=$ROOT_INSTALL_DIR --enable-tests
    make -j8
    make install
}


build_media_driver()
{
	echo "*********************************************media-driver*******************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/media-driver" ]; then
        git clone https://github.com/intel/media-driver media-driver
        #git clone https://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@github.com/intel-innersource/drivers.gpu.media.staging.git -b intel-media-22.4 media-driver
    fi
    cd ${MEDIA_SRC_DIR}/media-driver
    #git clean -dfx
    #git reset --hard e94f762329028eec62e791e7f3a8c96246fee707
    #git reset --hard a4a2cedd656fd2c98075b3487711ed2a2f29d02f
#	git pull
 #   git reset --hard e94f762329028eec62e791e7f3a8c96246fee707
 	mkdir -p build
	cd build
	cmake ../ -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR -DENABLE_PRODUCTION_KMD=ON
	make -j8
	make install
}


build_msdk_dispatcher()
{
	echo "*****************************************msdk-dispatcher******************************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/MediaSDK" ]; then
        git clone https://github.com/Intel-Media-SDK/MediaSDK MediaSDK
    fi
    cd ${MEDIA_SRC_DIR}/MediaSDK
    #git pull
   # git reset --hard b0d1e2632dbd3e350f9837b8e1d6cab8f073d1ea
	mkdir -p build
	cd build
	cmake $SRC_DIR/MediaSDK -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR -DENABLE_OPENCL=off -DBUILD_RUNTIME=OFF -DBUILD_DISPATCHER=ON -DBUILD_SAMPLES=OFF

	make -j8
	make install
}

build_msdk_runtime()
{
	echo "*****************************************msdk-runtime******************************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/MediaSDK" ]; then
        git clone https://github.com/Intel-Media-SDK/MediaSDK MediaSDK
    fi
    cd ${MEDIA_SRC_DIR}/MediaSDK
   # git reset --hard 0db73aa1b2dec5b61900ee54db3fa574de6d1752
	#git pull
	mkdir -p build
	cd build
	cmake $SRC_DIR/MediaSDK -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR -DBUILD_RUNTIME=ON -DBUILD_DISPATCHER=OFF -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=off
	make -j8
	make install
}

build_vpl_dispatcher()
{
	echo "*****************************************vpl_dispatcher******************************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/vpl_dispatcher" ]; then
        git clone https://github.com/oneapi-src/oneVPL.git vpl_dispatcher
    fi
    cd ${MEDIA_SRC_DIR}/vpl_dispatcher
   # git pull
   # git reset --hard ed898448e82651f7d3445bad92488bc13181253e
	#git pull
	mkdir -p build
	cd build
	cmake .. -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR
    	make -j8
	make install
}

build_vpl_runtime()
{
	echo "*****************************************vpl_runtime******************************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/vpl" ]; then
        git clone https://github.com/oneapi-src/oneVPL-intel-gpu.git vpl
    fi
    cd ${MEDIA_SRC_DIR}/vpl
   # git pull
   # git reset --hard 227262653933c00d696b8645e3358d4fdd9ec234
	#git pull
	mkdir -p build
	cd build
	cmake .. -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR
	make -j8
	make install
}

build_gstreamer()
{
    echo "*********************************************gstreamer*************************************************"
    cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/gstreamer" ]; then
        git clone https://github.com/intel-media-ci/gstreamer.git gstreamer
    fi
    cd ${MEDIA_SRC_DIR}/gstreamer
    git clean -dxf
    git pull
    #git reset --hard 5c8bbde1d4
    meson --prefix=$ROOT_INSTALL_DIR ${MEDIA_SRC_DIR}/gstreamer/build --wrap-mode=nofallback -Dpython=disabled -Dlibav=disabled -Dlibnice=disabled -Ddevtools=disabled -Dges=disabled -Drtsp_server=disabled -Domx=disabled -Dsharp=disabled -Drs=disabled -Dgst-examples=disabled -Dtls=disabled -Dqt5=disabled -Dorc=enabled -Dbase=enabled -Dgood=enabled -Dbad=enabled -Dugly=enabled -Dvaapi=enabled -Dgst-plugins-bad:va=enabled -Dgst-plugins-bad:msdk=enabled -Dgst-plugins-bad:libde265=enabled -Dgst-plugins-bad:openh264=enabled -Dgst-plugins-bad:mfx_api=oneVPL
    ninja -C ${MEDIA_SRC_DIR}/gstreamer/build
    meson install -C ${MEDIA_SRC_DIR}/gstreamer/build
	#sudo ninja -C build install
}

build_gst_checksumsink()
{
    echo "*********************************************gst_checksumsink*************************************************"
    cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/gstreamer_checksunsink" ]; then
        git clone https://github.com/intel-media-ci/gst-checksumsink gst_checksumsink
    fi
    cd ${MEDIA_SRC_DIR}/gst_checksumsink
   # git reset --hard 74d201c56bddaf257b0f20a2d76b1c2f6e8b8a93
   git clean -dxf
    git pull
    ./autogen.sh --prefix=$ROOT_INSTALL_DIR
    make -j8 && sudo make install
}

build_ffmpeg()
{
    echo "*********************************************ffmpeg*************************************************"
    cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/ffmpeg" ]; then
        git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg
    fi
    cd ${MEDIA_SRC_DIR}/ffmpeg
    git pull
    ./configure --prefix=$ROOT_INSTALL_DIR --enable-shared --enable-vaapi --enable-libvpl --enable-gpl --enable-libx264 --enable-libx265
    make -j8
    make install
}

build_ffmpeg_cartwheel()
{
    echo "*********************************************ffmpeg-cartwheel*************************************************"
    cd ${MEDIA_SRC_DIR}
  #  if [ ! -d "${MEDIA_SRC_DIR}/ffmpeg_cartwheel" ]; then
   #     git clone https://github.com/intel-media-ci/cartwheel-ffmpeg --recursive cartwheel-ffmpeg
    #fi
    cd ${MEDIA_SRC_DIR}/cartwheel-ffmpeg
# git pull  
 # git reset --hard 497ff0d170d71694c60cb60cc87db69a7cdf7410
  cd ${MEDIA_SRC_DIR}/cartwheel-ffmpeg/ffmpeg
   # git checkout -b ffmpeg
# git pull
    # git config --global user.name "Intel VCMT Media CI"
    # git config --global user.email "sys_otcmedia@intel.com"
    # git am ../patches/*.patch
    ./configure --prefix=$ROOT_INSTALL_DIR --enable-nonfree --enable-shared --enable-libvpl --enable-gpl --enable-debug --extra-cflags=-g --extra-ldflags=-g --disable-optimizations --enable-debug=3 --disable-stripping --disable-x86asm --enable-libaom --libx264 --libx265 --enable-libx264 --enable-libx265
    make -j8
    make install
}

build_ffmpeg_cartwheel_embargo()
{
    echo "*********************************************ffmpeg*************************************************"
    cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/ffmpeg_cartwheel_embargo" ]; then
        git clone https://github.com/intel-innersource/libraries.media.middleware.cartwheel.ffmpeg.git --recursive ffmpeg_cartwheel_embargo
    fi
    cd ${MEDIA_SRC_DIR}/ffmpeg_cartwheel_embargo/ffmpeg
    git pull
    ./configure --prefix=$ROOT_INSTALL_DIR --enable-shared --enable-vaapi --enable-libmfx --enable-gpl --enable-libx264 --enable-libx265
    make -j8
    make install
}

build_gmmlib_inner()
{
	echo "*********************************************gmmlib-inner*******************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/media-driver-inner" ]; then
        git clone https://github.com/intel-innersource/drivers.gpu.unified.git  media-driver-inner
    fi
    cd ${MEDIA_SRC_DIR}/media-driver-inner
	git pull
	cd Source
	mkdir -p build
	cd build
	cmake .. -DBS_ENABLE_all=0 -DBS_ENABLE_gmmlib=1 -DBS_ENABLE_media=0 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR
	make -j8
	make install
}

build_media_driver_inner()
{
	echo "*********************************************media-driver-inner*******************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/media-driver-inner" ]; then
        git clone https://github.com/intel-innersource/drivers.gpu.unified.git  media-driver-inner
    fi
    cd ${MEDIA_SRC_DIR}/media-driver-inner
	git pull
	cd Source
	mkdir -p build
	cd build
	cmake .. -DBS_ENABLE_all=0 -DBS_ENABLE_gmmlib=0 -DBS_ENABLE_media=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR
	make -j8
	make install
}

build_vpl_dispatcher_inner()
{
	echo "*****************************************vpl_dispatcher_inner******************************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/vpl_dispatcher_inner" ]; then
        git clone https://github.com/intel-innersource/frameworks.media.onevpl.dispatcher.git vpl_dispatcher_inner
    fi
    cd ${MEDIA_SRC_DIR}/vpl_dispatcher_inner
	git pull
	mkdir -p build
	cd build
	cmake .. -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR
    cmake --build . --config Release --target install
}

build_vpl_inner()
{
	echo "*****************************************vpl_inner******************************************************"
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/vpl_inner" ]; then
        git clone https://github.com/intel-innersource/drivers.gpu.media.sdk.lib.git vpl_inner
    fi
    cd ${MEDIA_SRC_DIR}/vpl_inner
	git pull
	mkdir -p build
	cd build
	cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_ALL=ON -DENABLE_OPENCL=OFF -DMFX_DISABLE_SWFALLBACK=OFF -DBUILD_VAL_TOOLS=OFF -DBUILD_MOCK_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR ..
	make -j8
	sudo make install
}

build_vpl_inner_mfx_transcoder()
{
	echo "*****************************************vpl_inner_mfx_transcoder******************************************************"
	MEDIASDK_ROOT=/home/wenbin/software/media/src/vpl_inner
	cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/vpl_inner" ]; then
        git clone https://github.com/intel-innersource/drivers.gpu.media.sdk.lib.git vpl_inner
    fi
    cd ${MEDIA_SRC_DIR}/vpl_inner
    if [ ! -d "${MEDIA_SRC_DIR}/vpl_inner/IPP" ]; then
        scp -r wenbin@10.239.35.5:/home/wenbin/software/media/src/MediaSDK_inner/IPP ./
    fi
	git pull
	mkdir -p build
	cd build
	cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_ALL=ON -DENABLE_OPENCL=OFF -DMFX_DISABLE_SWFALLBACK=OFF -DBUILD_VAL_TOOLS=ON -DBUILD_MOCK_TESTS=OFF -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR ..
	make -j8
	sudo make install
}

build_vulkan_prerequest()
{
    sudo apt-get install -y llvm-11 wayland-protocols libwayland-egl-backend-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libxshmfence-dev libelf-dev
    sudo apt-get install -y bison byacc flex spirv-tools
    sudo ln -s /usr/bin/llvm-config-11 /usr/bin/llvm-config
}

build_vulkan_headers()
{
    echo "*********************************************vulkan_headers*******************************************"
	cd ${MESA_DIR}
    if [ ! -d "${MESA_DIR}/Vulkan-Headers" ]; then
        git clone https://github.com/KhronosGroup/Vulkan-Headers.git  Vulkan-Headers
    fi
    cd ${MESA_DIR}/Vulkan-Headers
	git pull
	mkdir -p build
	cd build
    cmake -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR ..
    make install
}

build_vulkan_loader()
{
    echo "*********************************************vulkan_loader*******************************************"
	cd ${MESA_DIR}
    if [ ! -d "${MESA_DIR}/Vulkan-Loader" ]; then
        git clone https://github.com/KhronosGroup/Vulkan-Loader.git  Vulkan-Loader
    fi
    cd ${MESA_DIR}/Vulkan-Loader
	git pull
	mkdir -p build
	cd build
    cmake -DVULKAN_HEADERS_INSTALL_DIR=$ROOT_INSTALL_DIR -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR ..
    make
	make install
}

build_glslang()
{
    echo "*********************************************glslang*******************************************"
	cd ${MESA_DIR}
    if [ ! -d "${MESA_DIR}/glslang" ]; then
        git clone https://github.com/KhronosGroup/glslang.git glslang
        cd glslang
        git clone https://github.com/google/googletest.git External/googletest
        cd External/googletest
        git checkout 0c400f67fcf305869c5fb113dd296eca266c9725
    fi
    cd ${MESA_DIR}/glslang
	git pull
	mkdir -p build
	cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ROOT_INSTALL_DIR ..
    make -j8
	make install
}

build_vulkan_inner()
{
    echo "*********************************************mesa_inner*******************************************"
	cd ${MESA_DIR}
    if [ ! -d "${MESA_DIR}/mesa_inner" ]; then
        git clone https://github.com/intel-innersource/drivers.gpu.mesa.ci-tags.git  mesa_inner
    fi
    cd ${MESA_DIR}/mesa_inner
    git fetch --tags
	git checkout mii-20210816
	mkdir -p build
	cd build
    meson .. -Dvulkan-drivers=intel -Dbuildtype=release
    sudo ninja install
}

build_openh264()
{
    echo "*********************************************openh264*************************************************"
    cd ${MEDIA_SRC_DIR}
    if [ ! -d "${MEDIA_SRC_DIR}/openh264" ]; then
        git clone https://github.com/cisco/openh264.git openh264
    fi
    cd ${MEDIA_SRC_DIR}/openh264
    mkdir -p build
     git pull
    meson --prefix=$ROOT_INSTALL_DIR ${MEDIA_SRC_DIR}/openh264/build
    ninja -C ${MEDIA_SRC_DIR}/openh264/build
    meson install -C ${MEDIA_SRC_DIR}/openh264/build
	#sudo ninja -C build install
}

##https://github.com/cisco/openh264
# git clone https://github.com/gstreamer/gst-plugins-base.git
# git clone https://github.com/gstreamer/gst-plugins-good.git
# git clone https://github.com/gstreamer/gstreamer-vaapi.git



set -ex

#build_dir
#build_media_prerequest
#build_libva
#build_libva_utils
#build_gmmlib
#build_media_driver
#build_msdk_dispatcher
#build_vpl_dispatcher
#build_vpl_runtime
#build_openh264
#build_gstreamer
#build_gst_checksumsink

build_ffmpeg
#build_ffmpeg_cartwheel




