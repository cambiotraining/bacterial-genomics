# Use the official Ubuntu image as a base
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt update && \
    apt install -y wget git default-jre

# create user
RUN useradd -ms /bin/bash participant

# switch to participant
USER participant
WORKDIR /home/participant

# Install Miniforge
RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh" && \
    bash Miniforge3-Linux-$(uname -m).sh -b -p /home/participant/miniforge3 && \
    rm Miniforge3-Linux-$(uname -m).sh && \
    /home/participant/miniforge3/bin/mamba init

ENV PATH="/home/participant/miniforge3/bin:$PATH"


# Setup Conda channels and config
RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --set remote_read_timeout_secs 1000

# Install conda packages and create environments
RUN mamba install -y -n base pandas && \
    mamba create -y -n bakta bakta && \
    mamba create -y -n gubbins gubbins && \
    mamba create -y -n iqtree iqtree snp-sites biopython && \
    mamba create -y -n mlst mlst && \
    mamba create -y -n nextflow nextflow && \
    mamba create -y -n pairsnp pairsnp && \
    mamba create -y -n panaroo python=3.9 panaroo>=1.3 snp-sites && \
    mamba create -y -n poppunk python=3.10 poppunk && \
    mamba create -y -n remove_blocks python=2.7 && \
    /home/participant/miniforge3/envs/remove_blocks/bin/pip install git+https://github.com/sanger-pathogens/remove_blocks_from_aln.git && \
    mamba create -y -n seqtk seqtk pandas && \
    mamba create -y -n tb-profiler tb-profiler pandas && \
    mamba create -y -n treetime treetime seqkit biopython

# Setup Nextflow config
RUN mkdir -p /home/participant/.nextflow && \
    cat <<EOF >> /home/participant/.nextflow/config
    process {
      resourceLimits = [
        cpus: 8,
        memory: 20.GB,
        time: 12.h
      ]
    }
    singularity { 
      singularity.enabled = true 
      conda.enabled = false 
      docker.enabled = false 
      pullTimeout = '4 h' 
      cacheDir = '/home/participant/.nextflow-singularity-cache/' 
    }
    EOF

# Set the default command
CMD ["/bin/bash"]
