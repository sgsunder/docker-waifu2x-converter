FROM ubuntu:14.04

MAINTAINER Tomohisa Kusano <siomiz@gmail.com>

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	cmake \
	git-core \
	c++11 \
	build-essential

RUN git clone https://github.com/itseez/opencv.git /usr/local/src/opencv

WORKDIR /usr/local/src/opencv

RUN git checkout 3.0.0-rc1

RUN mkdir release

WORKDIR /usr/local/src/opencv/release

RUN cmake \
	-D CMAKE_BUILD_TYPE=Release \
	-D OPENCV_EXTRA_MODULES_PATH=modules \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
#	-D BUILD_SHARED_LIBS=OFF \
	-D BUILD_PACKAGE=OFF \
	-D BUILD_DOCS=OFF \
	-D BUILD_PERF_TESTS=OFF \
	-D BUILD_TESTS=OFF \
	-D BUILD_opencv_apps=OFF \
	..

RUN make && make install

WORKDIR /usr/local/src

RUN git clone https://github.com/WL-Amigo/waifu2x-converter-cpp

WORKDIR /usr/local/src/waifu2x-converter-cpp

RUN git checkout v1.1.1

RUN g++ -o /waifu2x -std=c++11 -I./include -I/usr/local/include src/main.cpp src/convertRoutine.cpp src/modelHandler.cpp -L/usr/local/lib -lopencv_core -lopencv_imgproc -lopencv_imgcodecs -lopencv_features2d

ENV LD_LIBRARY_PATH /usr/local/lib

WORKDIR /

ENTRYPOINT ["/waifu2x"]
