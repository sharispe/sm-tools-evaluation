#!/bin/bash

# ./scripts/go/GO_T2T.sh 2>&1 | tee /tmp/output_go_benchmark.log
# grep "\*\|user\|real" /tmp/output_go_benchmark.log  > /tmp/output_go_benchmark.log.reduce
# cat /tmp/output_go_benchmark.log.reduce

# Global vars
sml=~/dev/java/workspace/sml-tools-evaluation/resources/tools/sml-toolkit-0.7-beta.jar
fastsemsim=~/tools/semantic-measures/fastSemSim-0.7.1/fastSemSim.sh

# set the home directory, i.e. the project root directory & the result directory result_dir
result_dir=/tmp/sml-tools-evaluation/go
home_dir=/home/seb/dev/java/workspace/sml-tools-evaluation
timeout_limit=7200 # ulimit -t timeout in second, negative value or 0 = no constraints
memory_limit_mo=6000 # memory limit in Mo
  # ulimit -v 1Go=1000000 negative value or 0 = no constraints
remove_output=1 # set to 1 all output files will be removed



gosim=${home_dir}/scripts/go/GOSimWrapper.R
gosemsim=${home_dir}/scripts/go/GOSemSimWrapper.R

annot=${home_dir}/resources/data/go/annot/dump_orgHsegGO.tsv
annot_sml=${home_dir}//resources/data/go/annot/dump_orgHsegGO_sml.tsv
goXML=${home_dir}//resources/data/go/onto/go_20130302-termdb.obo-xml
goOWL=${home_dir}//resources/data/go/onto/go_20130302-termdb.owl



prefix_benchmark=${home_dir}/resources/data/go/benchmarks/benchmark_pairwise_

benchmark_sizes=(1000)
#benchmark_sizes=(1000 100000000 1000000 10000)

mkdir -p ${result_dir}

memory_limit=$(($memory_limit_mo * 1024))


# We first generate the limit command
ulimit_cmd=''

echo "sm-tools benchmark"
echo "result_dir    : "${result_dir}
echo "home_dir      : "${home_dir}
echo "Timeout       : "${timeout_limit}
echo "Memory        : "${memory_limit}
echo "Remove output : "${remove_output}

if [[ ${timeout_limit} -gt 0 ]]; then
	ulimit_cmd=${ulimit_cmd}" -t "${timeout_limit}
fi

if [[ ${memory_limit} -gt 0 ]]; then
	ulimit_cmd=${ulimit_cmd}" -v "${memory_limit}
fi

if [[ ${#ulimit_cmd} -ne 0 ]]; then
	ulimit_cmd="ulimit "${ulimit_cmd}
fi

getCommandLine () {

	local cmd=""
	local appname=$1
	local qfile=$2
	local outfile=$3
	#echo "Get cmd for ${appname}"
	if [[ ${appname} == "FastSemSim" ]]; then
		cmd="${fastsemsim} --go ${goXML}  --ac ${annot}  --actype plain --acsep t --multiple -c BP --GOTerms --pairs  --semsim Lin --query ${qfile}  -o ${outfile}"
	
	elif [[ ${appname} == "SML" ]]; then
		cmd="java -Xmx"${memory_limit_mo}"m -jar ${sml} -t sm -profile GO -quiet -mtype p -pm lin -ic resnik -go ${goOWL} -goformat OWL -annots ${annot_sml} -annotsFormat TSV -queries ${qfile}  -output ${outfile}"

	elif [[ ${appname} == "SML_parallel" ]]; then
		cmd="java -Xmx"${memory_limit_mo}"m -jar ${sml} -t sm -profile GO -threads 4 -quiet -mtype p -pm lin -ic resnik -go ${goOWL} -goformat OWL -annots ${annot_sml} -annotsFormat TSV -queries ${qfile}  -output ${outfile}"

	elif [[ ${appname} == "GOSim" ]]; then
		cmd="${gosim} ${qfile} T2T ${outfile}"

	elif [[ ${appname} == "GOSemSim" ]]; then
		cmd="${gosemsim} ${qfile} T2T ${outfile}"
	else
		echo "No cmd associated to ${appname}"
		exit
	fi
	
	echo ${cmd}
}

xtool () { 

		local appname=$1
		local bsize=$2

		echo "********************";
		echo "********************";
		echo "***   ${appname}   ";
		echo "********************";
		echo "********************";

		for i in {0..2};
			do
				echo "*-------------------";
				echo "***   Run   "${i};
				echo "*-------------------";

				for j in {0..2};
					do
						echo "*** Run   ${i}.${j}";
						
						local query_file="${prefix_benchmark}${bsize}_${i}.tsv"
						local output_file="${result_dir}/r_${bsize}_${appname}_${i}_${j}.tsv"

						local CMD=$(getCommandLine ${appname} ${query_file} ${output_file})
						echo "CMD: ${CMD}"

						local status_flag=0
						(
							# for java program the limitation is set using -Xmx
							# There is a strange behaviour using both  
							if [ ${appname} != "SML"  ] && [ ${appname} != "SML_parallel"  ]; then
								${ulimit_cmd}
								echo ${ulimit_cmd}
							elif [[ ${timeout_limit} -gt 0 ]]; then
								echo "ulimit -t "${timeout_limit}
							fi 

							time ${CMD}; 
							local status_flag=$?
							echo "*** status: ${status_flag}"
							if [ ${status_flag} -ne 0 ]; then
		    					echo "*** Error: an error occurred or memory or CPU limits have been reached"
		    					if [ ${status_flag} -eq 127 ]; then
		    						echo "*** Out of memory limit: "${memory_limit}
		    					elif [ ${status_flag} -eq 137 ]; then
		    						echo "*** Timout limit: "${timeout_limit}" sec"
		    					fi
		    				else
		    					echo "*** seems ok"
							fi
						)
						if [ ${remove_output} -eq 1 ]; then
							echo "Remove: "${output_file}
							rm ${output_file}
						fi
						echo "*** *** *** ***"
					done
			done
}


for bsize in ${benchmark_sizes[@]};
	do
		echo "************************************************************";	
		echo "***   Benchmark ${bsize}K   ";
		echo "************************************************************";
		echo "************************************************************";

		# FastSemSim
		xtool FastSemSim ${bsize}
		
		# SML-Toolkit
		xtool SML ${bsize}
		
		# SML-Toolkit multiThreads
		xtool SML_parallel ${bsize}
		

		if [ ${bsize} -lt 1000000 ]; then # These tests are too large for them

			echo ""
			# GOSemSim
			#xtool GOSim ${bsize}
		
			# GOSemSim
			#xtool GOSemSim ${bsize}
		fi
	done
