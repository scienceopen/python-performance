add_executable(pisumc pisum.c)
if(NOT MSVC)
  target_link_libraries(pisumc m)
endif()
if (UNIX AND NOT APPLE)
  target_link_libraries(pisumc rt)
endif()
add_test(NAME pisumC COMMAND pisumc)
target_compile_features(pisumc PRIVATE c_std_99)

add_executable(pisumfort pisum.f90)
target_link_libraries(pisumfort perf)
add_test(NAME pisumFortran COMMAND pisumfort)
