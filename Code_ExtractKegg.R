library(msigdb)
library(dplyr)
library(KEGGREST)
library(stringi)
library(stringr)
res <- keggList("pathway", "hsa") 
pathwayid<-names(res)
saveList<-list()
for (i in c(1:length(res))) {
  # i=82
  pathwayName<-str_sub(res[i],1,str_length(res[i])-23)
  #pathwayName<-pathwayName[1]
  test1<-pathwayid[i]
  pathgetId<-str_sub(test1,6,str_length(test1))
  gs<-keggGet(pathgetId)
  geneName<-strsplit(as.character(gs[[1]]$GENE),';')
  genes <- unlist(lapply(gs[[1]]$GENE,function(x) strsplit(x,';')[[1]][1]))
  PathwayGene<-genes[1:length(genes)%%2 ==0]%>%as.character()
  saveList[pathwayName]<-list(PathwayGene)
}
gmtProfile<-list()
gmtProfile$genesets<-saveList
gmtProfile$geneset.names<-names(saveList)
write.gmt(gmtProfile,'KeegData.gmt')