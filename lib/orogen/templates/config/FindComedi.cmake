# Locate COMEDI install directory

# This module defines
# COMEDI_INSTALL where to find include, lib, bin, etc.
# COMEDILIB_FOUND, is set to true

FIND_PACKAGE( OrocosPkgConfig REQUIRED )
INCLUDE (component_rules)

# GNU/Linux detection of Comedi lib uses pkgconfig or plain header search.
IF (OS_GNULINUX)
  SET(ENV{PKG_CONFIG_PATH} "${COMEDI_INSTALL}/lib/pkgconfig/:$ENV{PKG_CONFIG_PATH}")
  MESSAGE( "Looking for comedilib headers in ${COMEDI_INSTALL}/include ")
  OROCOS_PKGCONFIG( "comedilib >= 0.7.0" COMEDILIB_FOUND COMEDI_INCLUDE_DIRS COMEDI_DEFINES COMEDI_LINK_DIRS COMEDI_LIBS )

  IF ( NOT COMEDILIB_FOUND )
        MESSAGE("Looking for comedilib headers in ${COMEDI_INSTALL}/include")
	SET(COMEDILIB_FOUND COMEDILIB_FOUND-NOTFOUND)
	FIND_FILE("comedilib.h" COMEDILIB_FOUND ${COMEDI_INSTALL}/include)
	SET(COMEDI_INCLUDE_DIRS INTERNAL "-I ${COMEDI_INSTALL}/include")
	SET(COMEDI_LINK_DIRS INTERNAL "-I ${COMEDI_INSTALL}/lib")
	SET(COMEDI_LIBS INTERNAL "comedilib")
  ENDIF ( NOT COMEDILIB_FOUND )

  IF( COMEDILIB_FOUND )
        MESSAGE("   Comedi Lib found.")
        MESSAGE("   Includes in: ${COMEDI_INCLUDE_DIRS}")
        MESSAGE("   Libraries in: ${COMEDI_LINK_DIRS}")
        MESSAGE("   Libraries: ${COMEDI_LIBS}")
        MESSAGE("   Defines: ${COMEDI_DEFINES}")

        OROCOS_PKGCONFIG_LIBS("-L${COMEDI_INSTALL}/lib -lcomedi")
	INCLUDE_DIRECTORIES( ${COMEDI_INCLUDE_DIRS} )
	LINK_DIRECTORIES( ${COMEDI_LINK_DIRS} )
        LINK_LIBRARIES( ${COMEDI_LIBS} )
	SET(COMEDI_FOUND INTERNAL TRUE)
  ENDIF( COMEDILIB_FOUND )
ENDIF ( OS_GNULINUX )

# For LXRT, do a manual search.   
IF (OS_LXRT)
    # Try comedi/lxrt
    MESSAGE("Looking for comedi/LXRT headers in ${COMEDI_INSTALL}/include")
    SET(COMEDI_INCLUDE_DIR COMEDI_INCLUDE_DIR-NOTFOUND)
    FIND_PATH(COMEDI_INCLUDE_DIR linux/comedi.h "${COMEDI_INSTALL}/include")
    #FIND_LIBRARY(COMEDI_LIBRARY NAMES kcomedilxrt PATH "/usr/realtime/lib") 
    IF ( COMEDI_INCLUDE_DIR )
      # Add comedi header path and lxrt comedi lib 
      INCLUDE_DIRECTORIES( ${COMEDI_INSTALL}/include )
      LINK_LIBRARIES( kcomedilxrt )
      OROCOS_PKGCONFIG_LIBS("-L${COMEDI_INSTALL}/lib -lkcomedilxrt")
      MESSAGE("linux/comedi.h found.")
      SET(COMEDI_FOUND INTERNAL TRUE)
    ELSE(COMEDI_INCLUDE_DIR )
      MESSAGE("linux/comedi.h not found.")
    ENDIF ( COMEDI_INCLUDE_DIR )
    SET(COMEDI_INCLUDE_DIR INTERNAL)
ENDIF (OS_LXRT)
