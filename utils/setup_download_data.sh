#!/bin/bash 

# exit on error
set -e

# check for amrfinder_update
if ! command -v "amrfinder_update" &> /dev/null; then
  echo "Error: amrfinder_update is not available on the PATH. You can install it with: mamba create -n bakta bakta" >&2
  exit 1
fi

# check for krona
if ! command -v "ktUpdateTaxonomy.sh" &> /dev/null; then
  echo "Error: ktUpdateTaxonomy.sh is not available on the PATH. You can install it with: mamba create -n krona krona" >&2
  exit 1
fi

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