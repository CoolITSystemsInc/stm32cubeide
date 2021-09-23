FROM ubuntu:18.04

# Install some basic tools:
RUN apt-get update
RUN apt-get -y install unzip wget

# Install STM32CubeIDE:
COPY stm32cubeide /opt/stm32cubeide
