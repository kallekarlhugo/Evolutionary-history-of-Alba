#mkdir annotation && cd annotation
#mkdir assemblies
#mkdir rnaseq
#mkdir proteins && cd proteins
#wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
#tar xvf odb10_arthropoda_fasta.tar.gz
#cat arthropoda/Rawdata/* > odb10_arthropoda_proteins.fa
basepath=$(pwd)/
cd proteins
proteins=$(pwd)/odb10_arthropoda_proteins.fa
cd ../assemblies
genomepath=$(pwd)/
#ln -s /mnt/griffin/kaltun/genomes/Ce_fixed.fa .
#ln -s /mnt/griffin/kaltun/ceu/polish/Ce_fixed/NGM_pilon/*fasta .
#ln -s /mnt/griffin/kaltun/ceu/polish/Ce_fixed/SNAP_pilon/*fasta .
#ln -s /mnt/griffin/kaltun/ceu/polish/Ce_fixed/BWAmem_pilon/*fasta .
#ln -s /mnt/griffin/kaltun/ceu/polish/Ce_fixed/annotation/masked/*softmasked.fa .
cd ../rnaseq
bampath=$(pwd)/
cd ..


#set paths
cp -r /data/programs/Augustus_v3.3.3/config/ $(pwd)/augustus_config
export AUGUSTUS_CONFIG_PATH=$(pwd)/augustus_config
# now set paths to the other tools
export PATH=/data/programs/BRAKER2_v2.1.5/scripts//:$PATH
export AUGUSTUS_BIN_PATH=/data/programs/Augustus_v3.3.3/bin
export AUGUSTUS_SCRIPTS_PATH=/data/programs/Augustus_v3.3.3/scripts
export DIAMOND_PATH=/data/programs/diamond_v0.9.24/
export GENEMARK_PATH=/data/programs/gmes_linux_64.4.61_lic/
export BAMTOOLS_PATH=/data/programs/bamtools-2.5.1/bin/
export PROTHINT_PATH=/data/programs/ProtHint/bin/
export ALIGNMENT_TOOL_PATH=/data/programs/gth-1.7.0-Linux_x86_64-64bit/bin
export SAMTOOLS_PATH=/data/programs/samtools-1.10/
export MAKEHUB_PATH=/data/programs/MakeHub/

# RUN

cd $basepath && mkdir rna_prot && cd rna_prot
rna_prot=$(pwd)
# NGM
genome=Ce_fixed_NGM_polish_masked.fasta.softmasked.fa
bamfile=${bampath}Ce_fixed_NGM_polish_masked_merged.sorted.bam
mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --softmasking --etpmode --cores=40 --gff3
genome=Ce_fixed_NGM_polish.fa
cd $rna_prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --etpmode --cores=40 --gff3

# BWAmem
genome=Ce_fixed_BWA_polish.softmasked.fa
bamfile=${bampath}Ce_fixed_BWA_polish_merged.sorted.bam

cd $rna_prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --softmasking --etpmode --cores=40 --gff3
genome=Ce_fixed_BWA_polish.fa
cd $rna_prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --etpmode --cores=40 --gff3

# SNAP
#genome=Ce_fixed_SNAP_polish_masked.fasta.softmasked.fa
bamfile=${bampath}Ce_fixed_SNAP_polish_masked_merged.sorted.bam
#cd $rna_prot && mkdir ${genome%.fa} && cd ${genome%.fa}
#braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --softmasking --etpmode --cores=40 --gff3
genome=Ce_fixed_SNAP_polish.fa
cd $rna_prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --etpmode --cores=40 --gff3

# original
genome=Ce_fixed_softmasked.softmasked.fa
bamfile=${bampath}Ce_fixed_softmasked_merged.sorted.bam
cd $rna_prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --softmasking --etpmode --cores=40 --gff3
genome=Ce_fixed.fa
cd $rna_prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rnaprot --genome=${genomepath}$genome --prot_seq=$proteins --bam=$bamfile --etpmode --cores=40 --gff3


# RNA

cd $basepath && mkdir rna && cd rna
rna=$(pwd)
# NGM
genome=Ce_fixed_NGM_polish_masked.fasta.softmasked.fa
bamfile=${bampath}Ce_fixed_NGM_polish_masked_merged.sorted.bam
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3 --softmasking
genome=Ce_fixed_NGM_polish.fa
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3
# BWAmem
genome=Ce_fixed_BWA_polish.softmasked.fa
bamfile=${bampath}Ce_fixed_BWA_polish_merged.sorted.bam
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3 --softmasking
genome=Ce_fixed_BWA_polish.fa
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3

# SNAP
genome=Ce_fixed_SNAP_polish_masked.fasta.softmasked.fa
bamfile=${bampath}Ce_fixed_SNAP_polish_masked_merged.sorted.bam
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3 --softmasking
genome=Ce_fixed_SNAP_polish.fa
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3

# original
genome=Ce_fixed_softmasked.softmasked.fa
bamfile=${bampath}Ce_fixed_softmasked_merged.sorted.bam
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3 --softmasking
genome=Ce_fixed.fa
cd $rna && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_rna --genome=${genomepath}$genome --bam=$bamfile --cores=40 --gff3

# restart
braker.pl --genome=../genome.fa --hints=$oldDir/hintsfile.gff --skipAllTraining --species=$species --etpmode --softmasking --workingdir=$wd --cores 8




# only proteins
cd $basepath && mkdir prot && cd prot
prot=$(pwd)
# NGM
genome=Ce_fixed_NGM_polish_masked.fasta.softmasked.fa
bamfile=${bampath}Ce_fixed_NGM_polish_masked_merged.sorted.bam
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3 --softmasking
genome=Ce_fixed_NGM_polish.fa
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3

# BWAmem
genome=Ce_fixed_BWA_polish.softmasked.fa
bamfile=${bampath}Ce_fixed_BWA_polish_merged.sorted.bam

cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3 --softmasking
genome=Ce_fixed_BWA_polish.fa
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3

# SNAP
genome=Ce_fixed_SNAP_polish_masked.fasta.softmasked.fa
bamfile=${bampath}Ce_fixed_SNAP_polish_masked_merged.sorted.bam
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3 --softmasking
genome=Ce_fixed_SNAP_polish.fa
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3

# original
genome=Ce_fixed_softmasked.softmasked.fa
bamfile=${bampath}Ce_fixed_softmasked_merged.sorted.bam
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3 --softmasking
genome=Ce_fixed.fa
cd $prot && mkdir ${genome%.fa} && cd ${genome%.fa}
braker.pl --species=${genome%.fa}_prot --genome=genome.fa --prot_seq=$proteins --cores=40 --gff3
