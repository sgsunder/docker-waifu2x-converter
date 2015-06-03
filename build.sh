#!/bin/bash
set -e

# dependencies
apt-get update

DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	cmake \
	git-core \
	build-essential

# build OpenCV
git clone https://github.com/itseez/opencv.git /usr/local/src/opencv

cd /usr/local/src/opencv

git checkout ${OPENCV_VERSION}

mkdir release

cd /usr/local/src/opencv/release

# TODO: -D BUILD_SHARED_LIBS=OFF
cmake \
	-D CMAKE_BUILD_TYPE=Release \
	-D OPENCV_EXTRA_MODULES_PATH=modules \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D BUILD_PACKAGE=OFF \
	-D BUILD_DOCS=OFF \
	-D BUILD_PERF_TESTS=OFF \
	-D BUILD_TESTS=OFF \
	-D BUILD_opencv_apps=OFF \
	-D WITH_IPP=OFF \
	..

make && make install

# build waifu2x-converter-cpp
git clone https://github.com/WL-Amigo/waifu2x-converter-cpp \
	/usr/local/src/waifu2x-converter-cpp

cd /usr/local/src/waifu2x-converter-cpp

git checkout ${W2XCONV_VERSION}

cp -r models /opt/w2x

# TODO: statically link libs
g++ -o /opt/w2x/waifu2x-converter \
	src/main.cpp src/convertRoutine.cpp src/modelHandler.cpp \
	-std=c++11 \
	-I./include -I/usr/local/include \
	-L/usr/local/lib \
	-lopencv_core -lopencv_imgproc -lopencv_imgcodecs -lopencv_features2d

# clean up
cd /

DEBIAN_FRONTEND=noninteractive \
	apt-get purge -y \
	cmake \
	git-core \
	build-essential

DEBIAN_FRONTEND=noninteractive \
	apt-get autoremove --purge -y

rm -rf /usr/local/src/*

export LD_LIBRARY_PATH=/usr/local/lib

exit 0
