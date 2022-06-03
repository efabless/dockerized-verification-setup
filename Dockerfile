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
FROM ubuntu:20.04 AS base

RUN apt update

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN apt-get install -y apt-utils autoconf automake autotools-dev curl libmpc-dev \
    libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
    gperf libtool patchutils bc zlib1g-dev git libexpat1-dev libpcre3-dev tcl-dev \
    neovim

ENV CC=/usr/bin/gcc \
    CPP=/usr/bin/cpp \
    CXX=/usr/bin/g++

# ---
FROM base AS rv-builder

# Get RISCV
RUN mkdir /opt/riscv32i && \
    git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i && \
    cd riscv-gnu-toolchain-rv32i && \
    git checkout 411d134 && \
    git submodule update --init --recursive --depth=1 && \
    mkdir build && \
    cd build && \
    ../configure --with-arch=rv32i --prefix=/opt/riscv32i && \
    make -j$(nproc)


# ---
FROM base

# Get IcarusVerilog

# WORKDIR /iverilog
# RUN curl -L https://github.com/steveicarus/iverilog/archive/refs/tags/v10_3.tar.gz | tar --strip-components=1 -xzC /iverilog &&\
#     sh autoconf.sh &&\
#     ./configure &&\
#     make -j$(nproc) &&\
#     make install &&\
#     rm -rf *

RUN apt-get install -y iverilog

# Get ARM Cross-Compiler
RUN apt-get install -y gcc-arm-none-eabi

# Get RISC-V Cross-Compiler
COPY --from=rv-builder /opt/riscv32i/bin /opt/riscv32i/bin

ENV GCC_PATH=/opt/riscv32i/bin
ENV DV_ROOT=/dv_root
WORKDIR $DV_ROOT
CMD /bin/bash