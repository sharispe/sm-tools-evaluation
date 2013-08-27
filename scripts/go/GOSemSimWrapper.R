#!/usr/bin/Rscript
# Script used to compute semantic measures using GOSemSim Library
# Script Version 0.1

args = commandArgs(trailingOnly = TRUE)

if(length(args) != 3){
	cat("Script used to compute semantic measures scores using GOSim library\n")
	cat("USAGE: \n")
	cat("  [0] Input file, TSV one entry per line\n")
	cat("  [1] Type of Test T2T or G2G for Term to Term and Gene Product to Gene Product comparisons respectively, T2T are computed using Lin Measure, G2G are computed using Lin + Max aggregation \n")
	cat("  [2] output file\n")
	quit()
}

cat("TEST: GOSemSim\n")

input    = args[1]
testType = args[2]
output   = args[3]


cat("INPUT: ",input,"\n")
cat("TYPE : ",testType,"\n")
cat("OUTPUT: ",output,"\n")

if(testType != "T2T" && testType != "G2G"){
	cat("Please select Term to Term comparison (T2T) or Gene Product To Gene Product Comparison (G2G)")
	quit()
}

pairwise = FALSE

if(testType == "T2T"){
	pairwise = TRUE
}

library("GOSemSim")


conn = file(input, "r")
sink(file = output, append = FALSE, type = c("output", "message"),split = FALSE)


e1 = NULL
e2 = NULL
mat = NULL

while(length(line <- readLines(conn, 1)) > 0) {

    
    splt <- strsplit(line, "\t")
    e1 <- splt[[1]][1]
    e2 <- splt[[1]][2]

    if(pairwise){
    	r <- goSim(e1, e2, ont="BP", measure="Lin")
        cat(e1,"\t",e2,"\t",r,"\n")
    }
    else{

    	tryCatch({
            r <- geneSim(e1,e2, ont="BP", organism="human", measure="Lin", combine="MAX")
            cat(e1,"\t",e2,"\t",r[[1]],"\n")
        },
        error = function(e){
            cat(e1,"\t",e2,"\t error:\n")
            print(e)
        })
    }
}

close(conn)
sink()

cat("Finished, consult: ",output,"\n")
