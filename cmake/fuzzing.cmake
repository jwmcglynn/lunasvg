# Macro to decorate fuzzer targets with necessary flags and sanitizer settings.
# This macro assumes that find_package(Sanitizers) has been called
# and that options like SANITIZE_ADDRESS are available.
macro(DECORATE_FUZZER TARGET_NAME)
  if(LUNASVG_BUILD_FUZZERS)
    add_sanitizers(${TARGET_NAME})

    # ASAN must also be enabled to build fuzzers.
    if(NOT SANITIZE_ADDRESS)
      message(FATAL_ERROR "Fuzzing requires SANITIZE_ADDRESS=ON to detect memory errors.")
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
      target_compile_options(${TARGET_NAME} PRIVATE -fsanitize=fuzzer)
      target_link_options(${TARGET_NAME} PRIVATE -fsanitize=fuzzer)
    else()
    message(FATAL_ERROR "Currently, fuzzing is only supported with Clang. "
                        "Detected compiler: ${CMAKE_CXX_COMPILER_ID} (${CMAKE_CXX_COMPILER})")
    endif()
  endif()
endmacro()

# Macro to add sanitizers to a target.
macro(DECORATE_TARGET TARGET_NAME)
  if (LUNASVG_BUILD_FUZZERS)
    add_sanitizers(${TARGET_NAME})
    target_compile_options(${TARGET_NAME} PRIVATE -fsanitize=fuzzer)
  endif()
endmacro()

if (LUNASVG_BUILD_FUZZERS)
  include(FetchContent)

  FetchContent_Declare(
    sanitizers_cmake
    GIT_REPOSITORY https://github.com/arsenm/sanitizers-cmake.git
    GIT_TAG        master)
  FetchContent_MakeAvailable(sanitizers_cmake)

  list(APPEND CMAKE_MODULE_PATH
    ${sanitizers_cmake_SOURCE_DIR}/cmake
  )

  find_package(Sanitizers REQUIRED)

  # If Sanitizers are found, SANITIZE_ADDRESS will be available.
  message(STATUS "Fuzzing enabled. SANITIZE_ADDRESS is ${SANITIZE_ADDRESS}")

endif()
