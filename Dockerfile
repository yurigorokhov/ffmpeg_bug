FROM alpine:3.15.0 as ffmpeg
ARG PREFIX=/opt/ffmpeg
ARG FFMPEG_VERSION

# FFmpeg build dependencies.
RUN set -ex && apk add --no-cache \
    build-base \
    cmake \
    freetype-dev \
    lame-dev \
    libogg-dev \
    libass \
    libass-dev \
    libvpx-dev \
    libvorbis-dev \
    libwebp-dev \
    libtheora-dev \
    libtool \
    opus-dev \
    openssl \
    openssl-dev \
    perl \
    pkgconf \
    pkgconfig \
    rtmpdump-dev \
    wget \
    x264-dev \
    x265-dev \
    yasm

# Get ffmpeg source.
RUN set -ex \
    && cd /tmp/ \
    && wget https://ffmpeg.org/releases/${FFMPEG_VERSION}.tar.bz2 \
    && tar xjvf ${FFMPEG_VERSION}.tar.bz2 && rm ${FFMPEG_VERSION}.tar.bz2

RUN set -ex \
    && cd /tmp/${FFMPEG_VERSION} \
    && ./configure \
        --pkgconfigdir="$PREFIX/lib/pkgconfig" \
        --prefix=${PREFIX} \
        --pkg-config-flags="--static" \
        --extra-cflags="-I$PREFIX/include" \
        --extra-ldflags="-L$PREFIX/lib" \
        --extra-libs="-lpthread -lm" \
        --enable-static \
        --disable-debug \
        --enable-pthreads \
        --enable-gpl \
        --enable-libx264 \
        --enable-runtime-cpudetect \
    && make -j$(nproc) \
    && make install \
    && make clean \
    && rm -rf /tmp/*


FROM alpine:3.15.0
ARG FFMPEG_VERSION

RUN set -ex && apk add --no-cache \
    bash \
    x264-dev \
    x265-dev \
    libbz2

COPY --from=ffmpeg /opt/ffmpeg/bin/ffprobe /usr/bin/ffprobe
COPY --from=ffmpeg /opt/ffmpeg/bin/ffmpeg /usr/bin/ffmpeg
