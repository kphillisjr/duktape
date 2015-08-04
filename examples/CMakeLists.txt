add_executable(duk_example_adder hello/hello.c)
target_link_libraries(duk_example_adder duktape)


SET( DUK_CMDLINE_SRC
	"cmdline/duk_cmdline.c"
	"alloc-logging/duk_alloc_logging.c"
	"alloc-torture/duk_alloc_torture.c"
	"alloc-hybrid/duk_alloc_hybrid.c"
	"debug-trans-socket/duk_debug_trans_socket.c"
	)
SET( DUK_CMDLINE_HDRS
	"alloc-logging/duk_alloc_logging.h"
	"alloc-torture/duk_alloc_torture.h"
	"alloc-hybrid/duk_alloc_hybrid.h"
	"debug-trans-socket/duk_debug_trans_socket.h"
	)

if(MSVC)
	# Make MSVC warning C4996 go away.
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()


if(DUKTAPE_DEBUGGER_SUPPORT)
    # enable --debugger in ./duk
	add_definitions(-DDUK_CMDLINE_DEBUGGER_SUPPORT )
endif()
include_directories( "alloc-logging" "alloc-torture" "alloc-hyrid" "debug-trans-socket")
add_executable (duk.raw ${DUK_CMDLINE_SRC} ${DUK_CMDLINE_HDRS})	
target_link_libraries(duk.raw duktape)