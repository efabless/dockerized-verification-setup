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

FROM ubuntu:20.04

ENV CC=/usr/bin/gcc
ENV CPP=/usr/bin/cpp
ENV CXX=/usr/bin/g++

ENV TOOLCHAIN_DOWNLOAD_DIR=/tmp/riscv-gnu-toolchain
ENV TOOLCHAIN_INSTALL_DIR=/opt/riscv32i

ARG DEBIAN_FRONTEND=noninteractive

COPY ./apt_requirements.txt /tmp

RUN apt-get update && \
    apt-get install -y $(grep -v "^#" /tmp/apt_requirements.txt | tr "\n" " ")

RUN git clone https://github.com/riscv/riscv-gnu-toolchain ${TOOLCHAIN_DOWNLOAD_DIR} && \
    cd ${TOOLCHAIN_DOWNLOAD_DIR} && \
    ./configure --prefix=${TOOLCHAIN_INSTALL_DIR} --with-arch=rv32i && \
    make -j $(nproc) && \
    cd / && \
    rm -rf ${TOOLCHAIN_DOWNLOAD_DIR}

ENV PATH=${TOOLCHAIN_INSTALL_DIR}/bin:${PATH}
ENV GCC_PATH=${TOOLCHAIN_INSTALL_DIR}/bin
ENV DV_ROOT=/dv_root
WORKDIR ${DV_ROOT}

CMD /bin/bash
