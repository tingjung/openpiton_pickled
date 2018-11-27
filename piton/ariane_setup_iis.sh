#!/bin/bash
# Copyright 2018 ETH Zurich and University of Bologna.
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# Author: Michael Schaffner <schaffner@iis.ee.ethz.ch>, ETH Zurich
# Date: 26.11.2018
# Description: This script sets up some environment variables for the
# OpenPiton+Ariane simulation and build flow. Important: use a bash shell
# for this, and source it while being in the root folder of OpenPiton.
#
# Make sure you have the following packages installed:
#
# sudo apt install \
#          gcc-7 \
#          g++-7 \
#          gperf \
#          autoconf \
#          automake \
#          autotools-dev \
#          libmpc-dev \
#          libmpfr-dev \
#          libgmp-dev \
#          gawk \
#          build-essential \
#          bison \
#          flex \
#          texinfo \
#          python-pexpect \
#          libusb-1.0-0-dev \
#          default-jdk \
#          zlib1g-dev \
#          valgrind

echo
echo "----------------------------------------------------------------------"
echo "openpiton/ariane path setup"
echo "----------------------------------------------------------------------"
echo

echo "make sure that you source this script in a bash shell in the root folder of OpenPiton"

if [ "$0" !=  "bash" ] && [ "$0" != "-bash" ]
then
  echo "not in bash ($0), aborting"
  return

fi

SCRIPTNAME=ariane_setup.sh

TEST=`pwd`/piton/
if [[ $(readlink -e "${TEST}/${SCRIPTNAME}") == "" ]]
then
  echo "aborting"
  return
fi

################################
# PITON setup
################################

# set root directory
export PITON_ROOT=`pwd`

## Vivado
export VIVADO_BIN="vivado-2018.1 vivado"

## VCS
VCS_VER="vcs-2017.03-kgf"

# wrap this such that it uses the SEPP package
# (license setup is then done by the SEPP startup script)
eval "function vcs() { command $VCS_VER vcs -full64 \"\$@\"; };"
export -f vcs

export VCS_HOME="/usr/pack/${VCS_VER}/"

## Modelsim
export MODELSIM_VERSION="-10.6b -64"
export MODELSIM_HOME="/usr/pack/modelsim-10.6b-kgf/"

## GCC and RISCV GCC setup
export CXX=g++-7.2.0 CC=gcc-7.2.0
export RISCV=/usr/scratch2/dolent1/gitlabci/riscv_install

# setup paths
export PATH=$PATH:${RISCV}/bin
export LIBRARY_PATH=$RISCV/lib
export LD_LIBRARY_PATH=$RISCV/lib:/usr/pack/gcc-7.2.0-af/linux-x64/lib64/
export C_INCLUDE_PATH=$RISCV/include:/usr/pack/gcc-7.2.0-af/linux-x64/include
export CPLUS_INCLUDE_PATH=$RISCV/include:/usr/pack/gcc-7.2.0-af/linux-x64/include
export ARIANE_ROOT=${PITON_ROOT}/piton/design/chip/tile/ariane/

# source OpenPiton setup script
# note: customize this script to reflect your tool setup
source ./piton/piton_settings.bash

if [[ $(readlink -e "${RISCV}/bin/spike") == "" ]]
then
    echo
    echo "----------------------------------------------------------------------"
    echo "setup complete. do not forget to run the ariane_build_tools.sh script"
    echo "if you run this for the first time."
    echo "----------------------------------------------------------------------"
    echo
else
    echo
    echo "----------------------------------------------------------------------"
    echo "setup complete."
    echo "----------------------------------------------------------------------"
    echo
fi