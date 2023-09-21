#!/bin/bash

sample=$1   # sample name
path_data=../data    # path to the data directory

# # download the tar.zip archive containing the realigned bam from CHTC (annotated because CHTC ask for DUO confirmation that is unavailable within the script)
# scp chtcb:/staging/sfeng77/test_pipeline/out/05realign_$sample\.tar.gz $path_data

# extract the realigned bam file from the big tar.zip file using tar
tar_realign=$path_data/05realign_$sample.tar.gz # the tar file containing the realigned bam file
name_bam=$sample\_sort_merge_dedup_indel.bam    # name (assumed also be the path within tar.gz archive) of the bam file to extract
path_bam=$path_data/$name_bam   # path that the bam file is extracted to
tar -xzf $tar_realign -C $path_data $name_bam  # extract the bam file from the tar.gz file

# convert the bam file into paired-end fastq files as an input to fastp
path_bam_highmq=$path_data/highmq_$name_bam   # path of bam file filtered by mapping quality
path_bam_sorted=$path_data/sorted_$name_bam   # path of bam file filtered by mapping quality and sorted by position

out_fq1=$path_data/$sample.fq_1.gz  # path to the output fastq file for one end
out_fq2=$path_data/$sample.fq_2.gz  # path to the output fastq file for the orher end

samtools view --min-MQ 20 $path_bam -b -o $path_bam_highmq  # filter the bam file by mapping quality
samtools collate -o $path_bam_sorted $path_bam_highmq   # sort the bam file by position (to avoid being wrongly considered as singleton)
samtools fastq --threads 16  -1 $out_fq1 -2 $out_fq2 -0 /dev/null -s /dev/null $path_bam_sorted  # convert the filtered and sorted bam file into paired-end fastq files