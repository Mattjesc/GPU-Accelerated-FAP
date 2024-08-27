cmake_minimum_required(VERSION 3.14)
project(FFTVisualization LANGUAGES CXX CUDA)

# Find CUDA
find_package(CUDA REQUIRED)

# Create a library for FFT functionality
add_library(fft_visualization_lib fft_visualization.cu fft_visualization.h)
target_link_libraries(fft_visualization_lib ${CUDA_cufft_LIBRARY})

# Add your main project
add_executable(fft_visualization main.cu)
target_link_libraries(fft_visualization fft_visualization_lib)
set_property(TARGET fft_visualization PROPERTY CUDA_SOURCE_PROPERTY_FORMAT OBJ)

# FetchContent to download Google Test
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# Add test executable
add_executable(fft_visualization_test test/fft_visualization_test.cpp)
target_link_libraries(fft_visualization_test gtest_main fft_visualization_lib)

# Add CUDA to the test executable
target_include_directories(fft_visualization_test PRIVATE ${CUDA_INCLUDE_DIRS})
target_link_libraries(fft_visualization_test ${CUDA_LIBRARIES})

# Add test to CTest
enable_testing()
add_test(NAME fft_visualization_test COMMAND fft_visualization_test)