# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# syntax = docker/dockerfile:1.0-experimental
FROM ubuntu:20.04 AS build


ENV CC=/usr/bin/gcc \
    CPP=/usr/bin/cpp \
    CXX=/usr/bin/g++

RUN apt update

# General Utils
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN apt install -y automake autotools-dev bison cmake flex g++ gcc git libpcre3 libpcre3-dev tcl tcl-dev wget zlib1g zlib1g-dev

# Dependencies 
RUN apt-get install -y apt-utils autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
    gperf libtool patchutils bc zlib1g-dev git libexpat1-dev


# Iverilog
RUN apt-get install -y iverilog

# build
RUN mkdir /opt/riscv32i && \
    git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i && \
    cd riscv-gnu-toolchain-rv32i && \
    git checkout 411d134 && \
    git submodule update --init --recursive && \
    mkdir build; cd build && \
    ../configure --with-arch=rv32i --prefix=/opt/riscv32i && \
    make -j$(nproc)

ENV GCC_PATH=/opt/riscv32i/bin
ENV DV_ROOT=/dv_root

RUN apt install -y vim

WORKDIR $DV_ROOT

CMD /bin/bash
