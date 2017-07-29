#!/bin/bash
set -e

echo "👉  Building Test Image"
TEST_TAG=$(echo "$TAG" | sed -e 's,/,\\\/,g')
sed -i -e "s/{IMAGE_TAG}/$TEST_TAG/g" TestSuite/Dockerfile
docker build TestSuite -t tests

echo "👉  Running Test Suite"
docker run tests

echo "👉  Verifying Dependency Graph"
DEPENDENCIES_VERSIONS=$(docker run tests bash -c 'ldd /usr/local/lib/swift/linux/libFoundation.so')
if [[ $DEPENDENCIES_VERSIONS == *"no version information available"* ]]; then
    echo "💥  No version information available for libcurl."
    exit 1
fi

echo "✅  All tests passed"