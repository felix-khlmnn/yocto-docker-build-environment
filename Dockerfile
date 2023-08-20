# Dockerfile that sets up a Yocto build environment

FROM ubuntu:22.04

# Setup timezone settings and deactivate any interactivity of apt
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive

# Upgrade the system
RUN apt update && apt upgrade -y

# Perform minimal required steps to get started building with Yocto
RUN apt install -y gawk wget git diffstat unzip texinfo gcc build-essential \
    chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git \
    python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales

# Generate the wanted locales
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
    ENV LANG en_US.UTF-8
    ENV LC_ALL en_US.UTF-8

# Clean up APT when done.                                                        
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Set up default shell to be bash instead of dash
RUN rm /bin/sh && ln -s bash /bin/sh

# Create a non-root user, make the user the owner of the /yocto workdir and switch to the user
RUN useradd -m yocto && \
    usermod -aG sudo yocto

USER yocto

# Set the workdir
WORKDIR /yocto

# Entry point
CMD ["/bin/bash"]
