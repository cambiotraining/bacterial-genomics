#!/bin/bash 

# exit on error
set -euo pipefail

#### Data & databases ####

# Download and extract course data
echo "Downloading and extracting course files"
wget -O bact-data.tar "https://www.dropbox.com/scl/fi/6168oq4npclpmihyg7z74/bact-data.tar?rlkey=pjb17bbj5r1cynnxeprl47mwf&st=7v87dtxu&dl=1"
tar -xf bact-data.tar
rm bact-data.tar

# Download and extract public databases
echo "Downloading and extracting public databases"
wget -O bact-databases.tar "https://www.dropbox.com/scl/fi/ljwypmwetfu6o6pe3fwff/bact-databases.tar?rlkey=yyg3q7w0s47ildzad5sfftr1x&st=dpvr7mgm&dl=1"
tar -xf bact-databases.tar
rm bact-databases.tar


#### Mamba environments ####

mamba install -n base pandas
mamba create -y -n bakta bakta
mamba create -y -n krona krona
mamba create -y -n gubbins gubbins
mamba create -y -n iqtree iqtree snp-sites biopython
mamba create -y -n mlst mlst
mamba create -y -n pairsnp pairsnp
mamba create -y -n panaroo python=3.9 panaroo>=1.3 snp-sites
mamba create -y -n poppunk python=3.10 poppunk
mamba create -y -n remove_blocks python=2.7
$HOME/miniforge3/envs/remove_blocks/bin/pip install git+https://github.com/sanger-pathogens/remove_blocks_from_aln.git
mamba create -y -n seqtk seqtk pandas
mamba create -y -n tb-profiler tb-profiler pandas
mamba create -y -n treetime treetime seqkit biopython
mamba create -y -n mob_suite mob_suite
mamba create -y -n pling pling
mamba create -y -n mashtree mashtree

mamba create -y -n nextflow nextflow

mkdir -p $HOME/.nextflow
cat <<EOF >> $HOME/.nextflow/config
process {
  resourceLimits = [
    cpus: 8,
    memory: 20.GB,
    time: 12.h
  ]
}
singularity { 
  pullTimeout = '4 h' 
  cacheDir = '$HOME/.nextflow-singularity-cache/' 
}
EOF


#### R packages ####

Rscript -e 'install.packages(c("tidyverse", "tidygraph", "ggraph", "igraph", "ggtree", "ggnewscale", "phytools"))'


#### Cache Nextflow workflows ####

tools=("avantonder/bacQC" "avantonder/bacQC-ONT" "avantonder/assembleBAC" "avantonder/assembleBAC-ONT" "nf-core/bactmap" "nf-core/funcscan" "nf-core/fetchngs")
versions=("v2.0.1" "v2.0.2" "v2.0.2" "v2.0.3" "1.0.0" "2.1.0" "1.12.0")

for i in "${!tools[@]}"
do
  wf="${tools[i]}"
  version="${versions[i]}"
  tmpdir="/tmp/$(basename $wf)"
  
  # download images
  nf-core pipelines download $wf \
    --revision "$version" \
    --outdir "$tmpdir" \
    --force \
    --compress none \
    --download-configuration yes \
    --container-system singularity \
    --container-cache-utilisation amend
  
  # remove temporary dir
  rm -r "$tmpdir"

  # pull the workflow to its standard directory
  nextflow pull -r "$version" "$wf"
done


#### Test setup ####

bash setup_test_ecoli.sh
bash setup_test_mtuberculosis.sh
bash setup_test_saureus.sh
bash setup_test_spneumoniae.sh
