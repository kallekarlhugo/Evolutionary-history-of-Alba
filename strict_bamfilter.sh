#strict filtering of multispecies bam file for phylogenetic analysis of non coding regions

#make folder for results
mkdir strict_multispecies_alignments && cd strict_multispecies_alignments
# add symlinkes to raw files
ln -s /mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/*sorted.rg.bam* .
ln -s /mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/*TR13*sorted_markdup.rg.bam* .
ln -s /mnt/griffin/kaltun/ceu/bamfiles/alba_edited_genome/*CATR56*sorted_markdup.rg.bam* .

# merge the split C.eur ones
samtools merge -@ 20 Colias_eurytheme.TR13.merged.bam Colias_eurytheme.NA.NA.TR13_Alba.Alba.NA.1_1.sorted_markdup.rg.bam Colias_eurytheme.NA.NA.TR13_Alba.Alba.NA.round2.sorted_markdup.rg.bam &
samtools merge -@ 20 Colias_eurytheme.CATR56.merged.bam Colias_eurytheme.NA.NA.CATR56_Orange.Orange.NA.1_1.sorted_markdup.rg.bam Colias_eurytheme.NA.NA.CATR56_Orange.Orange.NA.round2.sorted_markdup.rg.bam

#sort and index
for i in *merged.bam
do /data/programs/sambamba.0.6.7/sambamba sort -t 20 $i
done

# filter bamfiles to mapQ 40, proper pair, remove unmapped, un paired, supplementary or duplicates.
samtools view -F 3852 -f 3 -q 40 $p -o ${p%bam}q40.pair.prim
