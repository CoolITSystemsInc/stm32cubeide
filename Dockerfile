FROM ubuntu:18.04

# Install some basic tools:
RUN apt-get update
RUN apt-get -y install unzip wget libncurses5-dev python3 python3-pip
RUN pip3 install readline

# Install STM32CubeIDE:
COPY stm32cubeide /opt/stm32cubeide
