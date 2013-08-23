#!/bin/bash

# Global vars
sml=~/dev/java/workspace/sml-tools-evaluation/resources/tools/sml-toolkit-0.7-beta.jar
fastsemsim=~/tools/semantic-measures/fastSemSim-0.7.1/fastSemSim.sh
gosim=./GOSimWrapper.R
gosemsim=./GOSemSimWrapper.R

annot=../../resources/data/go/annot/dump_orgHsegGO.tsv
annot_sml=../../resources/data/go/annot/dump_orgHsegGO_sml.tsv
goXML=../../resources/data/go/onto/go_20130302-termdb.obo-xml
goOWL=../../resources/data/go/onto/go_20130302-termdb.owl

prefix_benchmark=../../resources/data/go/benchmarks/benchmark_


echo "************************************************************";
echo "*****************   Benchmark 1K   *************************";
echo "************************************************************";


# FastSemSim
for i in {0..2};
	do
		echo "${fastsemsim} --go ${goXML}  --ac ${annot}  --actype plain --acsep t --multiple -c BP --pairs  --query ${prefix_benchmark}1000000_${i}.tsv  --semsim Lin  -o /tmp/r_1K_fss_${i}.tsv"
		time ${fastsemsim} --go ${goXML}  --ac ${annot}  --actype plain --acsep t --multiple -c BP --GOTerms --pairs  --query ${prefix_benchmark}1000000_${i}.tsv  --semsim Resnik  -o /tmp/r_100K_fss_${i}.tsv
	done


# SML-Toolkit
for i in {0..2};
	do
		echo "java -jar ${sml} -t sm -profile GO -quiet -mtype p -pm lin -ic resnik -go ${goOWL} -goformat OWL -annots ${annot_sml} -annotsFormat TSV -queries ${prefix_benchmark}1000000${i}.tsv  -output /tmp/r_1K_fss_${i}.tsv"
		time java -jar ${sml} -t sm -profile GO -quiet -mtype p -pm resnik -ic resnik -go ${goOWL} -goformat OWL -annots ${annot_sml} -annotsFormat TSV -queries ${prefix_benchmark}1000000_${i}.tsv  -output /tmp/r_100K_fss_${i}.tsv
	done

exit
# GOSIM
for i in {0..2};
	do	
		echo "CMD: ${gosim} ${prefix_benchmark}1000_${i}.tsv T2T /tmp/r_1K_gosim_${i}.tsv" 
		time ${gosim} ${prefix_benchmark}1000_${i}.tsv T2T /tmp/r_1K_gosim_${i}.tsv 
	done

# GOSEMSIM
for i in {0..2};
	do	
		echo "CMD: ${gosemsim} ${prefix_benchmark}1000_${i}.tsv T2T /tmp/r_1K_gosemsim_${i}.tsv" 
		time ${gosemsim} ${prefix_benchmark}1000_${i}.tsv T2T /tmp/r_1K_gosemsim_${i}.tsv 
	done

echo "************************************************************";
echo "*****************   Benchmark 1K   *************************";
echo "************************************************************";
