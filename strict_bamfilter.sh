#strict filtering of multispecies bam file for phylogenetic analysis of non coding regions

#make folder for results
mkdir strict_multispecies_alignments && cd strict_multispecies_alignments
# add symlinkes to raw files
ln -s /mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/*sorted.rg.bam* .
ln -s /mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/*TR13*sorted_markdup.rg.bam* .
ln -s /mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/*CATR56*sorted_markdup.rg.bam* .
ln -s /mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/may2020_align/*sort.bam* .

# merge the split C.eur ones
samtools merge -@ 20 Colias_eurytheme.TR13.merged.bam Colias_eurytheme.NA.NA.TR13_Alba.Alba.NA.1_1.sorted_markdup.rg.bam Colias_eurytheme.NA.NA.TR13_Alba.Alba.NA.round2.sorted_markdup.rg.bam &
samtools merge -@ 20 Colias_eurytheme.CATR56.merged.bam Colias_eurytheme.NA.NA.CATR56_Orange.Orange.NA.1_1.sorted_markdup.rg.bam Colias_eurytheme.NA.NA.CATR56_Orange.Orange.NA.round2.sorted_markdup.rg.bam

#sort and index
for i in *merged.bam
do /data/programs/sambamba.0.6.7/sambamba sort -t 20 $i
done

# make list of bamfiles
ls *bai > raw_bam
sed -i 's/.bai//g' raw_bam
# filter bamfiles to mapQ 40, proper pair, remove unmapped, un paired, supplementary or duplicates.
while read p
do samtools view -F 3852 -f 3 -q 40 $p -o ${p%bam}q40.pair.prim.bam --write-index &
done < raw_bam

## generate bed of high and low coverage regions
# first generate bed of coverage
for i in *prim.bam
do /data/programs/bedtools2/bin/genomecov -ibam $i -bg > ${i%bam}bedgraph &
done

#filter coverage for high regions
mkdir tmp
for i in *bedgraph
do awk '$4> 100' $i > tmp/${i%bedgraph}min100.bed &
done

#filter for low cov regions
for i in *bedgraph
do awk '$4< 5' $i > tmp/${i%bedgraph}max5.bed &
done

#merge all beds
/mnt/griffin/kaltun/software/bin/bedops -m tmp/*bed > merged_5-100.bed
cat merged_5-100.bed | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}'
217652446
# merge with repeat regions
ln -s /mnt/griffin/kaltun/ceu/polish/Ce_fixed/annotation/masked/Ce_fixed_NGM_polish_masked.fasta.repeats.bed .
# shift coordinates of repeat bed to account for alba edited genome

/mnt/griffin/kaltun/software/bin/bedops -m merged_5-100.bed Ce_fixed_NGM_polish_masked.fasta.repeats.bed > merged_5-100_repeats.bed
cat merged_5-100_repeats.bed | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}'
300682881

Total Contigs Length :  327,705,992
