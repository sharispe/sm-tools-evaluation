#!/usr/bin/Rscript
# Script used to extract the annotations from the package org.HS.eg.db
library(org.Hs.eg.db)

trim <- function(x) gsub("^[[:space:]]+|[[:space:]]+$", "", x) 

x <- org.Hs.egGO

outfile = "dump_orgHsegGO.tsv"

# Get the entrez gene identifiers that are mapped to a GO ID
mapped_genes <- mappedkeys(x)
cat("Processing org.Hs.egGO dump... ")

sink(file = outfile, append = FALSE, type = c("output", "message"),split = FALSE)

for(i in 1:length(mapped_genes)) {
	geneID = mapped_genes[i]
	geneAnnot = x[[geneID]]
	keysAnnot = mappedkeys(geneAnnot)

	for(j in 1:length(keysAnnot)){
		keysAnnot[j] = trim(keysAnnot[j])
	}
	
	#for(j in 1:length(keysAnnot)) {
		#goid = geneAnnot[[keysAnnot[j]]]["GOID"]
		#onto = geneAnnot[[keysAnnot[j]]]["Ontology"]
		#evidence = geneAnnot[[keysAnnot[j]]]["Evidence"]
	#}
	cat(geneID,"\t",paste(keysAnnot,collapse='\t'),"\n",sep="")
	
	#cat(gene,"\n",)
}


sink()
cat("done, consult ",outfile,"\n")
