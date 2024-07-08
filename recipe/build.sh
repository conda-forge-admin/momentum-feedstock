#!/bin/bash

set -euxo pipefail

if [[ "${target_platform}" == osx-* ]]; then
  # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
  CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake $SRC_DIR \
  ${CMAKE_ARGS} \
  -G Ninja \
  -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DMOMENTUM_USE_SYSTEM_RERUN_CPP_SDK=ON \
  -DMOMENTUM_BUILD_TESTING=ON \
  -DMOMENTUM_BUILD_EXAMPLES=OFF \
  -DMOMENTUM_BUILD_PYMOMENTUM=OFF \
  -DMOMENTUM_BUILD_WITH_EZC3D=OFF

cmake --build build --parallel

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  ctest --test-dir build --output-on-failure
fi

cmake --build build --parallel --target install
