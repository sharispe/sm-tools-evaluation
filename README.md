Evaluation of tools for Semantic Measures
==============================================================

This project aims at comparing tools dedicated to semantic measures computation.
It has been initiated in order to evaluated the Semantic Measures Library (http://www.semantic-measures-library.org/), see the competing interest section for more information. 
In addition, the project currently focuses on graph-based semantic measures and do not evaluate tools related to distributional semantic measures.

The project contains the source code and details regarding the materials and methods used in the evaluations.
Results and discussions are currently provided at http://www.semantic-measures-library.org/index.php?q=performance

> Do not hesitate to help us improve the benchmark and to upgrade the tests with new tools or more recent versions of tools.

We propose:

1. Context specific evaluations. Numerous library and tools have been developed for domain-specific use cases (e.g. ontologies). 
Considering specific domain of use, we compare the tools in terms of performance and regarding other criteria such as dependencies, difficulty to use...

 * Molecular Biology and Biomedicine
   * Gene Ontology
   * Disease Ontology
 * WordNet

Context Specific Evaluations
--------------

### Molecular Biology and Biomedicine

#### Gene Ontology

Two series of tests have been performed:
* Term to Term computations, in which tools are compared computing the semantic similarity of pairs of terms defined in the Gene Ontology.
* Gene Product to Gene Product computations, in which tools are compared computing the semantic similarity of genes annotated by terms defined in the Gene Ontology.

##### Tools compared 
* SML
* GOSim
* GOSemSim
* FastSemSim

see the section dedicated to tools for more information such as tool versions.


#### Disease Ontology

##### Tools compared 
* SML
* DOSim

see the section dedicated to tools for more information such as tool versions.


List of Tools
--------------

This listing contains the tools which have been included in the evaluation.
The tools are available at ``resources/tools``

#### Semantic Measures Library 
url: http://semantic-measures-library.com
version: 0.6

#### GOSim

url: http://cran.r-project.org/src/contrib/Archive/GOSim/
version: 1.2.7.7

#### GOSemSim

url: http://www.bioconductor.org/packages/release/bioc/html/GOSemSim.html
version:  1.18.0

#### FastSemSim

url: http://sourceforge.net/projects/fastsemsim/
version: 0.7.1

#### DOSim

url: ?
version: ?

 
Competing interests
--------------------

This project has been initiated in order to evaluate the Semantic Measures Library SML.
As the developers of these tests are also developers of the SML we cannot ensure that this evaluation is free from bias.
Indeed we better know how to configure and use the SML than other tools. Do not hesitate to help us improve those tests.

