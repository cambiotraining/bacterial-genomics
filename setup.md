---
title: "Data & Setup"
number-sections: false
---

::: {.callout-tip level=2}
## Workshop Attendees

If you are attending one of our workshops, we will provide a training environment with all of the required software and data.  
If you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below.
:::

## Software

### Linux

Most of the analyses demonstrated in these materials are more suited to be run on a High Performance Computing (HPC) cluster. 
If you already have access to a HPC in your institution, you can skip this step of the setup. 

Otherwise, we provide instructions to setup Linux on a local computer. 

::: {.panel-tabset group="os"}
#### Ubuntu

The recommendation for bioinformatic analysis is to have a dedicated computer running a Linux distribution. 
The kind of distribution you choose is not critical, but we recommend **Ubuntu** if you are unsure.

You can follow the [installation tutorial on the Ubuntu webpage](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview). 

:::{.callout-warning}
Installing Ubuntu on the computer will remove any other operating system you had previously installed, and can lead to data loss. 
:::

#### Windows WSL

The **Windows Subsystem for Linux (WSL2)** runs a compiled version of Ubuntu natively on Windows. 

There are detailed instructions on how to install WSL on the [Microsoft documentation page](https://learn.microsoft.com/en-us/windows/wsl/install). 
But briefly:

- Click the Windows key and search for  _Windows PowerShell_, right-click on the app and choose **Run as administrator**. 
- Answer "Yes" when it asks if you want the App to make changes on your computer. 
- A terminal will open; run the command: `wsl --install`. 
  - This should start installing "ubuntu". 
  - It may ask for you to restart your computer. 
- After restart, click the Windows key and search for _Ubuntu_, click on the App and it should open a new terminal. 
- Follow the instructions to create a username and password (you can use the same username and password that you have on Windows, or a different one - it's your choice). 
- You should now have access to a Ubuntu Linux terminal. 
  This (mostly) behaves like a regular Ubuntu terminal, and you can install apps using the `sudo apt install` command as usual. 

After WSL is installed, it is useful to create shortcuts to your files on Windows. 
Your `C:\` drive is located in `/mnt/c/` (equally, other drives will be available based on their letter). 
For example, your desktop will be located in: `/mnt/c/Users/<WINDOWS USERNAME>/Desktop/`. 
It may be convenient to set shortcuts to commonly-used directories, which you can do using _symbolic links_, for example: 

- **Documents:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Documents/ ~/Documents`
  - If you use OneDrive to save your documents, use: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/OneDrive/Documents/ ~/Documents`
- **Desktop:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Desktop/ ~/Desktop`
- **Downloads**: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Downloads/ ~/Downloads`

#### Virtual machine

Another way to run Linux within Windows (or macOS) is to install a Virtual Machine.
However, this is mostly suitable for practicing and **not suitable for real data analysis**.

Detailed instructions to install an Ubuntu VM using Oracle's Virtual Box is available from the [Ubuntu documentation page](https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview).

**Note:** In the step configuring "Virtual Hard Disk" make sure to assign a large storage partition (at least 100GB).

:::


#### Update Ubuntu

After installing Ubuntu (through either of the methods above), open a terminal and run the following commands to update your system and install some essential packages: 

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install -y git
sudo apt install -y default-jre
```


### Conda/Mamba

We recommend using the _Conda_ package manager to install your software. 
In particular, the newest implementation called _Mamba_. 

To install _Mamba_, run the following commands from the terminal: 

```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $HOME/miniforge3
rm Miniforge3-$(uname)-$(uname -m).sh
$HOME/miniforge3/bin/mamba init
```

Restart your terminal (or open a new one) and confirm that your shell now starts with the word `(base)`.
Then run the following commands: 

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set remote_read_timeout_secs 1000
```


### Software environments

Due to the complexities of the different tools we will use, there are several software dependency incompatibilities between them.
Therefore, rather than creating a single software environment with all the tools, we will create separate environments for different applications. 

#### Pandas

For convenience, we recommend installing the popular Pandas package in the base (default) environment:

```bash
mamba install -n base pandas
```

#### Bakta

```bash
mamba create -n bakta bakta
```

#### Krona

```bash
mamba create -n krona krona
```

#### Gubbins

```bash
mamba create -n gubbins gubbins
```

#### IQ-Tree

```bash
mamba create -n iqtree iqtree snp-sites biopython
```

#### mlst

```bash
mamba create -n mlst mlst
```

#### Nextflow

```bash
mamba create -n nextflow nextflow
```

Also run the following commands to set a basic _Nextflow_ configuration file. 
Make sure to adjust the resource limits to fit with your workstation or HPC (maximum values for `cpus`, `memory` and `time`).

```bash
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
```

#### pairsnp

```bash
mamba create -n pairsnp pairsnp
```

#### Panaroo

```bash
mamba create -n panaroo python=3.9 panaroo>=1.3 snp-sites
```

#### PopPUNK

```bash
mamba create -n poppunk python=3.10 poppunk
```

#### remove_blocks_from_aln

```bash
mamba create -n remove_blocks python=2.7
$HOME/miniforge3/envs/remove_blocks/bin/pip install git+https://github.com/sanger-pathogens/remove_blocks_from_aln.git
```

#### Seqtk

```bash
mamba create -n seqtk seqtk pandas
```

#### TB-Profiler

```bash
mamba create -n tb-profiler tb-profiler pandas
```

#### TreeTime

```bash
mamba create -n treetime treetime seqkit biopython
```

#### MOB-suite & Pling & mashtree

```bash
mamba create -n mob_suite mob_suite
mamba create -n pling pling
mamba create -n mashtree mashtree
```

### R and RStudio

_R_ and _RStudio_ are available for all major operating systems. 

- **Windows:** download and install all these using default options:
  - [R](https://cran.r-project.org/bin/windows/base/release.html)
  - [RTools](https://cran.r-project.org/bin/windows/Rtools/)
  - [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

- **macOS:** download and install all these using default options:
  - [R](https://cran.r-project.org/bin/macosx/)
  - [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

- **Linux**:
  - Go to the [R installation](https://cran.r-project.org/bin/linux/) folder and look at the instructions for your distribution.
  - Download the [RStudio](https://www.rstudio.com/products/rstudio/download/#download) installer for your distribution and install it using your package manager.

After installing R, you will need to install a few packages. 
Open _RStudio_ and on the console type the following command: 

```r
install.packages(c("tidyverse", "tidygraph", "ggraph", "igraph", "ggtree", "ggnewscale", "phytools"))
```


### Singularity

We recommend that you install _Singularity_ and use the `-profile singularity` option when running _Nextflow_ pipelines. 
On Ubuntu/WSL2, you can install _Singularity_ using the following commands: 

```bash
sudo apt install -y libfuse2t64 runc fuse2fs uidmap
wget -O singularity.deb https://github.com/sylabs/singularity/releases/download/v4.3.0/singularity-ce_4.3.0-$(lsb_release -cs)_amd64.deb
sudo dpkg -i singularity.deb
rm singularity.deb
```

If you have a different Linux distribution, you can find more detailed instructions on the [_Singularity_ documentation page](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux). 

If you have issues running _Nextflow_ pipelines with _Singularity_, then you can follow the instructions below for _Docker_ instead. 


### Docker

An alternative for software management when running _Nextflow_ pipelines is to use _Docker_. 

::: {.panel-tabset group="os"}
#### Ubuntu

For Ubuntu Linux, here are the installation instructions: 

```bash
sudo apt install curl
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo groupadd docker
sudo usermod -aG docker $USER
```

After the last step, you will need to **restart your computer**. 
From now on, you can use `-profile docker` when you run _Nextflow_.

#### Windows WSL

When using WSL2 on Windows, running _Nextflow_ pipelines with `-profile singularity` sometimes doesn't work. 

As an alternative you can instead use _Docker_, which is another software containerisation solution. 
To set this up, you can follow the full instructions given on the Microsoft Documentation: [Get started with Docker remote containers on WSL 2](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers#install-docker-desktop).

We briefly summarise the instructions here (but check that page for details and images): 

- Download [_Docker_ for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe).
- Run the installer and install accepting default options. 
- Restart the computer.
- Open Docker and go to **Settings > General** to tick "Use the WSL 2 based engine".
- Go to **Settings > Resources > WSL Integration** to enable your Ubuntu WSL installation.

Once you have _Docker_ set and installed, you can use `-profile docker` when running your _Nextflow_ command.

#### Virtual machine

You can follow the same instructions as for "Ubuntu".
:::


## Data

The data used in these materials is provided as an archive file (`bact-data.tar`). 
You can download it from the link below and extract the files from the archive into a directory of your choice.

<a href="https://www.dropbox.com/scl/fi/6168oq4npclpmihyg7z74/bact-data.tar?rlkey=pjb17bbj5r1cynnxeprl47mwf&st=cjtedg9v&dl=1">
  <button class="btn"><i class="fa fa-download"></i> Download</button>
</a>

You can also download them using the command line: 

```bash
# directory for saving the data - change this to suit your needs
datadir="$HOME/Desktop/bacterial_genomics"

# download and extract to directory
mkdir $datadir
wget -O $datadir/bact-data.tar "https://www.dropbox.com/scl/fi/6168oq4npclpmihyg7z74/bact-data.tar?rlkey=pjb17bbj5r1cynnxeprl47mwf&st=cjtedg9v&dl=1"
tar -xvf $datadir/bact-data.tar -C $datadir
rm $datadir/bact-data.tar
```

::: {.callout-tip}
#### Note for training facility

We also need to include preprocessed data for the outbreak exercise. 
See the [download script](https://github.com/cambiotraining/bacterial-genomics/blob/main/utils/download_data.sh) in the repo for details.
:::


### Databases

We include a copy of public databases used in the exercises in the dropbox link above. 
However, for your analyses you should always download the most up-to-date databases. 

In the code below we download these databases into a directory called `databases`. 
This is optional, you can download the databases where it is most convenient for you. 
If you work in a research group, it's a good idea to have a shared storage where everyone can access the same copy of the databases. 

```bash
# create directory for public DBs
mkdir databases
cd databases
```

#### Kraken2

We use a small version of the database for teaching purposes, whereas you may want to use the full version in your work. 
Look at the [Kraken2 indexes page](https://benlangmead.github.io/aws-indexes/k2) for the latest versions available. 

```bash
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20240605.tar.gz
mkdir k2_standard_08gb_20240605
tar -xzvf k2_standard_08gb_20240605.tar.gz -C k2_standard_08gb_20240605
rm k2_standard_08gb_20240605.tar.gz
```

#### Bakta

We use the "light" version of the database for teaching purposes, whereas you may want to use the full version in your work. 
Look at the [Bakta Zenodo repository](https://zenodo.org/records/10522951) for the latest versions available.

```bash
wget https://zenodo.org/records/10522951/files/db-light.tar.gz
tar -xzvf db-light.tar.gz
mv db-light  bakta_light_20240119
rm db-light.tar.gz

# make sure to activate bakta environment
mamba activate bakta
amrfinder_update --force_update --database bakta_light_20240119/amrfinderplus-db/
```

#### CheckM2

CheckM2 also provides a command `checkm2 database --download` to download the latest version of the database [from Zenodo](https://zenodo.org/records/5571251).

```bash
wget https://zenodo.org/records/5571251/files/checkm2_database.tar.gz
tar -xzvf checkm2_database.tar.gz
mv CheckM2_database checkm2_v2_20210323
rm checkm2_database.tar.gz CONTENTS.json
```

#### GPSCs

```bash
wget https://gps-project.cog.sanger.ac.uk/GPS_v8_ref.tar.gz
mkdir poppunk
tar -xzvf GPS_v8_ref.tar.gz -C poppunk
rm GPS_v8_ref.tar.gz

wget -O poppunk/GPS_v8_external_clusters.csv https://gps-project.cog.sanger.ac.uk/GPS_v8_external_clusters.csv
```

#### Krona

```bash
# make sure to activate krona environment
mamba activate krona
ktUpdateTaxonomy.sh krona/
```

#### MOB-suite

MOB-suite has a generic database available, which can be downloaded using:

```bash
mamba activate mob_suite
mob_init -d mob_suite -v
```

The MOB-suite developers also provide a [collection of Enterobacteriacea genomes](https://github.com/phac-nml/mob-suite?tab=readme-ov-file#using-mob-recon-to-reconstruct-plasmids-from-draft-assemblies) for organisms such as E. coli. 
These can be downloaded separately from Zenodo, like so:

```bash
wget -O mobsuite.zip https://zenodo.org/api/records/3785351/files-archive
unzip mobsuite.zip -d mob_suite
rm mobsuite.zip
```


#### CARD

This database is used by the Nextflow workflow `nf-core/funcscan`. 
The database is downloaded by the workflow itself, but if you run this workflow regularly, it might be best to download it once, to save time and bandwidth.

Instructions for this are given in the [workflow documentation page](https://nf-co.re/funcscan/usage#rgi). 
Here is how we did it for our workshop:

```bash
mkdir card
wget -O card.tar.bz2 https://card.mcmaster.ca/latest/data
tar -xjvf card.tar.bz2 -C card
rm card.tar.bz2
```