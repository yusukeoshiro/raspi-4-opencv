FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive 
ENV OPENCV_DIR=/opt/opencv 
ENV LIBGPUARRAY_DIR=/opt/libgpuarray 
ENV NUM_CORES=8 
ENV NB_UID=1000 
ENV CLONE_TAG=1.0 
ENV OPENCV_VERSION=4.1.2 
ENV OPENCL_ENABLED=OFF 

# build and install opencv
RUN apt-get update && apt-get install -y --no-install-recommends \
     build-essential \
     ca-certificates \
     wget \
     libavcodec-dev libavformat-dev libavdevice-dev libv4l-dev libjpeg-dev  liblapack-dev \
     protobuf-compiler \
     cmake \
     g++ \
     unzip \
     python3 python3-pip python3-dev python3-protobuf python3-numpy \
     x265 libx265-dev libnuma-dev libx264-dev libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev \
     x264 ;\ 
    mkdir -p /src && \
    cd /src && \
    mkdir -p $OPENCV_DIR && \
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip && \
    unzip $OPENCV_VERSION.zip && \
    mv /src/opencv-$OPENCV_VERSION/ $OPENCV_DIR/ && \
    rm -rf /src/$OPENCV_VERSION.zip && \
    wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip -O $OPENCV_VERSION-contrib.zip && \
    unzip $OPENCV_VERSION-contrib.zip && \
    mv /src/opencv_contrib-$OPENCV_VERSION $OPENCV_DIR/ && \
    rm -rf /src/$OPENCV_VERSION-contrib.zip && \
    mkdir -p $OPENCV_DIR/opencv-$OPENCV_VERSION/build && \
    cd $OPENCV_DIR/opencv-$OPENCV_VERSION/build && \
    cmake \
    -D PYTHON_EXECUTABLE=$(which python3) \
    -D WITH_CUDA=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D BUILD_PYTHON_SUPPORT=ON \
    -D CMAKE_INSTALL_PREFIX=/usr \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D BUILD_PYTHON_SUPPORT=ON \
    -D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
    -D PYTHON_INCLUDE_DIR=/usr/include/python3.6m \
    -D OPENCV_EXTRA_MODULES_PATH=$OPENCV_DIR/opencv_contrib-$OPENCV_VERSION/modules \
    -D WITH_TBB=ON \
    -D WITH_PTHREADS_PF=ON \
    -D WITH_OPENNI=OFF \
    -D WITH_OPENNI2=ON \
    -D WITH_EIGEN=ON \
    -D BUILD_DOCS=ON \
    -D BUILD_TESTS=ON \
    -D BUILD_PERF_TESTS=ON \
    -D BUILD_EXAMPLES=ON \
    -D WITH_OPENCL=$OPENCL_ENABLED \
    -D USE_GStreamer=ON \
    -D WITH_GDAL=ON \
    -D WITH_CSTRIPES=ON \
    -D ENABLE_FAST_MATH=1 \
    -D WITH_OPENGL=ON \
    -D WITH_QT=OFF \
    -D WITH_IPP=ON \
    -D WITH_FFMPEG=ON \
    -D CMAKE_SHARED_LINKER_FLAGS=-Wl,-Bsymbolic \
    -D WITH_V4L=ON .. && \
    make -j $(nproc) && \
    make install && \
    ldconfig && \ 
    rm -rf $OPENCV_DIR;\
    apt-get autoclean -y ;\
    rm -rf /var/lib/apt/lists/*

