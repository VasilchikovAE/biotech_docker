# Базовый образ
FROM ubuntu:22.04

# Переменные окружения
ENV SOFT=/soft
ENV PATH="$SOFT/libdeflate/bin:$SOFT/htslib/bin:$SOFT/samtools/bin:$SOFT/bcftools/bin:$SOFT/vcftools/bin:$PATH"

# Рабочая директория
WORKDIR /tmp

# Библиотеки
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    git \
    autoconf \
    automake \
    cmake \
    make \
    gcc \
    g++ \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    ninja-build \
    perl \
    python3 \
    pkg-config \
    libncurses5-dev \
    libncursesw5-dev \
    && rm -rf /var/lib/apt/lists/*

# Софт
RUN mkdir -p $SOFT

# https://github.com/ebiggers/libdeflate
# v 1.24
# May 11th 2025

RUN mkdir -p $SOFT/libdeflate && \
    cd $SOFT/libdeflate && \
    wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.24.tar.gz && \
    tar -xzf v1.24.tar.gz && \
    mkdir build && cd build && \
    cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$SOFT/libdeflate ../libdeflate-1.24 && \
    ninja && \
    ninja install && \
    rm -rf $SOFT/libdeflate/v1.24.tar.gz
ENV LIBDEFLATE_PATH=$SOFT/libdeflate/bin

# https://github.com/samtools/htslib
# v 1.21
# September 12th 2024

RUN mkdir -p $SOFT/htslib && \
    cd $SOFT/htslib && \
    wget https://github.com/samtools/htslib/releases/download/1.21/htslib-1.21.tar.bz2 && \
    tar -xjf htslib-1.21.tar.bz2 && \
    cd ./htslib-1.21 && \
    ./configure && \
    make && \
    make install && \
    rm -rf $SOFT/htslib/htslib-1.21.tar.bz2
ENV HTSLIB_PATH=$SOFT/htslib/bin

# https://github.com/samtools/samtools
# v 1.21
# September 12th 2024

RUN mkdir -p $SOFT/samtools && \
    cd $SOFT/samtools && \
    wget https://github.com/samtools/samtools/releases/download/1.21/samtools-1.21.tar.bz2 && \
    tar -xjf samtools-1.21.tar.bz2 && \
    cd ./samtools-1.21 && \
    ./configure && \
    make && \
    make install && \
    rm -rf $SOFT/samtools/samtools-1.21.tar.bz2
ENV SAMTOOLS_PATH=$SOFT/samtools/bin

# https://github.com/samtools/bcftools
# v 1.21
# September 12th 2024

RUN mkdir -p $SOFT/bcftools && \
    cd $SOFT/bcftools && \
    wget https://github.com/samtools/bcftools/releases/download/1.21/bcftools-1.21.tar.bz2 && \
    tar -xjf bcftools-1.21.tar.bz2 && \
    cd ./bcftools-1.21 && \
    ./configure && \
    make && \
    make install && \
    rm -rf $SOFT/bcftools/bcftools-1.21.tar.bz2
ENV BCFTOOLS_PATH=$SOFT/bcftools/bin

# https://github.com/vcftools/vcftools
# v 0.1.17
# May 15th 2025

RUN mkdir -p $SOFT/vcftools && \
    cd $SOFT/vcftools && \
    wget https://github.com/vcftools/vcftools/releases/download/v0.1.17/vcftools-0.1.17.tar.gz && \
    tar -xzf vcftools-0.1.17.tar.gz && \
    cd ./vcftools-0.1.17 && \
    ./configure && \
    make && \
    make install && \
    rm -rf $SOFT/vcftools/vcftools-0.1.17.tar.gz
ENV VCFTOOLS_PATH=$SOFT/vcftools/bin

# Зачистка
WORKDIR /
RUN rm -rf /tmp/*

# Дефолт
CMD ["bash"]