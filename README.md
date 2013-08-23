Evaluation of Software for Semantic Measures
==============================================================

This project aims at comparing tools dedicated to semantic measures computation.
It has been initiated in order to evaluated the Semantic Measures Library (http://www.semantic-measures-library.org/), see the competing interest section for more information. 
In addition, the project currently focuses on graph-based semantic measures and do not evaluate tools related to distributional semantic measures.

The project contains the source code and details regarding the materials and methods used in the evaluations.
Results and discussions are currently provided at http://www.semantic-measures-library.org/index.php?q=performance

> Do not hesitate to help us improve the benchmark and to upgrade the tests with new tools or new versions of considered tools.

We propose:

1. Domain-specific evaluations. Numerous library and tools have been developed for domain-specific use cases (e.g. ontologies). 
Considering specific domain of use, we compare the tools in terms of performance and regarding other criteria such as dependencies, difficulty to use...

 * Molecular Biology and Biomedicine
   * Gene Ontology
   * Disease Ontology
 * WordNet


Molecular Biology and Biomedicine
--------------

### Gene Ontology

Two series of tests have been performed:
* Term to Term computations, in which tools are compared computing the semantic similarity of pairs of terms defined in the Gene Ontology.
* Gene Product to Gene Product computations, in which tools are compared computing the semantic similarity of genes annotated by terms defined in the Gene Ontology.

In all the tests we consider that:
* No restriction is applied on the Evidence Code associated to the annotations linked to gene product (e.g., IEA annotations are considered)

The datasets relative to this test are available at */go e.g. scripts/go

#### Tools compared 

See the section dedicated to tools for more information (tool versions).

* SML
* GOSim
* GOSemSim
* FastSemSim



#### Dataset

The Dataset associated to this test is contained in the directory /data/go  
(please download the dataset from LINK_TO_THE_DATASET)

##### Gene Ontology

The version of the Gene Ontology used for this test is the lite version of 2013 03 02 (which can be downloaded at ftp://ftp.geneontology.org/pub/go/godatabase/archive/lite/2013-03-02/)

GOSim & GoSemSim depends on the GO.db package proposed by Bioconductor and are therefore constrained to be used with the version associated to Bioconductor. The version of Bioiconductor which has been used in this test is version 2.12 see http://www.bioconductor.org/packages/2.12/data/annotation/manuals/GO.db/man/GO.db.pdf for details regarding the information relative to the GO loaded in Bioconductor 2.12.

FastSemSim loads any GO specified in OBO-XML and the SML is able to load the OWL and RDF-XML and OBO formatted versions.

Downloads (ftp://ftp.geneontology.org/pub/go/godatabase/archive/lite/2013-03-02/):
The file which have been used for this tests are
* go_20130302-termdb.obo-xml.gz	3.7 MB	3/4/13 10:35:00 AM
* go_20130302-termdb.owl.gz	3.7 MB	3/4/13 10:35:00 AM

They can be found in the directory /data/go/onto

##### Annotations

GOSim and GOSemSim rely on the annotations defined in the R package org.Hs.eg.GO.
FastSemSim and the SML rely on GAF or plain annotations files.
In order to ensure that the annotations used for the evaluation are the same, we created a dump of org.Hs.eg.GO using the R script named dump_orgHsegGO.R. (/scripts/go/)
see http://www.bioconductor.org/packages/2.12/data/annotation/manuals/org.Hs.eg.db/man/org.Hs.eg.db.pdf for more information on the version of the annotations used. 

The format required for the SML to import TSV file is sligthly different, the conversion is made using the script changeDumpAnnotationTSVFormat.py

The annotation dump can be found at /resources/data/go/annot:
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

For each test, 3 samples have been generated in order to reduce the probability the evaluation of the performance is biased by abnormal sampling.
As an example the test composed of 1K pairs of terms is composed of three different samples r1, r2, r3.
Moreover for each sample (e.g. r1), three runs (r1.0, r1.1, r1.2) have been performed, to reduce the probability results are biased by abnormal operating system behavior or material lags.

The sets of pairs of terms composing the 3 samples of each test have been generated using the Java class BenchmarkBuilder_GO_TermToTerm

BenchmarkBuilder_GO_TermToTerm is used to generate benchmarks composed of pairs of GO terms. 
It has been used to generate TSV files containing pairs of GO terms identifiers (one per line). 
Four sizes of benchmarks are considered (1K, 10K, 1M and 100M). 
As we said, for each size, three sets of pairs are generated.
The benchmarks are built selecting random pairs of terms specified in the Biological Process aspect of the GO. 
In other terms, all pairs are of classes are composed of classes subsumed by the term GO:0008150

The samples can be found at: resources/data/go/benchmarks

We selected Lin Information Content based  (IC-based) measure to evaluate the performance of the tools.
Lin is a commonly used measures to compare two concepts/terms defined in an ontology.
It requires the Most Informative Common Ancestor of the compared terms and (by default) Resnik IC to be computed.
This two treatments are the most time consuming of all IC-based measures (e.g. Resnik, Lin, SimRel) and IC-based measures are the most commonly used measures. 

The script which is used to perform the test can be found at /scripts/go/GO_T2T.sh 

##### Constraint
We set two constraints:
- memory consumption : processes cannot use more than 4Go memory
- Time constraint : processes cannot take more than two hours

If those constraints are not respected the execution is stopped.


##### Results

###### Observations

* FastSemSim produces a large number of values set to None, which cannot be exploited by other algorithms.
This is not an error in the test. This is due to the way FastSemSim computes Resnik Information Content.
Reminds IC(term1) = -log(p(term1)) with p(term1) the probability term1 is used in the annotation repository.
Considering that some terms (e.g. (terminal terms) are not used in the repository, the probability they occur is nil and their IC is set to infinity.
By applying a strict implementation FastSemSim refuse to process those pairs and is therefore limiting to compute pairwise similarity measures (not that the IC cannot be changed).
Refers to the class TermSemSim method int_validate_single_term of the module TermSemSim  (if self.util.IC[term] == None: return None). 
Not also that this is not a problem for Gene to Gene comparisons as all pairwise computations involve terms which have been used by at least one gene. 

* Due to their performance GOSim and GOSemSim have been excluded from the large tests

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



### Disease Ontology

#### Tools compared 
* SML
* DOSim

see the section dedicated to tools for more information such as tool versions.


List of Tools
--------------

This listing contains the tools which have been included in the evaluation.
The tools are available at ``./resources/tools`` (Please refer to the corresponding documentation for the installation)

#### Semantic Measures Library 
url: http://www.semantic-measures-library.com
version: 0.6

#### GOSim

url: http://cran.r-project.org/src/contrib/Archive/GOSim/

version: 1.2.7.7

##### Installation

We used R version 3.0.1
Upgrade R version if required (Ubuntu users: http://cran.cnr.berkeley.edu/bin/linux/ubuntu/)

In R console:

First install dependencies, they are specified when you try to install the software

`source("http://bioconductor.org/biocLite.R")`

`biocLite(c("annotate", "topGO", ...))`


Next install the corresponding package (change the location of the package)
`install.packages(".../GOSim_1.2.7.7.tar.gz", repos = NULL, type ="source")`

#### GOSemSim

url: http://www.bioconductor.org/packages/release/bioc/html/GOSemSim.html

version:  1.18.0

##### Installation

We used R version 3.0.1
Upgrade R version if required (Ubuntu users: http://cran.cnr.berkeley.edu/bin/linux/ubuntu/)

In R console:

First install dependencies, they are specified when you try to install the software

`install.packages(c("Rcpp","igraph","flexmix", "RBGL", "graph", "corpcor", "org.Hs.eg.db"))`

`source("http://bioconductor.org/biocLite.R")`

`biocLite(c("GO.db", "AnnotationDbi", "annotate", "topGO"))`

Next install the corresponding package (change the location of the package)
`install.packages(".../GOSemSim_1.18.0.tar.gz", repos = NULL, type ="source")`

#### FastSemSim

url: http://sourceforge.net/projects/fastsemsim/

version: 0.7.1

##### Installation

Considering Python is already installed

Unzip the archive

as Root ./install.sh

#### DOSim

url: ?
version: ?

 
Competing interests
--------------------

This project has been initiated in order to evaluate the Semantic Measures Library SML.
As the developers of these tests are also developers of the SML we cannot ensure that this evaluation is free from bias.
Indeed we better know how to configure and use the SML than other tools. Do not hesitate to help us improve those tests.

