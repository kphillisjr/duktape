#TODO: Run Python Script.
find_package(PythonInterp REQUIRED)



# Add code policy check custom target.
add_custom_target(autofix_whitespace
	${PYTHON_EXECUTABLE}
		"util/autofix_whitespace.py"
		"-d" "src" "-d" "tests" "--ext" ".c" "--ext"  ".h" "--ext" ".h.in"
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}		
	COMMENT "Verifying Code Policy")

	
# Add code policy check custom target.
add_custom_target(codepolicycheck
	${PYTHON_EXECUTABLE}
		"util/check_code_policy.py"
		"-d" "src" "-d" "tests" "--ext" ".c" "--ext"  ".h" "--ext" ".h.in"
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
	DEPENDS autofix_whitespace_issues
	COMMENT "Verifying Code Policy")

if(NOT WIN32)
	add_custom_target(codepolicycheckvim
		${PYTHON_EXECUTABLE}
			"util/check_code_policy.py"
			"--dump-vim-commands"
			"-d" "src" "-d" "tests" "--ext" ".c" "--ext"  ".h" "--ext" ".h.in"
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
		DEPENDS autofix_whitespace_issues
		COMMENT "Verifying Code Policy")
endif()
