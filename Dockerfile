FROM quay.io/almalinux/almalinux:9

RUN dnf -y update && \
    dnf -y install wget which bzip2 ca-certificates libxcrypt-compat openssl && \
    dnf clean all

RUN wget --no-check-certificate https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniforge3-Linux-x86_64.sh

ENV PATH="/opt/conda/bin:$PATH"

RUN conda config --set ssl_verify false && \
    conda config --add channels https://repo.prefix.dev/conda-forge && \
    conda config --add channels https://repo.prefix.dev/bioconda && \
    conda config --add channels samtobam && \
    conda config --set channel_priority strict

RUN mamba create -y -n stargraph stargraph && \
    mamba clean -a

ENV PATH="/opt/conda/envs/stargraph/bin:$PATH"
WORKDIR /data

# Verify the installation works (using the correct name)
RUN stargraph.sh --help

# Set the default command for the container
CMD ["stargraph.sh", "--help"]
