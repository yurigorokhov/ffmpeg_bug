#!/bin/bash
set -eux -o pipefail

VERSION=7.0

# build docker images
docker build --build-arg FFMPEG_VERSION=ffmpeg-${VERSION} -t ffmpeg-${VERSION} .

# generate test video
docker run -v `pwd`:/work --rm -it ffmpeg-${VERSION} \
    ffmpeg -f lavfi \
    -i testsrc=size=1280x720:duration=50 \
    -vf "drawtext=text='%{n}':fontsize=72:x=(w-text_w)/2:y=(h-text_h)/2:fontcolor=white" \
    -c:v libx264 -preset ultrafast \
    /work/265_bug_input_video.mov

# generate video with frozen frames
docker run -v `pwd`:/work --rm -it ffmpeg-${VERSION} \
    ffmpeg -i /work/265_bug_input_video.mov -c:v libx265 -tag:v hvc1 \
    /work/265_bug_frozen_frames.mov

