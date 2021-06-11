# aligníng rna seq
#set paths
PATH=/mnt/griffin/kaltun/software/hisat2-2.2.1/:$PATH
#make list of raw fq files
ls ../raw/*1.fq > fw_list
ls ../raw/*2.fq > rw_list
#make sym link to references
ln -s ../../assemblies/*softmasked.fa .

#align
for i in *fa
do reference=$i
hisat2-build -p 40 $reference ${reference%.fa}
hisat2 -p 40 --sensitive --rna-strandness R -x ${reference%.fa} \
-U SRR6818639.fastq,SRR6818640.fastq,SRR6818642.fastq,SRR6818649.fastq,SRR6818650.fastq,SRR6818677.fastq,SRR6818678.fastq,SRR6818679.fastq,SRR6818680.fastq,SRR6818681.fastq,SRR6818682.fastq,SRR6818683.fastq,SRR6818684.fastq,SRR6818686.fastq,SRR6818687.fastq \
--summary-file ${reference%fa}_SE.stats \
--no-unal | samtools view -F4 -Sb - -o ${reference%fa}_SE.bam
done

#align
for i in *fa
do reference=$i
# hisat2-build -p 40 $reference ${reference%.fa}
hisat2 -p 40 --sensitive --rna-strandness RF -x ${reference%.fa} \
-1 SRR6818651_1.fastq,SRR6818652_1.fastq \
-2 SRR6818651_2.fastq,SRR6818652_2.fastq \
--summary-file ${reference%fa}_PE.stats \
--no-unal | samtools view -F4 -Sb - -o ${reference%fa}_PE.bam
done

# merge
samtools merge -O BAM -@ 8 Ce_fixed_BWA_polish_merged.bam Ce_fixed_BWA_polish.softmasked._PE.bam Ce_fixed_BWA_polish.softmasked._SE.bam &
samtools merge -O BAM -@ 8 Ce_fixed_NGM_polish_masked_merged.bam Ce_fixed_NGM_polish_masked.fasta.softmasked._PE.bam Ce_fixed_NGM_polish_masked.fasta.softmasked._SE.bam &
samtools merge -O BAM -@ 8 Ce_fixed_SNAP_polish_masked_merged.bam Ce_fixed_SNAP_polish_masked.fasta.softmasked._PE.bam Ce_fixed_SNAP_polish_masked.fasta.softmasked._SE.bam &
samtools merge -O BAM -@ 8 Ce_fixed_softmasked_merged.bam Ce_fixed_softmasked.softmasked._PE.bam Ce_fixed_softmasked.softmasked._SE.bam

# sort and index
for i in *merged.bam
do /mnt/griffin/kaltun/software/sambamba sort -t 20 $i
done
