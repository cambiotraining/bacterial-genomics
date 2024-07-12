# Use the official Ubuntu image as a base
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME /root

# Update and install required packages
RUN apt update && \
    apt upgrade -y && \
    apt autoremove -y && \
    apt install -y wget git default-jre

# Install Miniforge
RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh" && \
    bash Miniforge3-Linux-$(uname -m).sh -b -p /root/miniforge3 && \
    rm Miniforge3-Linux-$(uname -m).sh && \
    /root/miniforge3/bin/mamba init

ENV PATH="/root/miniforge3/bin:$PATH"

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
    /root/miniforge3/envs/remove_blocks/bin/pip install git+https://github.com/sanger-pathogens/remove_blocks_from_aln.git && \
    mamba create -y -n seqtk seqtk pandas && \
    mamba create -y -n tb-profiler tb-profiler pandas && \
    mamba create -y -n treetime treetime seqkit biopython

# Setup Nextflow config
RUN mkdir -p /root/.nextflow && \
    echo "\
conda { \
  conda.enabled = true \
  singularity.enabled = false \
  docker.enabled = false \
  useMamba = true \
  createTimeout = '4 h' \
  cacheDir = '/root/.nextflow-conda-cache/' \
} \
singularity { \
  singularity.enabled = true \
  conda.enabled = false \
  docker.enabled = false \
  pullTimeout = '4 h' \
  cacheDir = '/root/.nextflow-singularity-cache/' \
} \
docker { \
  docker.enabled = true \
  singularity.enabled = false \
  conda.enabled = false \
}" >> /root/.nextflow/config

# # Download and extract course data
# RUN mkdir -p /root/Course_Materials/bacterial_genomics && \
#     wget -O /root/Course_Materials/bacterial_genomics/bact-data.tar "https://www.dropbox.com/scl/fi/ba1ws6jx045jjq96m4bum/bacterial-genomics-data.tar?rlkey=thssczgyl9n32gvtdjwi1673f&dl=1" && \
#     tar -xvf /root/Course_Materials/bacterial_genomics/bact-data.tar -C /root/Course_Materials/bacterial_genomics && \
#     rm /root/Course_Materials/bacterial_genomics/bact-data.tar

# # Download and extract public databases
# RUN mkdir -p /root/Course_Materials/bacterial_genomics/databases && \
#     cd /root/Course_Materials/bacterial_genomics/databases && \
#     wget ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/old/minikraken2_v1_8GB_201904.tgz && \
#     tar -xzf minikraken2_v1_8GB_201904.tgz && \
#     rm minikraken2_v1_8GB_201904.tgz && \
#     wget https://zenodo.org/record/7669534/files/db-light.tar.gz && \
#     tar -xzf db-light.tar.gz && \
#     rm db-light.tar.gz && \
#     /root/miniforge3/bin/mamba run -n bakta amrfinder_update --force_update --database db-light/amrfinderplus-db/ && \
#     wget "https://zenodo.org/record/5571251/files/checkm2_database.tar.gz?download=1" -O checkm2_database.tar.gz && \
#     tar -xzf checkm2_database.tar.gz && \
#     rm checkm2_database.tar.gz && \
#     wget https://gps-project.cog.sanger.ac.uk/GPS_v8_ref.tar.gz && \
#     tar -xzf GPS_v8_ref.tar.gz && \
#     rm GPS_v8_ref.tar.gz && \
#     wget https://gps-project.cog.sanger.ac.uk/GPS_v8_external_clusters.csv

# Set the default command
CMD ["/bin/bash"]
