Evaluation of Software for Semantic Measures
==============================================================

This project aims at comparing tools dedicated to semantic measures computation (software, source code libraries).
It has been initiated in order to evaluated the Semantic Measures Library and corresponding Toolkit (http://www.semantic-measures-library.org/), see the competing interest section for more information.
It however doesn't focus on the Semantic Measures Library and includes comparison of several tools which can therefore be useful for (i) end-users who want to select a tool to compute semantic measures, (ii) developers who want to compare their tools.

The project currently focuses on graph-based semantic measures, e.g. measures aiming to assess the similarity of class/concepts/terms defined in an ontology.
As an example, this project do not evaluate tools related to distributional semantic measures.
In addition, a critical aspect is that this project do not aim to criticize tools or denigrate the work made by their developers - we only define a strict evaluation protocol to provide objective metrics which can be used to compare tools.
Keep in mind that tools which do not perform well on the tests we defined may have other benefits not discussed in this evaluation.
Please contact us or fork this repository to help us improve it.

This evaluation doesn't pretend to cover all aspects which could be useful to discuss in order to evaluate software.
We here focus on objective metrics and mainly aim at evaluating the speed of the program given specific resource constraints (memory, computational time).
We only provide tests and results which are strictly reproducible given the source code and information shared through this project.
We do not discuss aspects relative to the (subjective) individual user experience or other important aspects such as documentation and code quality, usability, overall sustainability, community support, release updates...
Please refer to corresponding tools to evaluate those aspects.
More information related to software evaluation can be found at http://www.software.ac.uk/software-evaluation-guide and http://software.ac.uk/sites/default/files/SSI-SoftwareEvaluationCriteria.pdf
 (credit to the Software Sustainability Group and more particularly to the authors Mike Jackson, Steve Crouch and Rob Baxter).

The source code and details regarding the materials and methods used in the evaluations are defined herein.
However, due to github constraints considering file sizes, some datasets cannot be included in this community project ; they are made available through other websites. 
Only raw results are provided on this project.
A more detailed (but subjective) discussion of the results is currently provided at http://www.semantic-measures-library.org/index.php?q=performance

> Do not hesitate to help us improve the benchmark and to upgrade the tests with new tools or new versions of considered tools. 
> The issue tracker can be used to discuss any problems regarding the source code or the test protocols.
> You can also fork the project to (i) add new tools or upgrade existing tools or datasets, (ii) add new tests, (iii) fix bugs or improve the source code.
> We will next incorporate your change to this project.

We currently propose Domain-specific evaluations. Indeed, numerous library and tools have been developed for domain-specific use cases (e.g. ontologies). 
Considering specific domain of use, we compare the tools regarding their speed performance and their capacity to handle large datasets.

The domain for which test are available are:

 * Molecular Biology and Biomedicine
   * Gene Ontology

<!--- 

 Add tests relative to 
 Disease Ontology 
 WordNet 

-->

How to Reproduce Tests and Results
--------------
The source code is developed in order to be executed on any 64-Bit Linux operating system considering software dependencies to be installed (e.g. Python, Java, R - refer to evaluated tools).
I personally used the easy-to-used Ubuntu distribution (LTS 12.04) but other distributions can be used.
Windows users can deploy a virtual machine to reproduce the tests, fork the repository and follow the instructions. 
Please, start a discussion if you encounter any problems.

> Note that results may vary considering your hardware configuration but rankings must be the same.


Molecular Biology and Biomedicine
--------------

This section contains all tests relative to computation of semantic measures scores for Molecular Biology and Biomedicine studies.

### Gene Ontology

Two series of tests have been performed:
* Term to Term computations, in which tools are compared computing the semantic similarity of pairs of terms defined in the Gene Ontology.
* Gene Product to Gene Product computations, in which tools are compared computing the semantic similarity of genes annotated by terms defined in the Gene Ontology.

In all the tests we consider that:
* No restriction is applied on the Evidence Code associated to the annotations linked to gene product (e.g., IEA annotations are considered)

The datasets relative to this test are available at `*/go` e.g. `scripts/go`

#### Tools Compared 

See the section dedicated to tools for more information (tool versions).
We currently compare:
* Semantic Measures Library Toolkit (SML)
* GOSim
* GOSemSim
* FastSemSim



#### Dataset

The dataset associated to this test is contained in the directory /data/go  
(please download the dataset from TODO: ADD LINK_TO_THE_DATASET)

##### Gene Ontology

The version of the Gene Ontology used for this test is the lite version of 2013 03 02 (contained in the dataset but can also be downloaded at ftp://ftp.geneontology.org/pub/go/godatabase/archive/lite/2013-03-02/)

GOSim & GoSemSim depends on the GO.db package proposed by Bioconductor and are therefore constrained to be used with the version associated to Bioconductor. 
The version of Bioiconductor which has been used in this test is version see http://www.bioconductor.org/packages/2.12/data/annotation/manuals/GO.db/man/GO.db.pdf for details regarding the information relative to the GO loaded in Bioconductor 2.12.

FastSemSim loads any GO specified in OBO-XML and the SML is able to load the OWL/RDF-XML and OBO formatted versions.

The file which have been used for this tests are
* go_20130302-termdb.obo-xml.gz	3.7 MB	3/4/13 10:35:00 AM
* go_20130302-termdb.owl.gz	3.7 MB	3/4/13 10:35:00 AM

They can be found in the directory `/data/go/onto` or at ftp://ftp.geneontology.org/pub/go/godatabase/archive/lite/2013-03-02/

Note also that we converted the obo.xml format to obo using  go-perl package http://search.cpan.org/~cmungall/go-perl/
`./scripts/go2fmt.pl -w obo OBO_XML_FILE > OBO_FILE `.
The OBO file has been saved under the name `go_20130302-termdb.obo`.
The `hold_over_chain` tags of typedefs have been commented as go-perl doesn't support them.

##### Annotations

GOSim and GOSemSim rely on the GO annotations defined in the R package org.Hs.eg.GO.
See http://www.bioconductor.org/packages/2.12/data/annotation/manuals/org.Hs.eg.db/man/org.Hs.eg.db.pdf for more information on the version of the annotations used. 

FastSemSim and the SML rely on GAF or plain annotations files.
We encountered difficulties to download GAF file associated to the annotations corresponding to the one loaded in the R package on which rely GOSim and GOSemSim.
In order to ensure that the annotations used for the evaluation are the same, we created a dump of org.Hs.eg.GO using the R script named dump_orgHsegGO.R. (`/scripts/go/`).
This script generates a TSV file containing the GO annotation for all human genes.


The format required for the SML to import TSV file is slightly different from the one used by FastSemSim.
The conversion of the dump generated by the R script has been made using the script changeDumpAnnotationTSVFormat.py (`/scripts/go/`)

The annotation dumps used in the tests can be found at `/resources/data/go/annot`:
* dump_orgHsegGO.tsv
* dump_orgHsegGO_sml.tsv

#### Test 1: Term to Term computations

This test aims at comparing the tools in computing similarity between terms defined in the Gene Ontology.
Four tests have been designed. 
Each test is composed of a set of pairs of terms for which we want the semantic similarity to be computed:

* 1k pairs of terms
* 10k pairs of terms
* 1M pairs of terms
* 100M pairs of terms

For each test of size X, 3 random samples of size x have been generated in order to reduce the probability the evaluation of the performance is biased by abnormal sampling.
As an example the test composed of 1K pairs of terms is composed of three different samples r1, r2, r3.
For each sample (e.g. r1), three runs (r1.0, r1.1, r1.2) have been performed.
This is to reduce the probability results are biased by abnormal operating system behavior or material lags.

The sets of pairs of terms composing the 3 samples of each test have been generated using the tool `sml-tools-evaluation-generate-go-benchmarks.jar`
```
java -jar sml-tools-evaluation-generate-go-benchmarks.jar ../../resources/data/go/onto/go_20130302-termdb.owl ../../resources/data/go/annot/dump_orgHsegGO_sml.tsv ../../resources/data/go/benchmarks/
```
Both the tool and the source code can be found at `scripts/go/`.

This tool is used to generate benchmarks composed of pairs of GO terms. 
It has been used to generate TSV files containing pairs of GO terms identifiers (one per line). 
Four sizes of benchmarks are considered (1K, 10K, 1M and 100M). 
As we said, for each size, three sets of pairs are generated.
The benchmarks are built selecting random pairs of terms specified in the Biological Process aspect of the GO 
(all pairs are of terms are composed of terms subsumed by the term GO:0008150).
In addition, all terms which appear in the test are at least used to annotate a gene defined in dump_orgHsegGO.tsv.
Indeed some library cannot compute the similarity of terms which are not used to annotated to annotate at least one gene (This is due to the computation of Resnik Information Content). 

The samples used for the tests can be found at: `resources/data/go/benchmarks`

We selected Lin Information Content based  (IC-based) measure to evaluate the performance of the tools.
Lin is a commonly used measures to compare two concepts/terms defined in an ontology.
It requires the Most Informative Common Ancestor of the compared terms and (by default) Resnik IC to be computed.
This two treatments are the most time consuming of all IC-based measures (e.g. Resnik, Lin, SimRel) and IC-based measures are the most commonly used measures. 

The script which is used to perform the test can be found at `/scripts/go/run.sh`.
This script is used to launch the tests considering the tools have been installed and the dataset downloaded.
If you try to reproduce the results, please edit the variable at the beginning of the script (e.g. installation and output directory).
The script also specifies two constraints you can be modified editing the script.
This must be require depending on your hardware configuration.
The constraint we consider are:
- memory consumption : processes cannot use more than 6Go memory
- Time constraint : processes cannot take more than two hours

If those constraints are not respected the execution is stopped.

> Due to their performance GOSim and GOSemSim are not considered for the large tests.
> This can be modified modifying the script run.sh.

GOSim and GOSemSim do not have command line interfaces.
We therefore developed two simple scripts which can be used to compute all the similarities for the pairs of entries contained in a file.
See `scripts/go/GOSimWrapper.R` and `scripts/go/GOSemSimWrapper.R`.


##### Perform the Test

Execute the script (see above for details regarding the script).
We consider `/tmp/output_go_benchmark.log` as our log file.
```
./scripts/go/run.sh 2>&1 | tee /tmp/output_go_benchmark.log
```
This can take several hours depending on the constraints you specified and the hardware configuration.
The script execution can be consulted using:
```
grep "\*\|user\|real" /tmp/output_go_benchmark.log  
```

To extract the information relative to execution time and to store it into `/tmp/output_go_benchmark.log.reduce`
grep "\*\|user\|real" /tmp/output_go_benchmark.log  > /tmp/output_go_benchmark.log.reduce

The results are next processed by the python script `scripts/go/process_results.py` which computes the average values and associated standard deviation.
```
scripts/go/process_results.py /tmp/output_go_benchmark.log.reduce
```

We manually formatted the table on the plots.

##### Results

> The tests have been performed on a Intel(R) Core(TM) i5 CPU M 560 @ 2.67GHz with 6Go allocated to the tools.

The detailed results for each run can be consulted at `results/go/benchmark_result_pairwise.ods`.
Below the digested results.
'X' means that the tests have not be performed (due to the performance of the tools).
'!' means that the constraints have been reached and that the computation failed. 
SML Par(4) corresponds to the SML configured with 4 threads (add `-threads 4` to the classical SML command line).

|          	 |  1K        | 10K        |  1M           | 100M           |  
| -------  	 |:----------:| :---------:|:-------------:|:--------------:|
| FastSemSim | 0m12.3	  | 0m12.83    |  0m31.68      | ! > 6Go memory |
| SML        | **0m9.23** | **0m9.76** |  **0m19.55**  | **16m30.24**   |
| SML Par(4) | 0m9.22     | 0m9.56     |  0m14.47      | 8m58.29        |
| GOSim    	 | 0m49.46    | 3m21.5     |   X           |  X             |
| GOSemSim 	 | 1m34.69    | 16m21.34   |   X           |  X             |

###### Correlations

We evaluated the Pearson correlations between the results obtained by the various libraries considering Lin measure.
The correlations have been computed taking term to term 10000 r_0_0 sample into consideration.
The details can be found in results/go/correlations_tools_r0_0.ods

Acronyms:
* FSS: FastSemSim
* FSS ISA: FastSemSim only considering is a relationships (see remark above)
* SML: Semantic Measures Library
* GOSim
* GOSemSim

FSS ISA corresponds to the results obtained using a special build of the FastSemSim library, version 0.7.1.1 (see `resources/tools/`).
This version is not an official release supported by Marco Mina. 
This build has been made in order to change an undesired behavior relative to the way version 0.7.1 compute parents/ancestors.
Indeed version 7.1 considers all types of relationship as isa/rdfs:subClassOf relationship when parents are computed.
This behavior changes results such as common ancestors and or the computation of the Most Informative Common Ancestor of two terms.
The results of this version for sample r0_0 can be found at `results/go/r_10000_FastSemSim_7.1.1_0_0.tsv` (then can also be reproduced modifying run.sh script).

GOSim and GOSemSim relies on GO.db R package http://www.bioconductor.org/packages/2.12/data/annotation/html/GO.db.html
They also considers as ancestors of a concept x, concept which are not subsuming x according to is-a relationships.
See http://www.bioconductor.org/packages/2.13/data/annotation/manuals/GO.db/man/GO.db.pdf:
GOBPPARENTS details: 
"Each GO BP term is mapped to a named vector of GO BP terms. 
The name associated with the parent term will be either isa, hasa or partof, 
where isa indicates that the child term is a more speciﬁc version of the parent, 
and hasa and partof indicate that the child term is a part of the parent. 
For example, a telomere is part of a chromosome."

|          | FSS    | FSS ISA |  SML     | GOSIM | GOSEMSIM |
| -------  |:------:| :------:|:--------:|:-----:|:--------:|
| FSS      | 1	    | 0.68    |  0.69    | 0.85  | 0.86     |
| FSS ISA  |        | 1       | **0.99** | 0.58  | 0.58     |
| SML      |        |         |  1       | 0.57  | 0.58     |
| GOSim    |        |         |          | 1     | 0.99     |
| GOSim    |        |         |          |       | 1        |

We observe that GOSIM and GOSemSim have a maximal Pearson correlation (0.99).
Both tools rely on GO.db package. 
They also both have a strong correlation with FSS (0.85).
The difference can be explained by the way the tools compute the information content.

The SML however produces scores which are faintly correlated to FSS, GOSim and GOSemSim.
We investigated the results to understand which are the causes of the differences.
We found that FSS, GOSim and GOSemSim perform treatments which are not in accordance with the original definition of Information Content based measures.
Indeed, those measures clearly rely on the taxonomic graph in order to be computed.
The taxonomic graph is the subgraph of the ontology which only contains isa relationships (rdfs:subClassOf).
This graph is considered to compute the ancestors of a terms and is therefore important to compute the Most Informative Common Ancestor (or Disjoint Common Ancestors) in Information Content based measures.
FastSemSim, GOSim and GOSemSim do not consider only taxonomic relationships to compute the ancestors, which explain the variation obtained.
They also consider part-of relationships (or even regulates in FSS) to define ancestors. 
To ensure that the poor correlations were due to this difference, we created a modified version the FastSemSim library (see build 0.7.1.1 in `/resources/tools`).
This version can be used to compute the similarities using FSS source code, only considering isa relationships when ancestors are computed.
Considering this modification we obtained the expected corelation (0.98).

> Most of result variations can be explained by differences between the various interpretations and implementations of measures proposed by the libraries.

###### Observations

* FastSemSim produces a large number of values set to None, which cannot be exploited by other algorithms.
This is not an error in the test. This is due to the way FastSemSim computes Resnik Information Content.
Reminds IC(term1) = -log(p(term1)) with p(term1) the probability term1 is used in the annotation repository.
Considering that some terms (e.g. (terminal terms) are not used in the repository, the probability they occur is nil and their IC is set to infinity.
By applying a strict implementation FastSemSim refuse to process those pairs and is therefore limiting to compute pairwise similarity measures (not that the IC cannot be changed).
Refers to the class TermSemSim method int_validate_single_term of the module TermSemSim  (if self.util.IC[term] == None: return None). 
Not also that this is not a problem for Gene to Gene comparisons as all pairwise computations involve terms which have been used by at least one gene. 

* Due to their performance GOSim and GOSemSim have been excluded from the large tests

* GOSim and GOSemSim precompute the IC and can be used to handle large quantity of annotations. 
Indeed loading all UniprotKB annotation using FastSemSim or the SML is currently not possible.
Those two solutions use in-memory

#### Test 2: Gene products comparison

This test aims at comparing the tools in computing similarity between gene products annotated by genes defined in the Gene Ontology.
Four tests have been designed. 
Each test is composed of a set of gene product for which we want the semantic similarity to be computed:

* 10k pairs of terms
* 100k pairs of terms
* 1M pairs of terms
* 100M pairs of terms



The sets of pairs of terms have been generated using the source code available at: 
TODO

<!---

### Disease Ontology

#### Tools compared 
* SML
* DOSim

see the section dedicated to tools for more information such as tool versions.

-->

List of Tools
--------------

This listing contains the tools which have been included in the evaluation.
The tools are available at `./resources/tools` (Please refer to the corresponding documentation for the installation)

#### Semantic Measures Library (and Toolkit)

url: http://www.semantic-measures-library.com

version: 0.6

##### Dependencies

Java 1.7.
In the tests we used:
```
java -version
java version "1.7.0_21"
Java(TM) SE Runtime Environment (build 1.7.0_21-b11)
Java HotSpot(TM) 64-Bit Server VM (build 23.21-b01, mixed mode)
```

##### Installation

None. The SML-Toolkit is ready to use

#### GOSim

url: http://cran.r-project.org/src/contrib/Archive/GOSim/

version: 1.2.7.7

##### Dependencies

In the tests we used:
```
R --version
R version 3.0.1 (2013-05-16) -- "Good Sport"
Copyright (C) 2013 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)
```

Upgrade R version if required (Ubuntu users: http://cran.cnr.berkeley.edu/bin/linux/ubuntu/)


##### Installation


In R console:

First install dependencies, they are specified when you try to install the software

```
source("http://bioconductor.org/biocLite.R")
biocLite(c("annotate", "topGO", ...))
```

Next install the corresponding package (change the location of the package)
`install.packages(".../GOSim_1.2.7.7.tar.gz", repos = NULL, type ="source")`

#### GOSemSim

url: http://www.bioconductor.org/packages/release/bioc/html/GOSemSim.html

version:  1.18.0


##### Dependencies

In the tests we used:
```
R --version
R version 3.0.1 (2013-05-16) -- "Good Sport"
Copyright (C) 2013 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)
```

Upgrade R version if required (Ubuntu users: http://cran.cnr.berkeley.edu/bin/linux/ubuntu/)


##### Installation


In R console:

First install dependencies, they are specified when you try to install the software

```
install.packages(c("Rcpp","igraph","flexmix", "RBGL", "graph", "corpcor", "org.Hs.eg.db"))
source("http://bioconductor.org/biocLite.R")
biocLite(c("GO.db", "AnnotationDbi", "annotate", "topGO"))
```

Next install the corresponding package (change the location of the package)
`install.packages(".../GOSemSim_1.18.0.tar.gz", repos = NULL, type ="source")`

#### FastSemSim

url: http://sourceforge.net/projects/fastsemsim/

version: 0.7.1

##### Dependencies

We used:
```
python --version
Python 2.7.3
```

##### Installation

Considering Python is already installed

Unzip the archive

as Root ./install.sh

<!---

#### DOSim

url: ?
version: ?

--> 

Competing interests
--------------------

This project has been initiated in order to evaluate the Semantic Measures Library SML.
As the developers of these tests are also developers of the SML we cannot ensure that this evaluation is free from bias.
Indeed we better know how to configure and use the SML than other tools. Do not hesitate to help us improve those tests !

