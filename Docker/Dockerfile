FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install software-properties-common to get the add-apt-repository command
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    && add-apt-repository ppa:neovim-ppa/unstable \
    && apt-get update \
    && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*

