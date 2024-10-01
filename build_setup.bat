@echo off

set CMAKE_GENERATOR=Visual Studio 17 2022
set ARG1=DUMP1090_FIRST_BUILD=ON

echo Setting up build environment...

echo Generating build files with CMake...
cmake -G "%CMAKE_GENERATOR%" -S . -B build/ -D%ARG1%

echo Installing LibUSB...
cmake --build build/third_party/libusb-cmake/ --config Debug
cmake --build build/third_party/libusb-cmake/ --config Release
cmake --install build/third_party/libusb-cmake/ --config Release

echo Build and install pthreads-win32...
cmake --build build/_deps/pthreads-win32-build/ --config Debug
cmake --build build/_deps/pthreads-win32-build/ --config Release
cmake --install build/_deps/pthreads-win32-build/ --config Release


echo Starting regular build...
cmake -S . -B build/ -DDUMP1090_FIRST_BUILD=OFF
cmake --build build/ --config Debug
cmake --build build/ --config Release
