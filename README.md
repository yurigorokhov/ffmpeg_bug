# Reproduce

ffmpeg 6.1/6.1.1 introduced what seems to be a bug when encoding videos with x264.

`./run.sh` is a self-contained way reproduce the issue with the provided video. It will build containers with the relevant ffmpeg versions (6.0.1 and 6.1.1), and produces the corresponding video outputs.

Please reference run.sh for the involved ffmpeg commands.

The input video is a 1fps video. After running run.sh please compare output-6-0-1.mov with output-6-1-1.mov. You will notice that output-6-1-1.mov has some frozen frames at the beginning of the video which should not be there.
