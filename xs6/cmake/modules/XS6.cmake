#
#      Copyright (C) 2010-2015 Marvell International Ltd.
#      Copyright (C) 2002-2010 Kinoma, Inc.
# 
#      Licensed under the Apache License, Version 2.0 (the "License");
#      you may not use this file except in compliance with the License.
#      You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#      Unless required by applicable law or agreed to in writing, software
#      distributed under the License is distributed on an "AS IS" BASIS,
#      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#      See the License for the specific language governing permissions and
#      limitations under the License.
#
INCLUDE(CMakeParseArguments)
INCLUDE(Kinoma)

MACRO(XS2JS)
	SET(oneValueArgs SOURCE DESTINATION)
	SET(multiValueArgs OPTIONS)
	CMAKE_PARSE_ARGUMENTS(LOCAL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	GET_FILENAME_COMPONENT(NAME ${LOCAL_SOURCE} NAME_WE)
	SET(OUTPUT ${LOCAL_DESTINATION}/${NAME}.js)
	IF(XS_BUILD)
		SET(DEPENDS xsr)
	ENDIF()

	ADD_CUSTOM_COMMAND(
		OUTPUT ${OUTPUT}
		COMMAND ${XS2JS} ${LOCAL_SOURCE} ${LOCAL_OPTIONS} -p -o ${LOCAL_DESTINATION}
		DEPENDS ${LOCAL_SOURCE} ${DEPENDS}
		)
ENDMACRO()

# Run XSC against a JS file
#
# SOURCE_FILE: The location of the .js file
# DESTINATION: The temp directory to put these files under
# XSC_OPTIONS: options to pass to xsc other than -o
# The following two options are used for xs6 tools and not needed for kprconfig
# SOURCE_DIR: Directory to search for source files
# SOURCE: Path under SOURCE_DIR to find the file without the .js
MACRO(XSC)
	SET(oneValueArgs SOURCE_DIR SOURCE SOURCE_FILE DESTINATION)
	SET(multiValueArgs OPTIONS)
	CMAKE_PARSE_ARGUMENTS(LOCAL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	IF(LOCAL_SOURCE_FILE)
		GET_FILENAME_COMPONENT(NAME ${LOCAL_SOURCE_FILE} NAME_WE)
		SET(SOURCE_FILE ${LOCAL_SOURCE_FILE})
		SET(OUTDIR ${LOCAL_DESTINATION})
	ELSE()
		GET_FILENAME_COMPONENT(NAME ${LOCAL_SOURCE} NAME_WE)
		GET_FILENAME_COMPONENT(BASE ${LOCAL_SOURCE} DIRECTORY)
		SET(SOURCE_FILE ${LOCAL_SOURCE_DIR}/${LOCAL_SOURCE}.js)
		SET(OUTDIR ${LOCAL_DESTINATION}/${BASE})
	ENDIF()
	SET(OUTPUT ${OUTDIR}/${NAME}.xsb)
	IF(XS_BUILD)
		SET(DEPENDS xsc)
	ENDIF()
	ADD_CUSTOM_COMMAND(
		OUTPUT ${OUTPUT}
		COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTDIR}
		COMMAND ${XSC} ${LOCAL_OPTIONS} ${SOURCE_FILE} -o ${OUTDIR}
		DEPENDS ${SOURCE_FILE} ${DEPENDS}
		)
ENDMACRO()

# Use XSL to create an XSA file from XSB files
#
# NAME: The name to send to -a
# TMP: Location of .xsb files
# DESTINATION: The bin directory for the xsa
# SOURCES: A list of xsb files
# SRC_DIR: Move generated source files into another directory
MACRO(XSL)
	SET(oneValueArgs NAME TMP DESTINATION SRC_DIR)
	SET(multiValueArgs SOURCES XSC_OPTIONS)
	CMAKE_PARSE_ARGUMENTS(LOCAL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	SET(OUTPUT ${LOCAL_DESTINATION}/${LOCAL_NAME}.xsa)
	IF(XS_BUILD)
		SET(DEPENDS xsl)
	ENDIF()
	ADD_CUSTOM_COMMAND(
		OUTPUT ${OUTPUT} ${LOCAL_TMP}/${LOCAL_NAME}.xs.c ${LOCAL_TMP}/${LOCAL_NAME}.xs.h
		COMMAND ${CMAKE_COMMAND} -E make_directory ${LOCAL_DESTINATION}
		COMMAND ${XSL} -a ${LOCAL_NAME} -b ${LOCAL_TMP} -o ${LOCAL_DESTINATION} ${LOCAL_SOURCES}
		DEPENDS ${LOCAL_SOURCES} ${DEPENDS}
		)
	ADD_CUSTOM_TARGET(
		${LOCAL_NAME}.xsa
		DEPENDS ${OUTPUT}
		)
	IF(LOCAL_SRC_DIR)
		ADD_CUSTOM_COMMAND(
			TARGET ${LOCAL_NAME}.xsa
			POST_BUILD
			COMMAND ${CMAKE_COMMAND} -E make_directory ${LOCAL_SRC_DIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LOCAL_TMP}/${LOCAL_NAME}.xs.c ${LOCAL_SRC_DIR}/${LOCAL_NAME}.xs.c
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LOCAL_TMP}/${LOCAL_NAME}.xs.h ${LOCAL_SRC_DIR}/${LOCAL_NAME}.xs.h
			COMMAND ${CMAKE_COMMAND} -E remove  ${LOCAL_TMP}/${LOCAL_NAME}.xs.c ${LOCAL_TMP}/${LOCAL_NAME}.xs.h
			)
	ENDIF()
ENDMACRO()

MACRO(KPR2JS)
	SET(oneValueArgs SOURCE DESTINATION)
	CMAKE_PARSE_ARGUMENTS(LOCAL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	GET_FILENAME_COMPONENT(NAME ${LOCAL_SOURCE} NAME_WE)
	SET(OUTPUT ${LOCAL_DESTINATION}/${NAME}.js)
	IF(XS_BUILD)
		SET(DEPENDS xsr tools)
	ENDIF()
	ADD_CUSTOM_COMMAND(
		OUTPUT ${OUTPUT}
		COMMAND ${CMAKE_COMMAND} -E make_directory ${LOCAL_DESTINATION}
		COMMAND ${KPR2JS} ${LOCAL_SOURCE} -o ${LOCAL_DESTINATION}
		DEPENDS ${LOCAL_SOURCE} ${DEPENDS}
		)
endmacro()