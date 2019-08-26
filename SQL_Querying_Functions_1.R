setwd("/rhome/ssai001/bigdata")
library(RSQLite)
db <- dbConnect(SQLite(), dbname= "sid_drugbank_5.1.0.db")


ChemblQuery <- function(dbpath="default", queryBy=list(idType=NULL, ids=NULL)) {

	if(dbpath=="default") {
		dbpath <- "/rhome/ssai001/bigdata"
	}
	db <- dbConnect(SQLite(), dbname= "sid_drugbank_5.1.0.db")

	if(queryBy$idType=="chembl_id") {
		idvec <- paste0("(\"", paste(queryBy$ids, collapse="\", \""), "\")")
		myquery <- dbSendQuery(db, paste("SELECT standard_value, standard_units, standard_type FROM ChEMBLdB WHERE chembl_id IN", idvec)) 
		output <- dbFetch(myquery)
		dbClearResult(myquery)
	}
    resultDF <- data.frame(output)
    dbDisconnect(db)
    return(resultDF)
}

mydir <- "/rhome/ssai001/bigdata"
queryBy <- list(idType="chembl_id", ids=c("CHEMBL615117", "CHEMBL615118", "CHEMBL615119", "CHEMBL615120", "CHEMBL615121", "CHEMBL615122", "CHEMBL615123", "CHEMBL615124", "CHEMBL615125", 
					"CHEMBL3876267", "CHEMBL3876268", "CHEMBL3876269", "CHEMBL3876270", "CHEMBL3876271", "CHEMBL3876272", "CHEMBL3876273", "CHEMBL3876274", "CHEMBL3876275", "CHEMBL3876276",
					"CHEMBL1948550", "CHEMBL1948551", "CHEMBL1948552", "CHEMBL1948553", "CHEMBL1948554", "CHEMBL1948555", "CHEMBL1948556", "CHEMBL1948557", "CHEMBL1948558", "CHEMBL1948559",
					"CHEMBL1205912", "CHEMBL1205913", "CHEMBL1205914", "CHEMBL1205915", "CHEMBL1205916", "CHEMBL1205917", "CHEMBL1205918", "CHEMBL1205919", "CHEMBL1205920", "CHEMBL1205921"))
qresult <- ChemblQuery(dbpath=mydir, queryBy)
qresult
