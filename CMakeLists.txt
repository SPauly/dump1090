cmake_minimum_required(VERSION 3.10)

# Project name and language
project(dump1090 C)

# Include FetchContent module
include(FetchContent)

FetchContent_Declare(
  libusb
  GIT_REPOSITORY https://github.com/libusb/libusb.git 
  GIT_TAG v1.0.27
)

# Fetch librtlsdr
FetchContent_Declare(
  librtlsdr
  GIT_REPOSITORY https://github.com/steve-m/librtlsdr.git
  GIT_TAG master
)

# Make librtlsdr available
FetchContent_MakeAvailable(libusb)
FetchContent_MakeAvailable(librtlsdr)

# Add include directories
include_directories(${librtlsdr_SOURCE_DIR}/include)

# Set compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -g -Wall -W")

# Add the executable
add_executable(dump1090 dump1090.c anet.c)

# Link libraries
target_link_libraries(dump1090 rtlsdr pthread m)