#!/bin/bash
echo "👉  Running Test Suite";
sed -i -e "s/{IMAGE_TAG}/$TEST_TAG/g" TestSuite/Dockerfile;
docker build -t "dsa-tests" TestSuite;
docker run "dsa-tests";

DYLIBS_VERSIONS=$(docker run 'dsa-tests' bash -c 'ldd /usr/lib/swift/linux/libFoundation.so');
if [[ $DYLIBS_VERSIONS == *"no version information available"* ]]; then
    echo "💥  No version information available for libcurl."
    exit 1;
fi

echo "✅  All tests passed."