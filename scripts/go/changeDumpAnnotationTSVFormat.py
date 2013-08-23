#!/usr/bin/python

"""
Dummy Code used to change the TSV annotation format for 
GENE_ID [TAB] ANNOT_1 [TAB] ANNOT_2
to
GENE_ID [TAB] ANNOT_1;ANNOT_2...
"""
infile="dump_orgHsegGO.tsv"
outfile="dump_orgHsegGO_sml.tsv"

f = open(outfile,'w')
for line in open(infile,'r'):
    data = line.strip().split("\t")
    f.write(str(data.pop(0))+"\t"+(';'.join(data))+"\n")
f.close()
