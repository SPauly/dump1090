@echo off

set CMAKE_GENERATOR=Visual Studio 17 2022
set ARG1=DUMP1090_FIRST_BUILD=ON

echo Setting up build environment...

echo Generating build files with CMake...
cmake -G "%CMAKE_GENERATOR%" .

echo Initiating setup build with: %ARG1%...
cmake -S . -B build/
cmake --build . --config Debug -D%ARG1%
cmake --build . --config Release -D%ARG1%

echo Installing LibUSB...
cmake --install build/third_party/libusb/ --config Release

