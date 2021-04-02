
  echo ""
  echo "********************************************************"
  echo "* GxEsum"
  echo "* Jisu Shin & S. Hong Lee (2020)"
  echo "* University of South Australia"
  echo "********************************************************"
  echo "" 

   ############################################################################
   # Step1.  GWAS for linear regression model (quantitative/binary trait)
   ############################################################################
 
   echo "* GWAS for linear regression model"
   # for quantitative traits,
   ./plink1.9 --bfile example --linear interaction --pheno example_quant.pheno --covar example.cov --parameters 1, 2, 3 --allow-no-sex --out example &> plink.log
   # for binary traits,
   #./plink1.9 --bfile example --linear interaction --pheno example_binary.pheno --covar example.cov --parameters 1, 2, 3 --allow-no-sex --out example &> plink.log
   echo "* done"
   echo ""

   ###########################################################################
   # Step2. LDSC for GxE interaction 
   ###########################################################################
   echo "* LDSC for GxE interaction, i.e. var(g1)"
 
   # strongly suggested using ./munge_sumstats.py before doing LDSC for munging your summary statistics 
 
   ## 2.1 Extracting the information of GxE effects from GWAS summary statistics for munging process
 
   R CMD BATCH --no-save input_for_munge_gxe.R
 
   ## 2.2 converting GWAS summary statistics to LDSC format using munge (e.g., .sumstats.gz) 
  
   ./munge_sumstats.py --sumstats example_gxe.ldsc --merge-alleles w_hm3.snplist --out example_gxe &> example_gxe.log
 
   ## 2.3  LD score regression (Estimating the phenotypic variance explained by GxE effects
 
   ./ldsc.py --h2 example_gxe.sumstats.gz --ref-ld ldsc_example/example --w-ld ldsc_example/example --out example_gxe &> example_gxe.log 
 
   echo "* done"
   echo ""

   #############################################################################
   # Step3. LDSC for main genetic effects 
   #############################################################################  
   echo "* LDSC for main genetic effects, i.e. var(g0)"

   ## 3.1 Extracting the information of main geneticeffects from GWAS summary statistics for munging process 

   R CMD BATCH --no-save input_for_munge_g0.R

   ## 3.2 converting GWAS summary statistics to LDSC format using munge (e.g., .sumstats.gz)  

   ./munge_sumstats.py --sumstats example_g0.ldsc --merge-alleles w_hm3.snplist --out example_g0 &> example_g0.log

   ## 3.3  LD score regression (Estimating the phenotypic variance explained by GxE effects

   ./ldsc.py --h2 example_g0.sumstats.gz --ref-ld ldsc_example/example --w-ld ldsc_example/example --out example_g0 &> example_g0.log
   echo "done"
   echo ""

   #############################################################################
   # Step 4. Get results from the above process
   #############################################################################
   echo "* GxEsum analysis results"
   ## 4.1 Extract estimated main genetic variance and the intercept
   awk '$4=="h2:" {split($6,a,"(");split(a[2],b,")");print $5,b[1]}' example_g0.log > result.ldsc_g0
   awk '$1=="Intercept:" {split($3,a,"(");split(a[2],b,")");print $2,b[1]}' example_g0.log >> result.ldsc_g0

   ## 4.2 Extract estimated GxE interaction variance and the intercept 
   awk '$4=="h2:" {split($6,a,"(");split(a[2],b,")");print $5,b[1]}' example_gxe.log > result.ldsc_gxe
   awk '$1=="Intercept:" {split($3,a,"(");split(a[2],b,")");print $2,b[1]}' example_gxe.log >> result.ldsc_gxe

   R CMD BATCH --no-save result.r
   cat GxEsum.out

   echo ""
   echo "* NOTE"
   echo "  The total phenotypic variance is assumed to be 1"
   echo "  P-value is from Wald test"
   echo "  This toy example is just to demonstrate how to run GxEsum, which can generate unreliable estiamtes with large SE (a user may need larger # samples and SNPs)"
   echo ""




