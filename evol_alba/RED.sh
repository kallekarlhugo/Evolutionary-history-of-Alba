# the raw tool is kind of stupid, so:
# make a new directory called raw, and one called masked
mkdir raw && mkdir masked
# put a softlink to genomes you want to mask in the raw directory, make sure genome ends with .fa (not .fasta)
cd raw && ln -s ../polish/Ce_fixed/NGM_pilon/Ce_fixed_NGM_polish.fasta Ce_fixed_NGM_polish.fa && cd ..
# run RED in default
/mnt/griffin/kaltun/software/redUnix64/Red -gnm raw -msk masked -rpt masked

# to calculate % repeat masked genes use the .rpt file in the masked directory
cd masked
head Ce_fixed_NGM_polish.rpt
# >Sc0000000_pilon:5477-5509
# >Sc0000000_pilon:5922-5963
# >Sc0000000_pilon:7435-7607
# >Sc0000000_pilon:9339-9468

# calculate number of masked bases:
sed 's/:/\t/g' Ce_fixed_NGM_polish.rpt | cut -f2 | sed 's/-/\t/g'| awk '{ $3 = $2 - $1 } 1'| awk '{s+=$3}END{print s}'
