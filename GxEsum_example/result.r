
  g0=read.table("result.ldsc_g0")
  gxe=read.table("result.ldsc_gxe")

  colnames=c("Main genetic variance", "GxE variance")
  p1=pchisq((g0$V1[1]/g0$V2[1])^2,1,lower.tail=F)
  p2=pchisq((gxe$V1[1]/gxe$V2[1])^2,1,lower.tail=F)

  sink("GxEsum.out")
  cat("			Main genetic effects	GxE interaction","\n")
  cat("Estimated intercept:	",g0$V1[2],"		",gxe$V1[2],"\n")
  cat("Estimated variance :	",g0$V1[1],"		",gxe$V1[1],"\n")
  cat("SE      	   :	",g0$V2[1],"		",gxe$V2[1],"\n")
  cat("P-value 	   :	",p1,"		",p2,"\n")
  sink()


