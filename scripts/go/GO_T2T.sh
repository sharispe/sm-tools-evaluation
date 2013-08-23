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
memory_limit=4000000  # ulimit -v 1Go=1000000 negative value or 0 = no constraints


gosim=${home_dir}/scripts/go/GOSimWrapper.R
gosemsim=${home_dir}/scripts/go/GOSemSimWrapper.R

annot=${home_dir}/resources/data/go/annot/dump_orgHsegGO.tsv
annot_sml=${home_dir}//resources/data/go/annot/dump_orgHsegGO_sml.tsv
goXML=${home_dir}//resources/data/go/onto/go_20130302-termdb.obo-xml
goOWL=${home_dir}//resources/data/go/onto/go_20130302-termdb.owl



prefix_benchmark=${home_dir}/resources/data/go/benchmarks/benchmark_

benchmark_sizes=(1000)
benchmark_sizes=(1000 10000 100000 100000000)

mkdir -p ${result_dir}

# We first generate the limit command
ulimit_cmd=''

echo "sm-tools benchmark"
echo "result_dir: "${result_dir}
echo "home_dir: "${home_dir}
echo "Timeout: "${timeout_limit}
echo "Memory : "${memory_limit}

if [[ ${timeout_limit} -gt 0 ]]; then
	ulimit_cmd=${ulimit_cmd}" -t "${timeout_limit}
fi

if [[ ${memory_limit} -gt 0 ]]; then
	ulimit_cmd=${ulimit_cmd}" -v "${memory_limit}
fi

if [[ ${#ulimit_cmd} -ne 0 ]]; then
	ulimit_cmd="ulimit "${ulimit_cmd}
fi


for bsize in ${benchmark_sizes[@]};
	do
		echo "************************************************************";	
		echo "***   Benchmark ${bsize}K   ";
		echo "************************************************************";
		echo "************************************************************";

#<<COMMENT1
		# FastSemSim
		echo "********************";
		echo "********************";
		echo "***   FastSemSim   ";
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
						CMD="${fastsemsim} --go ${goXML}  --ac ${annot}  --actype plain --acsep t --multiple -c BP --GOTerms --pairs  --query ${prefix_benchmark}${bsize}_${i}.tsv  --semsim Resnik  -o ${result_dir}/r_${bsize}_fss_${i}_${j}.tsv"
						echo "CMD: ${CMD}"
						status_flag=0
						(
							${ulimit_cmd} 
							time ${CMD}; 
							status_flag=$?
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
						echo "*** *** *** ***"
					done
			done

		# SML-Toolkit
		echo "********************";
		echo "********************";
		echo "***   SML-Toolkit   ";
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
						CMD="java -jar ${sml} -t sm -profile GO -quiet -mtype p -pm resnik -ic resnik -go ${goOWL} -goformat OWL -annots ${annot_sml} -annotsFormat TSV -queries ${prefix_benchmark}${bsize}_${i}.tsv  -output ${result_dir}/r_${bsize}_sml_${i}_${j}.tsv"
						echo "CMD: ${CMD}"
						status_flag=0
						(
							${ulimit_cmd} 
							time ${CMD}; 
							status_flag=$?
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
						echo "*** *** *** ***"
					done
			done

#COMMENT1

		if [ ${bsize} -ne 100000000 ]; then # This test is too large for them

			# GOSim
			echo "********************";
			echo "********************";
			echo "***   GOSim   ";
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
							CMD="${gosim} ${prefix_benchmark}${bsize}_${i}.tsv T2T ${result_dir}/r_${bsize}_gosim_${i}_${j}.tsv"
							echo "CMD: ${CMD}"
							status_flag=0
							(
								${ulimit_cmd} 
								time ${CMD}; 
								status_flag=$?
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
							echo "*** *** *** ***"
						done
				done

			# GOSemSim
			echo "********************";
			echo "********************";
			echo "***   GOSemSim   ";
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
							CMD="${gosemsim} ${prefix_benchmark}${bsize}_${i}.tsv T2T ${result_dir}/r_${bsize}_gosemsim_${i}_${j}.tsv"
							echo "CMD: ${CMD}"
							status_flag=0
							(
								${ulimit_cmd} 
								time ${CMD}; 
								status_flag=$?
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
							echo "*** *** *** ***"
						done
				done
			fi
	done
