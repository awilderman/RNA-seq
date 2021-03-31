echo "#!/bin/bash
#SBATCH --job-name=human_tophat
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=user@uchc.edu
#SBATCH -o human_tophat_%j.out
#SBATCH -e human_tophat_%j.err

source ~/.bashrc 
cd ~/ANALYSIS/RNA-seq/CNCC_RNA-seq/merged_cf
export ANALYSISDIR=~/ANALYSIS/RNA-seq/CNCC_RNA-seq/merged_cf
export GTFDIR=~/TOOLS/bcbio/genomes/Hsapiens/hg19/annotation
export INDEXDIR=~/TOOLS/bcbio/genomes/Hsapiens/hg19/bowtie2
export FQDIR=~/ANALYSIS/RNA-seq/CNCC_RNA-seq/merged_cf
module load tophat/2.1.0
module load python/2.7.14
export PYTHON_PATH=/home/FCAM/awilderman/.local/lib/python2.7/site-packages" > human_tophat.slurm

cat sample_list.txt | awk '{ \
print "\ntophat -o \$ANALYSISDIR/"$1"PE --library-type fr-firststrand -p 16 -G \$GTFDIR/gencode.v10.annotation.gtf --no-discordant --mate-inner-dist 100 \$INDEXDIR/hg19 \$FQDIR/"$1"forward_paired.fq.gz \$FQDIR/"$1"reverse_paired.fq.gz" \
}' >> human_tophat.slurm
