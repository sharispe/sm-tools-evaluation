#!/usr/bin/Rscript
# Script used to compute semantic measures using GOSim Library
# Script Version 0.1

args = commandArgs(trailingOnly = TRUE)

if(length(args) != 3){
	cat("Script used to compute semantic measures scores using GOSim library\n")
	cat("USAGE: \n")
	cat("  [0] Input file, TSV one entry per line\n")
	cat("  [1] Type of Test T2T or GP2GP for Term to Term and Gene Product to Gene Product comparisons respectively, T2T are computed using Lin Measure, GP2GP are computed using Lin + Max aggregation \n")
	cat("  [2] output file\n")
	quit()
}

cat("TEST: GOSim\n")

input    = args[1]
testType = args[2]
output   = args[3]


cat("INPUT: ",input,"\n")
cat("TYPE : ",testType,"\n")
cat("OUTPUT: ",output,"\n")

if(testType != "T2T" && testType != "GP2GP"){
	cat("Please select Term to Term comparison (T2T) or Gene Product To Gene Product Comparison (GP2GP)")
	quit()
}

pairwise = FALSE

if(testType == "T2T"){
	pairwise = TRUE
}

library("GOSim")
cat("Processing...")
conn = file(input, "r")
sink(file = output, append = FALSE, type = c("output", "message"),split = FALSE)



e1 = NULL
e2 = NULL
mat = NULL

while(length(line <- readLines(conn, 1)) > 0) {

    splt <- strsplit(line, "\t")
    e1 <- splt[[1]][1]
    e2 <- splt[[1]][2]


    #cat(e1,"\t",e2,"\n")
    
    # We only need to compute a single semantic similarity.
    # However, getTermSim and getGeneSim compute the whole matrix which can lead to 
    # a serious disadvantage in term of running time
    if(pairwise){
    	mat <- getTermSim(c(e1,e2),method="Lin",verbose=FALSE)
    }
    else{
    	mat <- getGeneSim(c(e1,e2),similarity="max",similarityTerm="Lin",verbose=FALSE)
    }

    cat(e1,"\t",e2,"\t",mat[[2]],"\n")
    
}

close(conn)
sink()

cat("Finished, consult: ",output,"\n")
