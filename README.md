# GxEsum
GxEsum: Genotype-by-environment interaction model based on GWAS summary statistics

Users should prepare LDSC (munge_sumstats.py and ldsc.py) and PLINK (v1.9) software that are ready to run in the folder.

    * if LDSC is not working, please try to upgrade python pacakge, e.g. pip install --upgrade numpy==1.16.0
      (change numpy==1.12 to numpy==1.16.0 in the environment.yml file for using Anaconda3. You can fix the environment.yml file)



      # GWAS process

    : using plink, GWAS summary stats including the GxE component can be obtained (BETA by fitting to the linear regression model).

e.g., ./plink1.9 --bfile example --linear interaction --pheno example_quant.pheno --covar example.cov --parameters 1, 2, 3 --allow-no-sex --out example

or for the phenotype formatted as binary,

e.g., ./plink1.9 --bfile example --linear interaction --pheno example_binary.pheno --covar example.cov --parameters 1, 2, 3 --allow-no-sex --out example
(for binary traits, we have assigned as 20/10 to fit into the linear regression model)

-> This plink command will give "example.assoc.linear" ( contains $BETA for regression coefficients)

Note. Using different versions of PLINK (e.g., plink2) will give the different format of outcomes, users should modify the R script depending on which version of plink is used.


      # Converting your GWAS summary statistics to LDSC format (e.g., .sumstats.gz)


For LDSC, the outcomes of GWAS needs to be converted to .sumstats.format (see LDSC instruction)
They strongly suggest that using ./munge_sumstats.py which is included with ldsc.

Before reformatting the data, an extra process for munging your summary statisitcs is required.

I would recommend using the R script (see input_for_munge.R) that can help preparing the input file for munge.

The input_for_munge.R is a script for extracting the information of GxE effects which is required in munging process.

The command in shell script to process the R script is

e.g., R CMD BATCH --no-save input_for_munge.R

Munge your data using the generated input file from R script above

e.g., ./munge_sumstats.py --sumstats example.ldsc --merge-alleles w_hm3.snplist --out example

This command will output .sumstats.gz format file that is generated based on your GWAS summary statistics

To make munge_sumstats.py complete GWAS Summary statistics conversion faster, you can reduce the chunksize from 5000000 (default) to 500000 by adding the option --chunksize 500000.


Estimating the phenotypic variance explained by GxE effects (LD score regression)

using the LD Score that can be estimated based on your own plink binary data or downloaded the estimated 1000 Genomes Europeans LDSC.


e.g., ./ldsc.py --h2 example.sumstats.gz --ref-ld ldsc_example/example --w-ld ldsc_example/example --out example


This will give .log file that contains the phenotypic variance explained by GxE and intercept value.


Note. It is recommended using LD Scores estimated based on in-sample if individual-level genotypes are available.


