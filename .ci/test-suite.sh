#!/bin/bash
sed -i -e "s/{IMAGE_TAG}/$TEST_TAG/g" TestSuite/Dockerfile
docker build -t "dsa-tests" TestSuite
docker run "dsa-tests"