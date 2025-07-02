#!/bin/bash 

# exit on error
set -euo pipefail

#### Data & Databases ####

# Download and extract course data
echo "Downloading and extracting course files"
wget -O bact-data.tar "https://www.dropbox.com/scl/fi/6168oq4npclpmihyg7z74/bact-data.tar?rlkey=pjb17bbj5r1cynnxeprl47mwf&st=cjtedg9v&dl=1"
tar -xf bact-data.tar
rm bact-data.tar

# Download and extract public databases
echo "Downloading and extracting public databases"
wget -O bact-databases.tar "https://www.dropbox.com/scl/fi/ljwypmwetfu6o6pe3fwff/bact-databases.tar?rlkey=yyg3q7w0s47ildzad5sfftr1x&st=qtmbfnch&dl=1"
tar -xf bact-databases.tar
rm bact-databases.tar


#### Cache Nextflow Workflows ####

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