#!/bin/bash
# this script is to run 'run_fastp_clarkl_clark_and_summarize_results_test.sh' linearly to generate contamination stats for every sample

sample_names=../../../data/sample_name.txt   # path to the file containing the sample names (old version)
script_runclark=run_fastp_clarkl_clark_and_summarize_results_clarkonly.sh    # path to the script to run contamination check, given the sample name
log=run_linear_droso_clark.log

# run contamination check for all samples in parallel
echo -e "### Contamination check starts at $(date) ###\n" >> $log

for sample in $(cat $sample_names | tr '\t' '\n')
do
    bash $script_runclark $sample >> $log 2>&1
done

echo -e "### Contamination check ends at $(date) ###\n" >> $log