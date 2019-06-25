ARG UBUNTU_VERSION=18.04

FROM ubuntu:${UBUNTU_VERSION} AS base
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        python3 \
        python3-pip \
        python3-dev \
        python3-crypto \
        libpq-dev \
        apt-utils \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        sudo \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


#Only to be used - Pull latest Tensorflow
# CACHE_STOP is used to rerun future commands, otherwise cloning tensorflow will be cached and will not pull the most recent version
#ARG CACHE_STOP=1
# Check out TensorFlow source code if --build-arg CHECKOUT_TF_SRC=1
#ARG CHECKOUT_TF_SRC=0
#RUN test "${CHECKOUT_TF_SRC}" -eq 1 && git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src || true

ARG USE_PYTHON_3_NOT_2
ARG _PY_SUFFIX=${USE_PYTHON_3_NOT_2:+3}
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

#RUN apt-get update && apt-get install -y \
#    ${PYTHON} \
#    ${PYTHON}-pip

RUN pip3 --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python 

RUN apt-get update && apt-get install -y \
    build-essential \
    python3-opencv \
    xauth \
    xorg \
    x11vnc \
    xvfb \
    curl \
    git \
    openssh-server \
    wget \
    libv4l-dev \
    libjpeg8-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavformat-dev \
    libpq-dev \
    openjdk-8-jdk \
    ${PYTHON}-dev \
    virtualenv \
    swig

RUN pip3 --no-cache-dir install \
    cmake \
    opencv-python \
    dlib \
    imutils \
    tensorflow==1.14.0 \
    Keras \
    tqdm \
    tables \
    Pillow \
    h5py \
    keras_applications \
    keras_preprocessing \
    matplotlib \
    mock \
    numpy==1.16.4 \
    scipy \
    sklearn \
    pandas \
    future \
    portpicker \
    && test "${USE_PYTHON_3_NOT_2}" -eq 1 && true || ${PIP} --no-cache-dir install \
    enum34

WORKDIR "/root"
#COPY age-and-gender-estimation / && cd age-and-gender-estimation
RUN GIT_SSL_NO_VERIFY=true git clone https://github.com/gokulpch/age-and-gender-estimation.git && \
               cd age-and-gender-estimation && \
               chmod +x prediction-model.py && \
               chmod +x exec.sh && \
               cd ..
ENTRYPOINT ["/root/age-and-gender-estimation/exec.sh"]
