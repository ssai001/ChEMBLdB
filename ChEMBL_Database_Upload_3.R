#General setup
library(RSQLite)
setwd("/rhome/ssai001/bigdata")
mydb <- dbConnect(SQLite(), dbname= "chembl_24.db")


#Selecting required tables from database
table1 <- as.data.frame(dbGetQuery(mydb, 'SELECT assay_id, doc_id, record_id, molregno, standard_value, standard_units, standard_type, bao_endpoint, src_id FROM activities')) 
table2 <- as.data.frame(dbGetQuery(mydb, 'SELECT assay_id, standard_type, standard_value, standard_units FROM assay_parameters'))
table3 <- as.data.frame(dbGetQuery(mydb, 'SELECT assay_id, doc_id, description, assay_organism, tid, src_id, chembl_id, bao_format FROM assays'))
table4 <- as.data.frame(dbGetQuery(mydb, 'SELECT * FROM binding_sites'))
table5 <- as.data.frame(dbGetQuery(mydb, 'SELECT molregno, alogp, hba, hbd, psa, rtb, acd_most_apka, acd_most_bpka, acd_logp, acd_logd, molecular_species, full_mwt, qed_weighted, mw_monoisotopic, full_molformula FROM compound_properties'))
table6 <- as.data.frame(dbGetQuery(mydb, 'SELECT record_id, molregno, doc_id, compound_name, src_id FROM compound_records'))
table7 <- as.data.frame(dbGetQuery(mydb, 'SELECT * FROM compound_structures'))
table8 <- as.data.frame(dbGetQuery(mydb, 'SELECT record_id, molregno, mechanism_of_action, tid, site_id, action_type, mechanism_comment, selectivity_comment, binding_site_comment FROM drug_mechanism'))
table9 <- as.data.frame(dbGetQuery(mydb, 'SELECT molregno, pref_name, chembl_id, max_phase, structure_type, molecule_type, first_approval, oral, parenteral, topical, chirality, indication_class FROM molecule_dictionary'))
table10 <- as.data.frame(dbGetQuery(mydb, 'SELECT molregno, syn_type, synonyms FROM molecule_synonyms'))


#Merge all into one dataframe
library(dplyr)
library(purrr)
new_csv <- bind_rows(list(table1, table2, table8, table3, table5, table7, table6, table4, table9, table10), .id = "column_label")


#Upload into DrugbankR database
library(RSQLite)
setwd("/rhome/ssai001/bigdata")
db <- dbConnect(SQLite(), dbname= "sid_drugbank_5.1.0.db")
dbWriteTable(db, "ChEMBLdB", new_csv, overwrite=TRUE)
dbListTables(db)

setwd("/rhome/ssai001/bigdata")
library(RSQLite)
db <- dbConnect(SQLite(), dbname= "sid_drugbank_5.1.0.db")
dbListTables(db)
colnames(dbGetQuery(db, "SELECT * FROM ChEMBLdB"))
nrow(dbGetQuery(db, "SELECT * FROM ChEMBLdB"))
dim(dbGetQuery(db, "SELECT * FROM ChEMBLdB"))






