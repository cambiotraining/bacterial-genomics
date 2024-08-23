#!/bin/bash 

# exit on error
set -e

# check for amrfinder_update
if ! command -v "amrfinder_update" &> /dev/null; then
  echo "Error: amrfinder_update is not available on the PATH. You can install it with: mamba create -n bakta bakta" >&2
  exit 1
fi

# Download and extract course data
echo "Downloading and extracting course files"
wget -O bact-data.tar "https://www.dropbox.com/scl/fi/gdqf3y3toot2hjtivhlpk/bact-data.tar?rlkey=udjh38aqd05eg3r8klw5mguld&dl=1"
tar -xf bact-data.tar
rm bact-data.tar

# Download and extract preprocessed files for outbreak exercise
echo "Downloading and extracting preprocessed outbreak exercise files"
wget -O preprocessed-outbreak.tar "https://www.dropbox.com/scl/fi/axj9ur03hhe78d9dvbak3/preprocessed-outbreak.tar?rlkey=1ftvheba6ak3b7k20nls2ijkh&st=mbnd6lfw&dl=1"
tar -xf preprocessed-outbreak.tar
mv preprocessed-outbreak ~/Course_Share/
rm preprocessed-outbreak.tar

# Download and extract public databases
mkdir databases
cd databases

# kraken2
echo "Downloading and extracting Kraken2 database"
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20240605.tar.gz
mkdir k2_standard_08gb_20240605
tar -xzf k2_standard_08gb_20240605.tar.gz -C k2_standard_08gb_20240605
rm k2_standard_08gb_20240605.tar.gz

# bakta
echo "Downloading and extracting Bakta database"
wget https://zenodo.org/records/10522951/files/db-light.tar.gz
tar -xzf db-light.tar.gz
mv db-light  bakta_light_20240119
rm db-light.tar.gz

# update amrfinder database
amrfinder_update --force_update --database bakta_light_20240119/amrfinderplus-db/

# checkm2
echo "Downloading and extracting CheckM2 database"
wget https://zenodo.org/records/5571251/files/checkm2_database.tar.gz
tar -xzf checkm2_database.tar.gz
mv CheckM2_database checkm2_v2_20210323
rm checkm2_database.tar.gz CONTENTS.json

# poppunk
echo "Downloading and extracting PopPunk database"
wget https://gps-project.cog.sanger.ac.uk/GPS_v8_ref.tar.gz
mkdir poppunk
tar -xzf GPS_v8_ref.tar.gz -C poppunk
rm GPS_v8_ref.tar.gz

wget -O poppunk/GPS_v8_external_clusters.csv https://gps-project.cog.sanger.ac.uk/GPS_v8_external_clusters.csv