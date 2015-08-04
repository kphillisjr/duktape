
# NOTE: This version does not properly handle Unicode chars.
cmake_minimum_required(VERSION 2.8)
 
project (duktape)
set(DUKTAPE_MAJOR_VERSION 1)
set(DUKTAPE_MINOR_VERSION 2)
set(DUKTAPE_PATCH_VERSION 0)
MATH( EXPR DUKTAPE_COMPACT_VERSION "
		10000 * ${DUKTAPE_MAJOR_VERSION} +
		100 * ${DUKTAPE_MINOR_VERSION}   +
		${DUKTAPE_PATCH_VERSION}"
		)

		# Convert the DukTape Version to Follow Semantics
option(DUKTAPE_BUILD_EXAMPLES "Build Example Code" ON)
option(DUKTAPE_BUILD_SHARED "Build duktape as a Shared library" OFF)
option(DUKTAPE_DEBUGGER_SUPPORT "Build duktape with Debugger Support." ON)
option(DUKTAPE_DEBUGGER_JQUERY  "Build duktape with Debugger Support." ON)
option(DUKTAPE_ENABLE_CODE_POLICY_CHECK "Add Code Policy Target to Build" ON)

if(EXISTS "${PROJECT_SOURCE_DIR}/.git")
	include(CMake-build-git.cmake)
else()
	if(EXISTS ${PROJECT_SOURCE_DIR}/src-separate)
		option(DUKTAPE_BUILD_SEPARABLE "Build Duktape using Split Files" OFF)
	endif()
endif()

include_directories(${PROJECT_SOURCE_DIR}/src )
include_directories(${PROJECT_BINARY_DIR}/src )
if(EXISTS ${PROJECT_SOURCE_DIR}/src-separate AND DUKTAPE_BUILD_SEPARABLE)
	# Create The Core Include file.
	file(GLOB DUKTAPE_LIB_C_SRC "src-separate/*.c")
elseif(EXISTS "${PROJECT_SOURCE_DIR}/.git")
	file(GLOB DUKTAPE_LIB_C_SRC "src/*.c")
else()
	file(GLOB DUKTAPE_LIB_C_SRC "src/duktape.c")
endif()

if(DUKTAPE_DEBUGGER_SUPPORT)
	# These Options are used for Basic Debugging support.
	add_definitions(
		-DDUK_OPT_DEBUGGER_SUPPORT         # enable debugger support in Duktape
		-DDUK_OPT_INTERRUPT_COUNTER        # prerequisite for debugging
		-DDUK_OPT_DEBUGGER_FWD_PRINTALERT  # optional debugger features
		-DDUK_OPT_DEBUGGER_FWD_LOGGING     # Debug Logging Printouts
		-DDUK_OPT_DEBUGGER_DUMPHEAP
	)
endif()
if(DUKTAPE_DEBUGGER_JQUERY)
	#TODO: Add debugger path
	include(CMake-build-debugger.cmake)
endif()

if(DUKTAPE_ENABLE_CODE_POLICY_CHECK)
	include(CMake-check-code-policy.cmake)
endif()

# Create The Core Include file.
include_directories(${PROJECT_SOURCE_DIR}/src )
include_directories(${PROJECT_BINARY_DIR}/src )
if(DUKTAPE_BUILD_SHARED)
	add_library(duktape SHARED ${DUKTAPE_LIB_C_SRC})
else()
	add_library(duktape STATIC ${DUKTAPE_LIB_C_SRC})
endif()


if(DUKTAPE_BUILD_EXAMPLES)
	add_subdirectory(examples)
endif()
if(DUKTAPE_DEBUGGER_SUPPORT AND DUKTAPE_DEBUGGER_JQUERY)
	add_subdirectory(debugger)
endif()
