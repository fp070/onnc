function(enum_onnc_targets)
    macro(add_target name default_value)
        string(TOUPPER ${name} op_name)
        list(APPEND TARGET_LIST ${op_name})
        set(TARGET_${op_name}_NAME ${name})
        if (TARGET_ALL)
            set(TARGET_${op_name} ON               CACHE BOOL "Build ${name}" FORCE)
        else()
            set(TARGET_${op_name} ${default_value} CACHE BOOL "Build ${name}")
        endif()
    endmacro()
    # register target
    set(TARGET_LIST "")
    option(TARGET_ALL "Build all targets" ON)
    add_target(X86 ON)
    add_target(Sophon OFF)

    # evaluate macro for Platforms.def and Backends.def
    set(ONNC_TARGET_PLATFORMS "")
    set(ONNC_TARGET_BACKENDS "")
    foreach(op_name ${TARGET_LIST})
        set(name ${TARGET_${op_name}_NAME})
        if (TARGET_${op_name})
            set(ONNC_TARGET_PLATFORMS "${ONNC_TARGET_PLATFORMS} ONNC_PLATFORM(${name})")
            set(ONNC_TARGET_BACKENDS "${ONNC_TARGET_BACKENDS} ONNC_BACKEND(${name})")
        endif()
    endforeach()
    set(ONNC_TARGET_PLATFORMS "${ONNC_TARGET_PLATFORMS}" PARENT_SCOPE)
    set(ONNC_TARGET_BACKENDS "${ONNC_TARGET_BACKENDS}" PARENT_SCOPE)

    # evaluate macro for Config.h
    foreach(op_name ${TARGET_LIST})
        set(ENABLE_${op_name}_TARGET ${TARGET_${op_name}} PARENT_SCOPE)
    endforeach()

    # target list
    set(ONNC_TARGETS_TO_BUILD "")
    foreach(op_name ${TARGET_LIST})
        if (TARGET_${op_name})
            list(APPEND ONNC_TARGETS_TO_BUILD ${op_name})
        endif()
    endforeach()
    set(ONNC_TARGETS_TO_BUILD "${ONNC_TARGETS_TO_BUILD}" PARENT_SCOPE)
endfunction()
