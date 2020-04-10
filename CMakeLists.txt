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
target_include_directories(dials_accelerated_dispersion_ext PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
python_extension_module(dials_accelerated_dispersion_ext)
target_link_libraries(dials_accelerated_dispersion_ext Dials::Dials Boost::python)
install(TARGETS dials_accelerated_dispersion_ext LIBRARY DESTINATION src/dials_accelerated_dispersion)
