# Sets up a libtbx-Dials distribution
#
# Attempts to find the DIALS/libtbx build folder through environment
# variables. 
#
# Once done this will define
#  DIALS_FOUND - System has Dials
#  DIALS_INCLUDE_DIRS - The Dials include directories
#  DIALS_LIBRARIES - The libraries needed to use Dials
#  DIALS_DEFINITIONS - Compiler switches required for using Dials
#
# And also sets up an imported Dials::Dials target, that allows basic
# usage of the dials infrastructure.

# Let'd find where the build dir is.

if (NOT DIALS_BUILD)
  if (NOT DEFINED ENV{LIBTBX_BUILD})
    message(SEND_ERROR "Could not find LIBTBX_BUILD environment variable. Cannot find Dials.")
  else()
    set(DIALS_BUILD $ENV{LIBTBX_BUILD} CACHE PATH "Dials build folder")
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Dials DEFAULT_MSG DIALS_BUILD)

if(DIALS_BUILD)
  if (NOT TARGET Dials::Dials)
    add_library(Dials::Dials IMPORTED INTERFACE)
  endif()

  set(DIALS_INCLUDE_DIRS "${DIALS_BUILD}/include;${DIALS_BUILD}/../modules;${DIALS_BUILD}/../modules/cctbx_project")



    # Validation - make sure we have boost stupid-tbx-style, otherwise we'd need
    # to load the boost dependency like any other package in the world, and that
    # might need special logic to work with whatever solution is eventually
    # implemented to do that
    if (NOT EXISTS ${DIALS_BUILD}/../modules/boost )
      message(WARNING "TBX/Boost method changed; probably need to rewrite find mechanisms")
    endif()

    if (NOT TARGET Boost::boost)
      # message(WARNING "Creating custom Boost targets TBX-style layout")
      add_library(Boost::boost IMPORTED INTERFACE)
      set_target_properties(Boost::boost PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${DIALS_BUILD}/../modules/boost"
      )

      # If this doesn't exist then we've got a very confused installation
      if (NOT EXISTS ${DIALS_BUILD}/lib/libboost_python${CMAKE_SHARED_LIBRARY_SUFFIX})
        message(SEND_ERROR "No boost target, but no libboost_python in TBX build")
        message(SEND_ERROR "No: ${DIALS_BUILD}/lib/libboost_python${CMAKE_SHARED_LIBRARY_SUFFIX}")
      endif()
      message(STATUS "Found TBX Boost: ${DIALS_BUILD}/modules/boost")
      add_library(Boost::python IMPORTED INTERFACE)
      set_target_properties(Boost::python PROPERTIES
        INTERFACE_LINK_LIBRARIES      "Boost::boost;${DIALS_BUILD}/lib/libboost_python${CMAKE_SHARED_LIBRARY_SUFFIX}"
      )
  endif()
  # Add boost via TBX to this while tbx still _builds it itself_ in a way that is
  # incompatible with normal ways of finding boost

  mark_as_advanced(DIALS_INCLUDE_DIRS)

  set_target_properties(Dials::Dials PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${DIALS_INCLUDE_DIRS}"
    # INTERFACE_COMPILE_DEFINITIONS "${HDF5_DEFINITIONS_CLEAN}"
    INTERFACE_LINK_LIBRARIES      "Boost::boost"
    )

    # if ((EXISTS ${DIALS_BUILD}/../conda_base) AND NOT BOOST_ROOT AND NOT Boost_FOUND)
    #   message("Conda_base folder exists, no boost specified")
    #   get_filename_component(BOOST_ROOT "${DIALS_BUILD}/../conda_base" ABSOLUTE)
    # endif()
endif()