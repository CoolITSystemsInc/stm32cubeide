#!/bin/sh -l

time=$(date)
echo "Starting build on $time"

/opt/stm32cubeide/stm32cubeide -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import $1 -build all
