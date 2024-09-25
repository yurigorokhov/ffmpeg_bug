#!/bin/bash
set -eux -o pipefail

VERSION=7.0

# build docker images
docker build --build-arg FFMPEG_VERSION=ffmpeg-${VERSION} -t ffmpeg-${VERSION} .


# transcode to 1fps
docker run -v `pwd`:/work --rm -it ffmpeg-${VERSION} \
    ffmpeg -y -hide_banner -r 1/1 -ignore_editlist true -loglevel error -i /work/input_test_long.mov -an /work/input_test_long_1fps.mov


# generate video with frozen frames
docker run -v `pwd`:/work --rm -it ffmpeg-${VERSION} \
    ffmpeg -i /work/input_test_long_1fps.mov -c:v libx265 -vf "setpts=(N/(30*TB)),format=pix_fmts=yuv420p" \
    -tag:v hvc1 \
    /work/output-test-long-${VERSION}.mov
