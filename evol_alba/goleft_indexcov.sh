# make list containing bamfiles of interest
ls *sorted.bam > sorted.list

#rename output as you want
output=coverage_goleft

#run command
bamfiles=$(tr '\n' ' ' <  sorted.list)
/mnt/griffin/kaltun/software/goleft_linux64 indexcov -d $output $bamfiles
