#!/bin/bash 

# exit on error
set -e

# check for amrfinder_update
if ! command -v "amrfinder_update" &> /dev/null; then
  echo "Error: amrfinder_update is not available on the PATH. You can install it with: mamba install bakta" >&2
  exit 1
fi

# Download and extract course data
wget -O bact-data.tar "TODO"
tar -xvf bact-data.tar
rm bact-data.tar

# Download and extract public databases
mkdir databases
cd databases

# kraken2
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20240605.tar.gz
mkdir k2_standard_08gb_20240605
tar -xzvf k2_standard_08gb_20240605.tar.gz -C k2_standard_08gb_20240605
rm k2_standard_08gb_20240605.tar.gz

# bakta
wget https://zenodo.org/records/10522951/files/db-light.tar.gz
tar -xzvf db-light.tar.gz
mv db-light  bakta_light_20240119
rm db-light.tar.gz

# update amrfinder database
amrfinder_update --force_update --database bakta_light_20240119/amrfinderplus-db/

# checkm2
wget https://zenodo.org/records/5571251/files/checkm2_database.tar.gz
tar -xzvf checkm2_database.tar.gz
mv CheckM2_database checkm2_v2_20210323
rm checkm2_database.tar.gz CONTENTS.json

# poppunk
wget https://gps-project.cog.sanger.ac.uk/GPS_v8_ref.tar.gz
mkdir poppunk
tar -xzvf GPS_v8_ref.tar.gz -C poppunk
rm GPS_v8_ref.tar.gz

wget -O poppunk/GPS_v8_external_clusters.csv https://gps-project.cog.sanger.ac.uk/GPS_v8_external_clusters.csv