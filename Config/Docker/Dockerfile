FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color

# 1. INSTALL DEPENDENCIES & NEOVIM
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    unzip \
    tar \
    build-essential \
    ripgrep \
    fd-find \
    sudo \
    && add-apt-repository ppa:neovim-ppa/unstable \
    && apt-get update \
    && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*

# 2. GRANT SUDO ACCESS TO PRE-EXISTING 'UBUNTU' USER (UID/GID 1000)
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

USER ubuntu
WORKDIR /home/ubuntu/workspace

# 3. SET UP LAZYVIM
RUN git clone https://github.com/LazyVim/starter /home/ubuntu/.config/nvim && \
    rm -rf /home/ubuntu/.config/nvim/.git

CMD ["/bin/bash"]
