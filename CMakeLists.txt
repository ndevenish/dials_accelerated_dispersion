cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(dials_accelerated_dispersion)

# Find the modules for integrating into an existing dials distribution
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
# Convenience: Where the source files are found
set(SRC ${CMAKE_SOURCE_DIR}/src/dials_accelerated_dispersion)

find_package(Dials REQUIRED)
find_package(PythonExtensions REQUIRED)
find_package(ISPC REQUIRED)


add_custom_command(OUTPUT dispersion.o dispersion.h
                   COMMAND ${ISPC_EXECUTABLE} -g ${SRC}/dispersion.ispc -o dispersion.o -h dispersion.h
                   DEPENDS ${SRC}/dispersion.ispc)

add_library(dials_accelerated_dispersion_ext MODULE ${SRC}/ext.cxx dispersion.o)
python_extension_module(dials_accelerated_dispersion_ext)
target_link_libraries(dials_accelerated_dispersion_ext Boost::python)
install(TARGETS dials_accelerated_dispersion_ext LIBRARY DESTINATION src/dials_accelerated_dispersion)
