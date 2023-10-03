#!/bin/bash

sample_names=../data/sample_name.txt   # path to the file containing the sample names (old version)
script_prepinput=prep_input_for_fastp.sh    # path to the script to prepare input for fastp, given the sample name
log=prep_input_for_fastp.log

# run fastp input prep in parallel
echo -e "### Download of tar.gz files starts at $(date) ###\n" >> $log

{ time cat $sample_names \
| tr '\t' '\n' \
| parallel --no-notice -j 0 --memfree 100G \
bash $script_prepinput {} ;} 2>> $log

echo -e "### Download of tar.gz files ends at $(date) ###\n" >> $log