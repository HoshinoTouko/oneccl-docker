FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel

RUN apt update
RUN apt install sudo

RUN sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN sudo apt update
RUN sudo apt install -y libssl-dev wget g++

RUN mkdir -p /setup/cmake
WORKDIR /setup/cmake

RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz
RUN tar xvf cmake-3.20.0.tar.gz

WORKDIR /setup/cmake/cmake-3.20.0
RUN ./bootstrap
RUN make
RUN make install 

# Setup one-ccl

RUN sudo apt install -y git gcc
RUN mkdir -p /setup/oneccl
WORKDIR /setup/oneccl
RUN git clone https://github.com/intel/torch-ccl.git
WORKDIR /setup/oneccl/torch-ccl
# RUN git checkout -b ccl_torch1.6 origin/ccl_torch1.6
RUN git checkout remotes/origin/ccl_torch1.6 -b ccl_torch1.6
RUN git submodule sync 
RUN git submodule update --init --recursive

RUN python3 setup.py install

CMD [ "bash" ]
