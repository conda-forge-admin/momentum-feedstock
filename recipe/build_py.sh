#!/bin/bash

set -euxo pipefail

# Set CMake options for pymomentum
export MOMENTUM_ENABLE_SIMD=OFF

# Install the current package with verbose output
python -m pip install . -vv

# Get the Python site-specific directory path for platform-dependent files
PYTHON_SITEARCH=$(python3 -c "import sysconfig; print(sysconfig.get_path('platlib'))")

# Remove the CONDA_PREFIX part from PYTHON_SITEARCH to get the relative path
RELATIVE_PATH=${PYTHON_SITEARCH#"$CONDA_PREFIX"}
RELATIVE_PATH=${RELATIVE_PATH#/}

# Construct the new path using PREFIX
MERGED_PATH="$PREFIX/$RELATIVE_PATH"

# For debugging
echo "PREFIX         = $PREFIX"
echo "CONDA_PREFIX   = $CONDA_PREFIX"
echo "PYTHON_SITEARCH= $PYTHON_SITEARCH"
echo "RELATIVE_PATH  = $RELATIVE_PATH"
echo "MERGED_PATH    = $MERGED_PATH"

# Copy all .so files to the target directory except those containing 'test' in the filename
mkdir -p "$MERGED_PATH/pymomentum"
find pymomentum -name "*.so" ! -name "*test*" -exec cp {} "$MERGED_PATH/pymomentum" \;
ls "$MERGED_PATH/pymomentum"
