#!/bin/bash
#SBATCH -p workq
#SBATCH --mem=56G #160G to build kmer dictionary
#SBATCH --export=ALL

fastp=/home/siyuan/biosoft/miniconda3/envs/check_sp_contaminant/bin/fastp
clark=/home/siyuan/biosoft/miniconda3/envs/check_sp_contaminant/bin/CLARK
clarkl=/home/siyuan/biosoft/miniconda3/envs/check_sp_contaminant/bin/CLARK-l
parseclarkcsv=summary_csv.awk #summary_csv.awk

dirfq=../../../data #assumed to be coded as ${id}.fq_1.gz and ${id}.fq_2.gz for read1 and read2 data
id=$1 #ID prefix to provide when launching the shel script

mkdir -p res_clarkl #create a directory named res_clarkl (if it doesn't exist) to store calrkl result
mkdir -p res_clark  #create a directory named res_clark (if it doesn't exist) to store calrk result

# Check if the analysis has already been done for this sample, and skip the analysis if it has.
if [ ! -e "res_clark/$id.csv.gz" ]; then
  date

  ####################
  #cleanning seqeunce: stdout option to obtain interleaved format further transformed into fasta using awk one liner
  ####################

  $fastp -i $dirfq"/"$id'.fq_1.gz' -I $dirfq"/"$id'.fq_2.gz' --stdout --merge --include_unmerged -h $id'.html' -j $id'.json' | awk '{if(NR%4==2){nn++;{print ">s"nn"\n"$0}}}' - > $dirfq"/"$id'.fasta'

  date

  # ######################
  # ##CLARK-l analysis
  # ####################

  # $clarkl -T target_clean.txt -D ./droso_clean_db -O $dirfq"/"$id'.fasta' -R $id -n 1 -m 0 -s 2

  # date

  # mv ${id}.csv res_clarkl/


  ######################
  ##CLARK analysis
  ####################

  $clark -T target_clean.txt -D ./droso_clean_db -O $dirfq"/"$id'.fasta' -R $id -n 16 -m 0 -s 2

  date

  mv ${id}.csv res_clark/

  rm $dirfq"/"$id'.fasta'

  ###########
  ###summarize statistics (using awk script)
  ############

  nkmin='1 5'
  conf='0.9 0.95'
  # resdir='res_clark/ res_clarkl/'
  resdir='res_clark/'

  for dd in $resdir
  do
  cd ./${dd}
  for ii in $nkmin
    do
    for jj in $conf
    do
      gawk -f $parseclarkcsv -v nmin_kmer=$ii -v conf_thr=$jj $id.csv > $id"_nkmin"$ii"_conf"$jj".summary"
    done
  done
  gzip ${id}.csv
  cd ../
  done

  date
else
    echo "Skipping because analysis for $sample already exists."
fi