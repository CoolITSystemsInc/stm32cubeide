FROM ubuntu:18.04

# Install some basic tools:
RUN apt-get update
RUN apt-get -y install unzip wget libncurses5-dev python3 python3-pip git
RUN pip3 install readline

# Install STM32CubeIDE:
COPY stm32cubeide/ /opt/stm32cubeide/

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

