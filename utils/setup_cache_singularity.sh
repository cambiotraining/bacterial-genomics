#!/bin/bash

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