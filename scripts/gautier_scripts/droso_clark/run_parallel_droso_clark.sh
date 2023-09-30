#!/bin/bash
# this script is to run 'run_fastp_clarkl_clark_and_summarize_results_test.sh' to generate contamination stats for every sample

sample_names=../../..//data/sample_name.txt   # path to the file containing the sample names (old version)
script_runclark=run_fastp_clarkl_clark_and_summarize_results_test.sh    # path to the script to run contamination check, given the sample name
log=run_parallel_droso_clark.log

# run contamination check for all samples in parallel
echo -e "### Contamination check starts at $(date) ###\n" >> $log

{ time cat $sample_names \
| tr '\t' '\n' \
| parallel --no-notice -j 0 --memfree 200G \
bash $script_runclark {} 1>> $log ;} 2>> $log

echo -e "### Contamination check ends at $(date) ###\n" >> $log