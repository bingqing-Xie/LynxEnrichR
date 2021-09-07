#library(curl)
#library(httr)
#library(jsonlite)
#' Enrichment using Lynx API
#'
#' This function returns the enrichment results for given list of genes
#' for requested functional categories: disease, pathway, go_bp, go_cc, go_mf
#'
#' @param categories list of databases
#' @param genelist list of genes
#' @param tax_id taxonomy id, currently supports human: 9606 and mouse: 10040
#' @return A dataframe of enriched functional categories with pValue, overlapped genes,
#' corrected pValue, and bayes factor
#' @export

get_lynx_enrichment=function(categories=c("go_bp"),genelist=c("AKT1","CASK","PXN"),tax_id="9606"){
	finalEnrich_all=c()
	for(ct in categories){
		response <- httr::POST("http://lynx.cri.uchicago.edu/gediresources/resources/enrichment/wholegenome/general/post",  httr::accept_json(), body=list(types=ct,correction=0,pcut=1,taxid=tax_id,bcut=0,seeds=paste0(c("",genelist),collapse=":")), encode='form')
		#print(response)
		resChar=rawToChar(response$content)
		if(resChar!="null"){
			ERs=jsonlite::fromJSON(jsonlite::prettify(resChar))$EnrichmentGenResult
			#print(ncol(ERs))
			ER_singular=FALSE
			if(!is.null(dim(ERs))){
				#if(ncol(ERs)==8){ER_singular=TRUE}
				nTerms=nrow(ERs)
				ERs$pValue=as.numeric(ERs$pValue) 
				ERs=ERs[order(ERs$pValue),]
				ERs$gene=""
				ERs$FDR.adjusted.pValue=1
				ERs$Bonferroni.adjusted.pValue=1
				ranks=1:length(nrow(ERs))
				currentRank=2
				for(i in 2:nrow(ERs)){
					ranks[i]=currentRank
					if(ERs$pValue[i]>ERs$pValue[i-1]){
						
						currentRank=currentRank+1
					}
				}
				for(i in 1:nrow(ERs)){
					#print(ERs$geneHierarchy[i][[1]]$gene$generalGeneInfo$symbol)
					if(length(ERs[i,]$geneHierarchy)==2){
						ERs$gene[i]=ERs[i,]$geneHierarchy$gene$generalGeneInfo$symbol
					}else{
						ERs$gene[i]=paste0(ERs$geneHierarchy[i][[1]]$gene$generalGeneInfo$symbol,collapse=",")
					}
					ERs$Bonferroni.adjusted.pValue[i]=ERs$pValue[i]*nTerms
					ERs$FDR.adjusted.pValue[i]=ERs$pValue[i]*nTerms/ranks[i]
					if(i>1){
						if(ERs$FDR.adjusted.pValue[i]<ERs$FDR.adjusted.pValue[i-1]){ERs$FDR.adjusted.pValue[i]=ERs$FDR.adjusted.pValue[i-1]}
						if(ERs$Bonferroni.adjusted.pValue[i]<ERs$Bonferroni.adjusted.pValue[i-1]){ERs$Bonferroni.adjusted.pValue[i]=ERs$Bonferroni.adjusted.pValue[i-1]}
					}
				}
				ERs$FDR.adjusted.pValue[ERs$FDR.adjusted.pValue>1]=1
				ERs$Bonferroni.adjusted.pValue[ERs$Bonferroni.adjusted.pValue>1]=1
				finalEnrich=ERs[,c("featureId","featureName","pValue","Bonferroni.adjusted.pValue","FDR.adjusted.pValue","bayesFactor","inQuery","inSearch","gene")]
			}else{
				ERs$pValue=as.numeric(ERs$pValue) 
				#if(length(ERs)==8){ER_singular=TRUE}
				ERs$gene=""
				if(length(ERs$geneHierarchy)==2){
						ERs$gene=ERs$geneHierarchy$gene$generalGeneInfo$symbol
					}else{
						ERs$gene=paste0(ERs$geneHierarchy[[1]]$gene$generalGeneInfo$symbol,collapse=",")
					}
				ERs$FDR.adjusted.pValue=ERs$pValue
				ERs$Bonferroni.adjusted.pValue=ERs$pValue
				finalEnrich=ERs[c("featureId","featureName","pValue","Bonferroni.adjusted.pValue","FDR.adjusted.pValue","bayesFactor","inQuery","inSearch","gene")]
			}
			finalEnrich$category=ct
			finalEnrich_all=rbind(finalEnrich_all,finalEnrich)
		}
	}
	return(finalEnrich_all)
}

#' Enrichment for single cell cluster markers
#'
#' This function returns the enrichment results for a single cell marker list
#' for pre-defined functional categories: pathway, go_bp, go_cc, go_mf
#'
#' @param markers output from Seurat function, FindAllMarkers
#' @param name prefix to save the enrichment results
#' @param tax_id taxonomy id, currently supports human: 9606 and mouse: 10040
#' @return 
#' @export

seurat_marker_enrich=function(markers,name,tax_id="9606"){
	ncolmarkers=ncol(markers)
	categories=markers[,ncolmarkers-1]
	enrich_all=c()
	for(clst in unique(categories)){
		submarkers=markers[markers$p_val_adj<0.05 & categories==clst,]
		if(nrow(submarkers)>800){
			submarkers=markers[markers$p_val_adj<0.05 & categories==clst &markers$avg_log2FC>1,]
			clst=paste0(clst,"_logFC1")
		}
		enrich=get_lynx_enrichment(categories=c("go_bp","go_cc","go_mf","pathway"),genelist=submarkers$gene,tax_id=tax_id)
		enrich$Type=clst
		enrich_all=rbind(enrich_all,enrich)
	  }
	  write.csv(enrich_all,file=paste0(name,"_enrich.csv"))
  
}