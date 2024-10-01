cmake_minimum_required(VERSION 3.10)

# Project name and language
project(dump1090 C)

find_package(PkgConfig)

set(DUMP1090_FIRST_BUILD OFF CACHE BOOL "First build of dump1090")

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/install CACHE PATH "Install path" FORCE)

if(DUMP1090_FIRST_BUILD)
  message(STATUS "First build of dump1090")

  # build libusb for use in librtlsdr and install it
  message(STATUS "Building libusb")
  add_subdirectory(third_party/libusb-cmake)

  if(MSVC)
      message(STATUS "Building pthreads-win32 for MSVC")
      include(FetchContent)
      FetchContent_Declare(
        pthreads-win32
        GIT_REPOSITORY https://github.com/GerHobbelt/pthread-win32.git
        GIT_TAG master
      )
      FetchContent_MakeAvailable(pthreads-win32)
  	  
    endif()
else()

if(PKG_CONFIG_FOUND)
  message(STATUS "Not yet supported with pkg-config")
else()
  message(STATUS "Regular build of dump1090")

  # Set libusb directories manually
  set(LIBUSB_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/install/include/libusb-1.0)
  set(LIBUSB_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/install/lib/libusb-1.0.lib)
  message(STATUS "Setting libusb directories manually to ${LIBUSB_INCLUDE_DIRS} and ${LIBUSB_LIBRARIES}")

  message(STATUS "Building librtlsdr")
  include(ExternalProject)
  ExternalProject_Add(librtlsdr
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/librtlsdr
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      -DINSTALL_UDEV_RULES=$<IF:$<BOOL:${MSVC}>,OFF,ON>
      -DLIBUSB_INCLUDE_DIRS=${LIBUSB_INCLUDE_DIRS}
      -DLIBUSB_LIBRARIES=${LIBUSB_LIBRARIES}
      -DTHREADS_PTHREADS_INCLUDE_DIR=${CMAKE_BINARY_DIR}/install/include
      -DTHREADS_PTHREADS_LIBRARY=${CMAKE_BINARY_DIR}/install/lib/pthreadVSE3.lib
  )
endif() #pkg_config

if(MSVC)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /O2 /W3")
else()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -g -Wall -W")
endif()

# Add the executable
add_executable(dump1090
  dump1090.c 
  anet.c
  interactive.c
  mode_ac.c
  mode_s.c
  net_io.c
  )

target_include_directories(dump1090 PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/
  ${CMAKE_CURRENT_BINARY_DIR}/install/include
)

# Link libraries
if(MSVC)
  target_link_libraries(dump1090 ${CMAKE_BINARY_DIR}/install/lib/rtlsdr.lib pthreadVSE3 ws2_32)
else()
  target_link_libraries(dump1090 rtlsdr pthread m)
endif()

endif() #DUMP1090_FIRST_BUILD