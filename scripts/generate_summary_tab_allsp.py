# script to generate a summary table of contamination ratio for all post-alignment samples

import re
import xlsxwriter

# file paths and directories
dir_in_tab = 'gautier_scripts/droso_clark/res_clark/{}_nkmin5_conf0.95.summary' # path to input table of conmaination ratio for each sample
dir_in_spname = '../data/rename_dict.txt'   # path to input table of old and new sample names
dir_in_spname_order = '../data/sample_collector_order.txt'    # path to input table of sample names and collectors in order (same as other tables)
out_tab = '../results/summary_tab_allsp.xlsx'


# 0. initialize the output workbook and worksheet
workbook = xlsxwriter.Workbook(out_tab) # create an excel table for all environnmental variable
worksheet = workbook.add_worksheet('Table S2') # create a worksheet for each environmental variable
center_format = workbook.add_format({'align': 'center'}) # set the format for center alignment

row = 0
header_1 = ['Sample name', 'Collector', '%\ of sequences assigned to different Drosophila species (among all the assigned sequences)']
for col in range(len(header_1)):
    worksheet.write(row, col, header_1[col], center_format) # write first header
row += 1

# 1. get sample names
dic_spname = {}
with open(dir_in_spname, 'r') as f:
    for line in f:
        line = line.strip().split('\t')
        dic_spname[line[1]] = line[0]

# 2. get sample names in order, and collectors
spnames_order = []
sp_collectors = {}
with open(dir_in_spname_order, 'r') as f:
    for line in f:
        line = line.strip().split('\t')
        spnames_order.append(line[0])
        sp_collectors[line[0]] = line[1]

# 3. get the contamination ratio for each sample
list_species_start = ['Dsuzu', 'Dsubp', 'Dimmi']  # prioritize these species for the summary table
list_otherspecies = []
list_species_order = []
for sp in spnames_order:
    assign_ratio2species = {}
    with open(dir_in_tab.format(sp), 'r') as f:
        i = 0
        for line in f:
            if i > 0:
                line = line.strip().split('\t')
                species = line[0]   # Drosophila species
                assn_ratio = '{:.2e}'.format(float(line[2])*100) # % of sequences assigned to each Drosophila species (among all the assigned sequences)
                assign_ratio2species[species] = assn_ratio
                if list_otherspecies == []:
                    if not species in list_species_start:
                        list_otherspecies.append(species)
            i += 1

    if list_species_order == []:
        order_otherspecies = sorted(list_otherspecies)
        list_species_order = list_species_start + order_otherspecies    # order of species in the summary table
        ## write the secondary header for the summary table
        for col in range(header_1[:2]):
            worksheet.merge_range(row, col, row - 1, col, header_1[col], center_format)
        for col in range(2, len(list_species_order) + 2):
            worksheet.write(row, col, list_species_order[col], center_format)
        row += 1

    for species in list_species_order:
        colvals = [sp, sp_collectors[sp]] + list(assign_ratio2species[species] for species in list_species_order)
    for col in range(len(colvals)):
        worksheet.write(row, col, colvals[col], center_format)
    row += 1

worksheet.set_column('A:AQ', None, None,{'bestFit': True})  # Set the column width to fit the content
workbook.close()