
for sample in `ls ./*.ctq20.fq`
do
base=$(basename $sample "_1.ctq20.fq")
/data/programs/NextGenMap-0.4.12/bin/ngm-0.4.12/ngm -r "$reference" -1 ${base}_1.ctq20.fq -2 ${base}_2.ctq20.fq -t 64 -p -b -o ${base}Ce_fixed_NGM.bam
done

/data/programs/sambamba_0.6.7/sambamba sort -t 12 Colias_eurytheme.USA.12.Tracy_California.Field_Orange.NA.1Ce_fixed_NGM.bam
/data/programs/samtools-1.7/samtools flagstat Colias_eurytheme.USA.12.Tracy_California.Field_Orange.NA.1Ce_fixed_NGM.sorted.bam

166848246 + 0 in total (QC-passed reads + QC-failed reads)
0 + 0 secondary
0 + 0 supplementary
0 + 0 duplicates
152779373 + 0 mapped (91.57% : N/A)
166848246 + 0 paired in sequencing
83424123 + 0 read1
83424123 + 0 read2
117087880 + 0 properly paired (70.18% : N/A)
144423772 + 0 with itself and mate mapped
8355601 + 0 singletons (5.01% : N/A)
23709822 + 0 with mate mapped to a different chr
10481777 + 0 with mate mapped to a different chr (mapQ>=5)


## Run Qualimap on all the samples in multi-sample Bam QC mode
/mnt/griffin/kaltun/qualimap_v2.2.1

## BWAmem has the highest number of mapped reads so we will use that for the polish first. but also try the other ones.
genome=Ce_fixed.fa
CEbam=Colias_eurytheme.USA.12.Tracy_California.Field_Orange.BWAmem_Ce_fixed_sorted.sorted.bam
java -ea -Xmx200g -jar /mnt/griffin/chrwhe/software/pilon-1.22.jar --genome $genome --frags $CEbam --threads 30 --outdir BWAmem_pilon --tracks --vcf --changes --diploid --output Ce_fixed_BWA_polish

# -------------------------------
#     AssemblyQC Result
# -------------------------------
# Contigs Generated :          108
# Maximum Contig Length : 13,016,459
# Minimum Contig Length :   38,225
# Average Contig Length : 3,029,319.2 ± 2,876,376.5
# Median Contig Length :  2,351,987.5
# Total Contigs Length :  327,166,473
# Total Number of Non-ATGC Characters :          1
# Percentage of Non-ATGC Characters :        0.000
# Contigs >= 100 bp :          108
# Contigs >= 200 bp :          108
# Contigs >= 500 bp :          108
# Contigs >= 1 Kbp :           108
# Contigs >= 10 Kbp :          108
# Contigs >= 1 Mbp :            81
# N50 value :     5,205,174
# Generated using /mnt/griffin/kaltun/ceu/polish/Ce_fixed/BWAmem_pilon/Ce_fixed_BWA_polish.fasta

## followed by NGM
genome=Ce_fixed.fa
CEbam=Colias_eurytheme.USA.12.Tracy_California.Field_Orange.NA.1Ce_fixed_NGM.sorted.bam
java -ea -Xmx200g -jar /mnt/griffin/chrwhe/software/pilon-1.22.jar --genome $genome --frags $CEbam --threads 30 --outdir NGM_pilon --tracks --vcf --changes --diploid --output Ce_fixed_NGM_polish

# -------------------------------
#     AssemblyQC Result
# -------------------------------
# Contigs Generated :          108
# Maximum Contig Length : 13,039,366
# Minimum Contig Length :   38,228
# Average Contig Length : 3,034,048.2 ± 2,881,342.9
# Median Contig Length :  2,352,411.0
# Total Contigs Length :  327,677,205
# Total Number of Non-ATGC Characters :          6
# Percentage of Non-ATGC Characters :        0.000
# Contigs >= 100 bp :          108
# Contigs >= 200 bp :          108
# Contigs >= 500 bp :          108
# Contigs >= 1 Kbp :           108
# Contigs >= 10 Kbp :          108
# Contigs >= 1 Mbp :            81
# N50 value :     5,210,223
# Generated using /mnt/griffin/kaltun/ceu/polish/Ce_fixed/NGM_pilon/Ce_fixed_NGM_polish.fasta
