# LynxEnrichR
 R based Lynx enrichment tool
 
### Install requested libraries: 

`install.packages(c("httr","jsonlite"))`

### Usage:

`enrichResults = get_lynx_enrichment(categories=c("go_bp"), genelist=c("AKT1","CASK","PXN"), tax_id="9606")`
### enrichResults (output)


featureId     |  featureName|       pValue| Bonferroni.adjusted.pValue  |  FDR.adjusted.pValue   |    bayesFactor| inQuery| inSearch  |   gene| category|
------------ | -------------| -------------| ------| ----| -----| -----| ------| -------| -------|
 GO:0034614    |                          cellular response to reactive oxygen species| 1.436206e-05   |    0.002269205 |   0.002269205| 9.542656726756832     |  2     |  33| AKT1,PXN  |  go_bp
GO:0100002| negative regulation of protein kinase activity by protein phosphorylation |1.905955e-04   |  0.030114090|  0.015057045| 6.956106872996315   |    1    |    1    | AKT1   | go_bp
 GO:0060709|  glycogen cell differentiation involved in embryonic placenta development| 1.905955e-04  |   0.030114090 | 0.015057045| 6.956106872996315  |     1   |     1    | AKT1  |  go_bp|
 GO:0090288  |      negative regulation of cellular response to growth factor stimulus| 3.813566e-04  |  0.060254346| 0.020084782| 6.262596785731148    |   1     |   2    | CASK  |  go_bp|


### Available databases:

|Databases| code| tax_id|
----------|--------------|----|
GO biological process |go_bp|9606|
GO cellular component |go_cc|9606|
GO molecular function |go_mf|9606|
Collection of pathways from KEGG, REACTOME, NCI, WIKI pathway | pathway|9606|
GO with general Hierarchy - Molecular Function	| go_hie_mf|9606|
GO with general Hierarchy - Biological Process	| go_hie_bp|9606|
GO with general Hierarchy - Cellular Component	| go_hie_cc|9606|
Pubmed (Uniprot & NCBI Generif)  | pubmed|9606|
Diseases (OMIM, AutDB, 	DISEASE DB (Univ of Copenhagen), Cancer Gene Index [CGI], 	Schizophrenia Gene Resource [SZGR])	| disease|9606|
Tissues (NCBI Unigene)	| tissue|9606|
Phenotype (Human Phenotype Ontology)	| phenotype|9606|
Uniprot Keywords 	| uniprot_kw|9606|
Interpro Domain 	| domain|9606|
Customized Brain Connectivity Ontology (Lynx Brain Connectivity Ontology) | custom_brain_connectivity|9606|
VISTA TFBS Clusters | vista_tbfs|9606|
VISTA Tissue Enhancers  |vista_enhancers|9606|
GO biological process (MGI) | mmu_go_bp|10040|
GO cellular component (MGI) |mmu_go_cc|10040|
GO molecular function (MGI) |mmu_go_mf|10040|
KEGG (mouse) |mouse_pathway|10040|
