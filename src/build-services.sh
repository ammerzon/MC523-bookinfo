#!/bin/bash
#
# Copyright 2017 Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# NOTICE: Adapted from https://github.com/istio/istio/blob/master/samples/bookinfo/src/build-services.sh

set -o errexit

if [ "$#" -ne 2 ]; then
    echo "Incorrect parameters"
    echo "Usage: build-services.sh <version> <prefix>"
    exit 1
fi

VERSION=$1
PREFIX=$2
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

pushd "$SCRIPTDIR/productpage"
  docker build --pull -t "${PREFIX}/bookinfo-productpage-v1:${VERSION}" -t "${PREFIX}/bookinfo-productpage-v1:latest" .
popd

pushd "$SCRIPTDIR/details"
  docker build --pull -t "${PREFIX}/bookinfo-details-v1:${VERSION}" -t "${PREFIX}/bookinfo-details-v1:latest" --build-arg service_version=v1 .
popd

pushd "$SCRIPTDIR/reviews"
  #java build the app.
  docker run --rm -u root -v "$(pwd)":/home/gradle/project -w /home/gradle/project gradle:4.8.1 gradle clean build
  pushd reviews-wlpcfg
    #plain build -- no ratings
    docker build --pull -t "${PREFIX}/bookinfo-reviews-v1:${VERSION}" -t "${PREFIX}/bookinfo-reviews-v1:latest" --build-arg service_version=v1 .
    #with ratings black stars
    docker build --pull -t "${PREFIX}/bookinfo-reviews-v2:${VERSION}" -t "${PREFIX}/bookinfo-reviews-v2:latest" --build-arg service_version=v2 \
	   --build-arg enable_ratings=true .
    #with ratings red stars
    docker build --pull -t "${PREFIX}/bookinfo-reviews-v3:${VERSION}" -t "${PREFIX}/bookinfo-reviews-v3:latest" --build-arg service_version=v3 \
	   --build-arg enable_ratings=true --build-arg star_color=red .
  popd
popd

pushd "$SCRIPTDIR/ratings"
  docker build --pull -t "${PREFIX}/bookinfo-ratings-v2:${VERSION}" -t "${PREFIX}/bookinfo-ratings-v2:latest" --build-arg service_version=v2 .
popd

pushd "$SCRIPTDIR/ratings-admin/src/main/docker"
  docker build --pull -f Dockerfile.native -t "${PREFIX}/bookinfo-ratings-admin-v1:${VERSION}" -t "${PREFIX}/bookinfo-ratings-admin-v1:latest" .
popd

pushd "$SCRIPTDIR/mongodb"
  docker build --pull -t "${PREFIX}/bookinfo-mongodb:${VERSION}" -t "${PREFIX}/bookinfo-mongodb:latest" .
popd
