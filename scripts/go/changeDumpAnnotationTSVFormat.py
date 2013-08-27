#!/usr/bin/python

"""
Dummy Code used to change the TSV annotation format for 
GENE_ID [TAB] ANNOT_1 [TAB] ANNOT_2
to
GENE_ID [TAB] ANNOT_1;ANNOT_2...
"""
infile="../../resources/data/go/annot/dump_orgHsegGO.tsv"
outfile="../../resources/data/go/annot/dump_orgHsegGO_sml.tsv"

print "infile="+infile

f = open(outfile,'w')
for line in open(infile,'r'):
    data = line.strip().split("\t")
    
    #f.write(data.pop(0)+"\t"+(';'.join(["GO:GO_"+x.split(":")[1] for x in data]))+"\n")
    f.write(data.pop(0)+"\t"+(';'.join(data))+"\n")
f.close()

print "outfile="+outfile