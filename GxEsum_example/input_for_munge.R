
    # generating input file for munge_sumstats.py tool based on GWAS summary statistics 

   GWAS2=read.table("example.assoc.linear",header=T)

   GWAS=GWAS2[which(GWAS2$TEST=="ADDxCOV1"),1:9]

   bim=read.table("example.bim")
   frq=read.table("example.frq",header=T)

   sv1=seq(1,length(bim$V5))
   sv2=sv1[GWAS$A1 == bim$V5]
   sv3=sv1[GWAS$A1 == bim$V6] 

   GWAS$A2=bim$V6 
   GWAS$A2[sv3]=bim$V5[sv3]

   sink("example.ldsc")
   cat("order snpid hg19chr bp a1 a2 beta pval N","\n")
   write.table(cbind(as.character(GWAS$SNP),as.character(GWAS$CHR),GWAS$BP,as.character(GWAS$A1),as.character(GWAS$A2),GWAS$BETA,GWAS$P,GWAS$NMISS),quote=F,col.names=F,row.names=T)
   sink()



    
