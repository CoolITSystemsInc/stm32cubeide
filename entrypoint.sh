#!/bin/sh -l

time=$(date)
echo "Starting build on $time"

pwd
ls -al

/opt/stm32cubeide/stm32cubeide -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import Boards/MFS_F410CBU_A/ -build all
