# Reading the sdf files and obtaining the datablock for ChEMBL Drugs sdf file
library(ChemmineR)
setwd("~/R/win-library/3.5/Girke Lab Project Files/Original SDF Files/")
chembldset <- read.SDFset("chembl_drugs-19_20_16_23.sdf")
valid <- validSDF(chembldset) # Identifies invalid SDFs in SDFset objects 
chembldset <- chembldset[valid] # Removes invalid SDFs, if there are any
datablock(chembldset)



# Reading the sdf files and obtaining the datablock for ChEMBL Drug Targets sdf file
library(ChemmineR)
setwd("~/R/win-library/3.5/Girke Lab Project Files/Original SDF Files/")
chembldtset <- read.SDFset("chembl_drugtargets-19_0_22_42.sdf")
valid <- validSDF(chembldtset) # Identifies invalid SDFs in SDFset objects 
chembldtset <- chembldtset[valid] # Removes invalid SDFs, if there are any
datablock(chembldtset)



#Convert datablock into a table for ChEMBL Drugs sdf file
blockmatrix1 <- datablock2ma(datablocklist=datablock(chembldset)) # Converts data block to matrix
mytable1 <- as.data.frame(blockmatrix1)
mytable1



#Convert datablock into a table for ChEMBL Drug Targets sdf file
blockmatrix2 <- datablock2ma(datablocklist=datablock(chembldtset)) # Converts data block to matrix 
mytable2 <- as.data.frame(blockmatrix2)
mytable2



#Modification of mytable1 to exclude unwanted columns
library(dplyr)
newtable1 <- select(mytable1, -c(4,5,6,7,8,9,11,12,13,14,16,17,19,22,23,25,26,27,28))



#Modification of mytable2 to exclude unwanted columns, change column names if applicable to match those in mytable1
newtable2 <- select(mytable2, -c(5,6,7,16,17))
renamedtable2 <- rename(newtable2, CHEMBL_ID = MOLECULE_CHEMBL_ID)



#Merge both tables into a single table
newdataset <- full_join(x = newtable1, y = renamedtable2, by = NULL)



#Determine contents of database file. Save newly formed table in drugbank SQLite database
library(RSQLite)
setwd("~/R/win-library/3.5/Girke Lab Project Files/Sample .db files/")
mydb <- dbConnect(SQLite(), dbname= "drugbank_5.1.0.db")
dbListTables(mydb)
dbWriteTable(mydb, "ChEMBLdB", newdataset, overwrite=TRUE)
dbListTables(mydb)
dbDisconnect(mydb)



#Write functions so that user can query database. #Also need to write function for overlaps
library(RSQLite)
mydb <- dbConnect(SQLite(), dbname= "drugbank_5.1.0.db")
dbListTables(mydb)

getAnnotation <- function(ChEMBLnames) {
  dbGetQuery(mydb, paste0("SELECT CHEMBL_ID, 
                          SYNONYMS, 
                          DEVELOPMENT_PHASE, 
                          FIRST_APPROVAL, 
                          DRUG_TYPE, 
                          CHIRALITY, 
                          ORAL, 
                          PARENTERAL, 
                          AVAILABILITY_TYPE,
                          MOLECULE_NAME, 
                          MOLECULE_TYPE, 
                          MECHANISM_OF_ACTION, 
                          MECHANISM_COMMENT, 
                          SELECTIVITY_COMMENT, 
                          TARGET_CHEMBL_ID, 
                          TARGET_NAME, 
                          ACTION_TYPE, 
                          ORGANISM, 
                          TARGET_TYPE, 
                          MECHANISM_REFS 
                          FROM ChEMBLdB WHERE MOLECULE_NAME =='", ChEMBLnames, "';"))
}
print(paste("cHEMBL_ID:", unique(getAnnotation('Bremelanotide')[1]), 
            "SYNONYMS:", unique(getAnnotation('Bremelanotide')[2]), 
            "DEVELOPMENTAL_PHASE:", unique(getAnnotation('Bremelanotide')[3]), 
            "FIRST_APPROVAL:", unique(getAnnotation('Bremelanotide')[4]), 
            "DRUG_TYPE:", unique(getAnnotation('Bremelanotide')[5]), 
            "CHIRALITY:", unique(getAnnotation('Bremelanotide')[6]), 
            "ORAL:", unique(getAnnotation('Bremelanotide')[7]), 
            "PARENTERAL:", unique(getAnnotation('Bremelanotide')[8]), 
            "AVAILABILITY_TYPE:", unique(getAnnotation('Bremelanotide')[9]),
            "MOLECULE_NAME:", unique(getAnnotation('Bremelanotide')[10]),
            "MOLECULE_TYPE:", unique(getAnnotation('Bremelanotide')[11]), 
            "MECHANISM_OF_ACTION:", unique(getAnnotation('Bremelanotide')[12]), 
            "MECHANISM_COMMENT:", unique(getAnnotation('Bremelanotide')[13]), 
            "SELECTIVITY_COMMENT:", unique(getAnnotation('Bremelanotide')[14]), 
            "TARGET_CHEMBL_ID:", unique(getAnnotation('Bremelanotide')[15]), 
            "TARGET_NAME:", unique(getAnnotation('Bremelanotide')[16]), 
            "ACTION_TYPE:", unique(getAnnotation('Bremelanotide')[17]), 
            "ORGANISM:", unique(getAnnotation('Bremelanotide')[18]), 
            "TARGET_TYPE:", unique(getAnnotation('Bremelanotide')[19]),
            "MECHANISM_REFS:", unique(getAnnotation('Bremelanotide')[20])))
dbDisconnect(mydb)









