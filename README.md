# LynxEnrichR
 R based Lynx enrichment tool
Requested libraries: "httr", "jsonlite"
`install.packages(c("httr","jsonlite"))`

Usage:

`enrichResults = get_lynx_enrichment(categories=c("go_bp"), genelist=c("AKT1","CASK","PXN"), tax_id="9606")`
## enrichResults (output)


featureId     |  featureName|       pValue| Bonferroni.adjusted.pValue  |  FDR.adjusted.pValue   |    bayesFactor| inQuery| inSearch  |   gene| category|
------------ | -------------| -------------| ------| ----| -----| -----| ------| -------| -------|
 GO:0034614    |                          cellular response to reactive oxygen species| 1.436206e-05   |    0.002269205 |   0.002269205| 9.542656726756832     |  2     |  33| AKT1,PXN  |  go_bp
GO:0100002| negative regulation of protein kinase activity by protein phosphorylation |1.905955e-04   |  0.030114090|  0.015057045| 6.956106872996315   |    1    |    1    | AKT1   | go_bp
 GO:0060709|  glycogen cell differentiation involved in embryonic placenta development| 1.905955e-04  |   0.030114090 | 0.015057045| 6.956106872996315  |     1   |     1    | AKT1  |  go_bp|
 GO:0090288  |      negative regulation of cellular response to growth factor stimulus| 3.813566e-04  |  0.060254346| 0.020084782| 6.262596785731148    |   1     |   2    | CASK  |  go_bp|



   
   
      
