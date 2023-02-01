# call variants on list of bamfiles listed in file called mapped_reads
ref=alba_edited_genome_V2.fa
cut -f1 alba_edited_genome_V2.fa.fai > chromo_list
cat chromo_list | parallel -j 60 "bcftools mpileup -Ou -f $ref -b mapped_reads --annotate FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR -r {} | bcftools call -f GQ,GP -m -Ob -o electo_chl_phic_eury_{}.bcf"

# filter variants with bcftools to remove indels and low quality variants
bcftools view --threads 20 --exclude-types indels -O u -o ${1%bcf}noIndel.bcf $1
bcftools view --threads 20 -i 'QUAL>30 & AVG(FMT/DP)>5 & AVG(FMT/DP)<100' -O z -o ${1%bcf}q20.dp5_100.vcf.gz ${1%bcf}noIndel.bcf

# concatenate all vcf files into one file
bcftools concat -O z -o electo_chl_phic_eury.vcf.gz electo_chl_phic_eury_*.vcf.gz

# run pixy to calculate dxy
pixy --stats dxy \
--vcf electo_chl_phic_eury.vcf.gz \
--populations popmap \
--window_size 10000 \
--n_cores 45 \
--output_folder output_10000 \
--output_prefix electo_chl_phic_eury_10000

# Load data into R and calculate RND

# philodice eurytheme

library(tidyverse)
e10k <- fread("electo_chl_phic_eury_10000.txt") %>% unite(pair, pop1:pop2, sep = "_", remove = F) 

# extract pairs to use for next step
e10k %>% select(pair) %>% unique()
# pair
# 1:  Eury_Ccro
# 2: Eury_Cphil
# 3: Cphil_Ccro

# extract data for each pair
Eury_Ccro <- e10k %>% filter(pair=="Eury_Ccro") %>% select(pair, pop1, pop2, chromosome, window_pos_1, window_pos_2, avg_dxy)
Eury_Cphil <- e10k %>% filter(pair=="Eury_Cphil") %>% select(pair, pop1, pop2, chromosome, window_pos_1, window_pos_2, avg_dxy)
Cphil_Ccro <- e10k %>% filter(pair=="Cphil_Ccro") %>% select(pair, pop1, pop2, chromosome, window_pos_1, window_pos_2, avg_dxy)

# rejoin data and create individual columns for the dxy of each pair
# create RND column and calculate RND, and window mid point, also remove infinite RND values.
eury_phil <- full_join(Eury_Ccro, Eury_Cphil, suffix=c("_Eury_Ccro", "_Eury_Cphil"), by = c( "chromosome", "window_pos_1", "window_pos_2")) %>% 
  full_join(Cphil_Ccro,sufix = c("_Cphil_Ccro"), by = c("chromosome", "window_pos_1", "window_pos_2")) %>% 
  rename(avg_dxy_Cphil_Ccro = avg_dxy) %>% 
  mutate(pos=(window_pos_1+window_pos_2)/2) %>% 
  mutate(RND = avg_dxy_Eury_Cphil / ((avg_dxy_Eury_Ccro + avg_dxy_Cphil_Ccro) / 2)) %>% filter(RND!="Inf")

# calculate lower 5% cutof of RND
q = c(0.05)
eury_phil_quant <- eury_phil %>% 
  #group_by(chromosome) %>% 
  summarize(quant5 = quantile(RND, probs = q[1], na.rm = T))

eury_phil_quant

#filter RND data to only include the chromosome of interest
eury_phil_sc02 <- eury_phil %>% filter(chromosome == "Sc0000002_pilon_alba_edit_V2")


# plot
p_eury_phil <- ggplot()+
  geom_rect(data = sury_phil_sc02, aes(xmin = 6514000, xmax = 6532081, ymin = 0, ymax = Inf), fill = "#e1fde1", col = "#e1fde1") + # add rectangle indicating the large region of unique content in C. eurytheme
  geom_rect(data = sury_phil_sc02, aes(xmin = 6517251, xmax = 6518210, ymin = 0, ymax = Inf), fill = "#f7b9a7", col = "#f7b9a7") + # add rectangle indicating the alba candidate locus
  geom_rect(data = sury_phil_sc02, aes(xmin = 6545184, xmax = 6555044, ymin = 0, ymax = Inf), fill = "blue", col = "blue") + # add rectangle indicating the BarH1 gene region.
  geom_hline(yintercept = c(0.258175), col = "black", linetype = "dashed") + # add horizontal line indicating the 5% quantile of RND
  geom_line(data=sury_phil_sc02, aes(pos, RND), col="black")+
  facet_zoom(xlim = c(6400000, 6700000), horizontal = F)+
  theme(panel.background = element_blank()) +
  theme(axis.line = element_line(colour = "grey20"))+
  theme(strip.background = element_rect(fill = alpha("white", 0),linetype = 1, colour = "grey20"))+
  xlab("Position")+
  ylab("RND/10kbp")+ 
  theme(axis.text.x = element_text(color="grey20"), axis.text.y = element_text(color="grey20"), axis.ticks = element_line(color="grey20"))+
  scale_x_continuous(labels = label_comma())

ggsave(p_eury_phil, filename = "p_p_eury_phil_rnd_10k.pdf", height = 4, width = 7)
