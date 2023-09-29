#!/bin/bash

sample_names=../data/sample_name.txt   # path to the file containing the sample names (old version)
script_prepinput=prep_input_for_fastp.sh    # path to the script to prepare input for fastp, given the sample name

# run fastp input prep in parallel
cat $sample_names \
| tr '\t' '\n' \
| parallel --no-notice -j 0 --memfree 100G \
echo {}
bash $script_prepinput {}