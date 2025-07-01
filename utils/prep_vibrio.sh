#!/bin/bash

# SRA numbers
echo "ERR1485225
ERR1485227
ERR1485229
ERR1485231
ERR1485233
ERR1485235
ERR1485237
ERR1485301
ERR1485299
SRR26899141" > samples.csv

# download data
nextflow run nf-core/fetchngs \
  -profile singularity \
  --input samples.csv \
  --outdir tmp/

mkdir -p data/reads

# trim to 100bp and ~1.4M reads to match other libraries
seqtk trimfq -q 0 -l 100 tmp/fastq/SRX22593269_SRR26899141_1.fastq.gz | seqtk sample -s 1 - 1304923 | gzip > data/reads/isolate08_1.fastq.gz
seqtk trimfq -q 0 -l 100 tmp/fastq/SRX22593269_SRR26899141_2.fastq.gz | seqtk sample -s 1 - 1304923 | gzip > data/reads/isolate08_2.fastq.gz

# downsample to generate a lower coverage sample
seqtk sample -s 1 tmp/fastq/ERX1556340_ERR1485227_1.fastq.gz 33725 | gzip > data/reads/isolate02_1.fastq.gz
seqtk sample -s 1 tmp/fastq/ERX1556340_ERR1485227_2.fastq.gz 33725 | gzip > data/reads/isolate02_2.fastq.gz

# move and rename other files
mv tmp/fastq/ERX1556339_ERR1485225_1.fastq.gz data/reads/isolate01_1.fastq.gz
mv tmp/fastq/ERX1556339_ERR1485225_2.fastq.gz data/reads/isolate01_2.fastq.gz
mv tmp/fastq/ERX1556341_ERR1485229_1.fastq.gz data/reads/isolate03_1.fastq.gz
mv tmp/fastq/ERX1556341_ERR1485229_2.fastq.gz data/reads/isolate03_2.fastq.gz
mv tmp/fastq/ERX1556342_ERR1485231_1.fastq.gz data/reads/isolate04_1.fastq.gz
mv tmp/fastq/ERX1556342_ERR1485231_2.fastq.gz data/reads/isolate04_2.fastq.gz
mv tmp/fastq/ERX1556343_ERR1485233_1.fastq.gz data/reads/isolate05_1.fastq.gz
mv tmp/fastq/ERX1556343_ERR1485233_2.fastq.gz data/reads/isolate05_2.fastq.gz
mv tmp/fastq/ERX1556344_ERR1485235_1.fastq.gz data/reads/isolate06_1.fastq.gz
mv tmp/fastq/ERX1556344_ERR1485235_2.fastq.gz data/reads/isolate06_2.fastq.gz
mv tmp/fastq/ERX1556345_ERR1485237_1.fastq.gz data/reads/isolate07_1.fastq.gz
mv tmp/fastq/ERX1556345_ERR1485237_2.fastq.gz data/reads/isolate07_2.fastq.gz
mv tmp/fastq/ERX1556376_ERR1485299_1.fastq.gz data/reads/isolate09_1.fastq.gz # water
mv tmp/fastq/ERX1556376_ERR1485299_2.fastq.gz data/reads/isolate09_2.fastq.gz # water
mv tmp/fastq/ERX1556377_ERR1485301_1.fastq.gz data/reads/isolate10_1.fastq.gz # water
mv tmp/fastq/ERX1556377_ERR1485301_2.fastq.gz data/reads/isolate10_2.fastq.gz # water

# clean
rm -rf .nextflow* work tmp samples.csv
