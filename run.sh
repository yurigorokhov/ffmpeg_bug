#!/bin/bash
set -eux -o pipefail

# build docker images
docker build --build-arg FFMPEG_VERSION=ffmpeg-6.0.1 -t ffmpeg-6-0-1 .
docker build --build-arg FFMPEG_VERSION=ffmpeg-6.1.1 -t ffmpeg-6-1-1 .

# run with ffmpeg-6.0.1
docker run -v `pwd`:/work --rm -it ffmpeg-6-0-1 \
    ffmpeg -y -hide_banner -r 1/1 -ignore_editlist true -loglevel error -i /work/waves.mov -an /work/waves-6-0-1-tmp.mov
docker run -v `pwd`:/work --rm -it ffmpeg-6-0-1 \
    ffmpeg -y -ignore_editlist true \
     -i /work/waves-6-0-1-tmp.mov -r 30 \
     -vcodec libx264 \
     -x264opts keyint=30:scenecut=0 \
     -crf 34 \
     -vf "setpts=(N/(30*TB)),format=pix_fmts=yuv420p" \
     /work/waves-6-0-1.mov

# run with ffmpeg-6.1.1
docker run -v `pwd`:/work --rm -it ffmpeg-6-1-1 \
    ffmpeg -y -hide_banner -r 1/1 -ignore_editlist true -loglevel error -i /work/waves.mov -an /work/waves-6-1-1-tmp.mov
docker run -v `pwd`:/work --rm -it ffmpeg-6-1-1 \
    ffmpeg -y -ignore_editlist true \
     -i /work/waves-6-1-1-tmp.mov -r 30 \
     -vcodec libx264 \
     -x264opts keyint=30:scenecut=0 \
     -crf 34 \
     -vf "setpts=(N/(30*TB)),format=pix_fmts=yuv420p" \
     /work/waves-6-1-1.mov

# compare waves-6-0-1.mov with waves-6-1-1.mov