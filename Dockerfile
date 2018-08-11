FROM debian:stretch-slim
WORKDIR /opt/w2x

ARG OPENCV_VERSION=3.0.0
ARG W2XCONV_VERSION=v1.1.1

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -yqq \
		cmake \
		git-core \
		build-essential \
	# Build OpenCV
 && mkdir -p /usr/local/src/opencv \
 && cd /usr/local/src/opencv \
 && git clone https://github.com/itseez/opencv.git . \
 && git checkout ${OPENCV_VERSION} \
 && mkdir -p ./release && cd ./release \
 && cmake \
	 	-D CMAKE_BUILD_TYPE=Release \
	 	-D OPENCV_EXTRA_MODULES_PATH=modules \
	 	-D CMAKE_INSTALL_PREFIX=/usr/local \
	 	-D BUILD_PACKAGE=OFF \
	 	-D BUILD_DOCS=OFF \
	 	-D BUILD_PERF_TESTS=OFF \
	 	-D BUILD_TESTS=OFF \
	 	-D BUILD_opencv_apps=OFF \
	 	-D WITH_IPP=OFF \
	 	.. \
 && make \
 && make install \
 	# Build waifu2x-converter-cpp
 && mkdir -p /usr/local/src/waifu2x-converter-cpp \
 && cd /usr/local/src/waifu2x-converter-cpp \
 && git clone https://github.com/WL-Amigo/waifu2x-converter-cpp . \
 && git checkout ${W2XCONV_VERSION} \
 && cp -r models /opt/w2x \
 && g++ -o /opt/w2x/waifu2x-converter \
 		src/main.cpp src/convertRoutine.cpp src/modelHandler.cpp \
 		-std=c++11 \
 		-I./include -I/usr/local/include \
 		-L/usr/local/lib \
 		-lopencv_core -lopencv_imgproc -lopencv_imgcodecs -lopencv_features2d \
        -lpthread \
	# Cleanup
 && apt-get purge -yqq \
		cmake \
		git-core \
		build-essential \
 && apt-get autoremove --purge -y \
 && rm -rf /usr/local/src/* \
 	# Set Users
 && useradd --no-create-home --home-dir / app \
 && chown -R app /opt/w2x

# Final Touches
ENV LD_LIBRARY_PATH=/usr/local/lib
USER app
COPY entrypoint.sh /init
ENTRYPOINT ["/init"]
