#######################################
###########DADES GCAT#########################

#set the working directory
#Read dht neede files
setwd("I:/RDecid/Ana_Sanchez/questionari_taules")
malaltiess <- fread("malalties_freq.csv")
tot <- fread("malalties_freq.csv", na.strings = "NULL")
cond <- fread("conditions_nivell1.csv", na.strings = "NULL")
malalties_participants <- filter(cond, FAMILIAR == "PARTICIPANT")

#In order not to have repeated diseases
malalties <- select(malalties_participants,entity_id, TIPO, TIPO3) %>% unique()
malalties2 <- select(malalties, TIPO, TIPO3) %>% unique()
tot3 <- select(malalties_participants,entity_id, TIPO, TIPO3) %>% unique()

#Create a file joining two files and use only the TIPO of 3 characters
tipos_malalties <- data.frame(table(malalties$TIPO)) %>% `colnames<-`(c("TIPO", "N")) %>% 
left_join(malalties2, by ='TIPO') %>% mutate(TIPO3 = ifelse(startsWith(TIPO, "C"), TIPO, substr(TIPO,0,3))) 

#We have selected the diseases we are interested
noms <- unique(c("04186","242","244","246", "25000", "2689","2720","2721","2724","2728", "27401","2749","280","281","282","283","284","29590", "30000","30001","30020","30022","30023", "3003","3004","30000","30004" ,"30004","311" ,"34690",  "36504","36513","3659" , "4019", "41090","4139","43491","4720","49390","496",  "5300","53010","53011","53013","5303","5305","53081","53085","5309"  ,"5690",  "57140","5715","5716","5718"  ,"5379",   "5531", "5533", "5539" ,"5559","5569",  "600","601","602" ,"6929","6961","7100",  "71500","71514","71516","71518","71589","71590" , "71690","71691" ,"7222","72252","7226" ,"7291","73300","73390","73399" ,"78052","7871","9953","9951" ,"C44","C50"))

tot2_filtre <- filter(tot3, TIPO %in% noms | TIPO3 %in% noms)
#treiem cols de TIPO i TIPO3 a matriu:
matriu<- data.frame(tot2_filtre, model.matrix(~TIPO+0, tot2_filtre)) %>% select(-TIPO, -TIPO3)
noms <- colnames(matriu[,-1])
head(consulta)


#lista_tipo <- c("04186",c("242","244","246"), "25000", "2689",c("2720","2721","2724","2728"), c("27401","2749"),
# c("280","281","282","283","284"),"29590",c("30000","30001","30020","30022","30023", "3003","3004"),
# c("3004", "311"),"34690",c("36504","36513","3659"), "4019", "41090","4139","43491","4720","49390","496",
# c("5300","53010","53011","53013","5303","5305","53081","53085","5309") ,"5690",c("57140","5715","5716","5718") ,"5379",
# c("5531", "5533", "5539"),"5559","5569",c("600","601","602"),"6929","6961","7100",c("71500","71514","71516","71518","71589","71590"),
# c("71690","71691"),c("7222","72252","7226"),"7291","73300",c("73390","73399"),"78052","7871", c("9953","9951"),"C44","C50")
                
consulta <- fread("consulta_nivell2.csv", na.strings = "NULL")

#Create a file with          n
cond_2 <- merge(malalties_participants, consulta %>% select(entity_id, GENOTYPED_SAMPLE), by = 'entity_id') %>% 
filter(!is.na(GENOTYPED_SAMPLE)) %>% select(-entity_id)
num_genotyped <- data.frame(cond_2$TIPO3) %>% group_by(cond_2$TIPO) %>% summarise(N = n()) %>% `colnames<-`(c('TIPO', 'N'))
sans = filter(consulta, !entity_id %in% matriu$entity_id) #no malalties
u

#creamos una matriz de 0s de la gente sana
matriu_sans = data.frame(matrix(data = c(sans$entity_id, rep(0, 94*7103)), ncol = 95, nrow = 7103))
colnames(matriu_sans) <-  colnames(matriu)
matriu_all <- rbind(matriu, matriu_sans)

matriu_all <- cbind(matriu_all[1], data.frame(sapply(matriu_all[-1], as.numeric))) %>% group_by(entity_id) %>% summarise_all(sum)

#make groups
matriu_all_final <- merge(matriu_all, consulta %>% select(entity_id, GENOTYPED_SAMPLE), by = 'entity_id')%>% filter(!is.na(GENOTYPED_SAMPLE)) %>% select(-entity_id) %>% 
  mutate(GROUP246 = ifelse(TIPO2449 + TIPO24200 + TIPO2440 + TIPO24290 + TIPO2462 + TIPO2469 + TIPO24210 > 0, 1, 0),
         GROUP272 = ifelse(TIPO2720 + TIPO2721 + TIPO2724 + TIPO2728 > 0, 1, 0),
         GROUP274 = ifelse(TIPO27401 + TIPO2749 > 0, 1, 0),
         GROUP285 = ifelse(TIPO2809 + TIPO28245 + TIPO2822 + TIPO28246 + TIPO2812 + TIPO2800 + TIPO28409 + TIPO2820 + TIPO28240 > 0, 1, 0),
         GROUP300 = ifelse(TIPO30000 + TIPO30001 + TIPO30020 + TIPO30022 + TIPO30023 + TIPO3003 + TIPO3004 > 0, 1, 0),
         GROUP311 = ifelse(TIPO3004 + TIPO311 > 0, 1, 0),
         GROUP365 = ifelse(TIPO36504 + TIPO36513 + TIPO3659 > 0, 1, 0),
         GROUP530 = ifelse(TIPO5300 + TIPO53010 + TIPO53011 + TIPO53013 + TIPO5303 + TIPO5305 + TIPO53081 + TIPO53085 + TIPO5309 > 0, 1, 0),
         GROUP553 = ifelse(TIPO5531 + TIPO5533 + TIPO5539 > 0, 1, 0),
         GROUP571 = ifelse(TIPO57140 + TIPO5715 + TIPO5716 + TIPO5718 > 0, 1, 0),
         GROUP602 = ifelse(TIPO60000 + TIPO60090 + TIPO6019 + TIPO6029 + TIPO6011 > 0, 1, 0),
         GROUP715 = ifelse(TIPO71500 + TIPO71514 + TIPO71516 + TIPO71518 + TIPO71589 + TIPO71590 > 0, 1, 0),
         GROUP716 = ifelse(TIPO71690 + TIPO71691 > 0, 1, 0),
         GROUP722 = ifelse(TIPO7222 + TIPO72252 + TIPO7226 > 0, 1, 0),
         GROUP73399 = ifelse(TIPO73390 + TIPO73399 > 0, 1, 0),
         GROUP995 = ifelse(TIPO9953 + TIPO9951 > 0, 1, 0))

#Create a matrix
matriu1 = as.matrix(matriu_all_final[-95]+1)
#Add an extra column for the IID
IID = matriu_all_final[95]
#join the two matrices
matriu_ultima <- cbind(IID, matriu1)
 

############################
#Terminal: Join psam with the matriu_final

#Primer hem de canviar nom entity_id -> IID del matriu_ultima
#First we have to change the name entity_id by --> IID from matriu_ultima
require(reshape)
matriu_all <- fread("matriu_ultima.txt", na.strings = "NULL")
#Change the name
matriu_all_IID <- rename(matriu_all, c("GENOTYPED_SAMPLE"="IID"))
#Save the table
write.table(matriu_all_IID, "matriu_all_IDD.txt", sep = " ", row.names= F, quote = F)

#Take off the rows from psam
cut -d " " -f 1,2,3,4,5,6,7,8,9 GCAT_imputed.psam > GCAT_imputed_nochol.psam

#Do Merge from matriu_final and psam by IID.
#R
GCAT_imputed_nochol <- fread("GCAT_imputed_nochol.psam", na.strings = "NULL")
GCAT_imputed_IID <- left_join(GCAT__imputed_nochol, matriu_all_IID)
write.table(GCAT_imputed_IID, "GCAT_imputed_IID.psam", sep = " ", row.names= F, quote = F)
####################

apply(GCAT_imputed_IID[,10:64],2,function(x)table(x))

#Make a file with the variants don't pass the filter
exclude <- filter(pvar, INFO < 0.7)
write.table(exclude, "/imppc/labs/dnalab/share/ana_test/output/gwas/exclude.txt", sep = "\t", row.names= F, quote = F)
#keep only the 3th colum (ID) and make another file with the IDs we want to exclude
cut -f 3 exclude.txt > exckude_id.txt

######################
#PLINK
#First save the directories
plink2=/imppc/labs/dnalab/nblaym/gwas/plink2
output=/imppc/labs/dnalab/share/ana_test/output2
output2=/imppc/labs/dnalab/share/ana_test/output2/gwas
input=/imppc/labs/dnalab/share/ana_test/GCAT_imputed
prefix='GCAT_imputed'
exclude=/imppc/labs/dnalab/share/ana_test/exclude_id.txt
cd $output

#Take out the IDs that doesn't pass the filter
$plink2 --pfile $input --exclude $exclude --make-pgen --out GCAT_imputed_QC --threads 7

names_pheno = paste(colnames(matriu_ultima)[-1],collapse = ",") 
      
#traits that have passed the filter
"TIPO04186,TIPO24200,TIPO24210,TIPO24290,TIPO2440,TIPO2449,TIPO2462,TIPO2469,TIPO25000,TIPO2689,TIPO2720,TIPO2721,TIPO2724,TIPO2728,TIPO27401,
TIPO2749,TIPO2800,TIPO2809,TIPO2812,TIPO2820,TIPO2822,TIPO28240,TIPO28245,TIPO28246,TIPO28409,TIPO29590,TIPO30000,TIPO30001,TIPO30020,TIPO30022,
TIPO30023,TIPO3003,TIPO3004,TIPO311,TIPO34690,TIPO36504,TIPO36513,TIPO3659,TIPO4019,TIPO41090,TIPO4139,TIPO43491,TIPO4720,TIPO49390,TIPO496,TIPO5300,
TIPO53010,TIPO53011,TIPO53013,TIPO5303,TIPO5305,TIPO53081,TIPO53085,TIPO5309,TIPO5379,TIPO5531,TIPO5533,TIPO5539,
TIPO5559,TIPO5569,TIPO5690,TIPO57140,TIPO5715,TIPO5716,TIPO5718,TIPO60000,TIPO60090,TIPO6011,TIPO6019,TIPO6029,
TIPO6929,TIPO6961,TIPO7100,TIPO71500,TIPO71514,TIPO71516,TIPO71518,TIPO71589,TIPO71590,TIPO71690,TIPO71691,TIPO7222,TIPO72252,TIPO7226,TIPO7291,
TIPO73300,TIPO73390,TIPO73399,TIPO78052,TIPO7871,TIPO9951,TIPO9953,TIPOC44,TIPOC50,GROUP246,GROUP272,GROUP274,GROUP285,GROUP300,GROUP311,
GROUP365,GROUP530,GROUP553,GROUP571,GROUP602,GROUP715,GROUP716,GROUP722,GROUP73399,GROUP995"

input=/imppc/labs/dnalab/share/ana_test/output2/GCAT_imputed_QC

#make the analysis
$plink2 --pfile $input --pheno-name TIPO6029 TIPO6929 TIPO6961 TIPO71590 TIPO71690 TIPO7222 TIPO7291 TIPO73300 TIPO73390 TIPO78052 TIPO7871 TIPOC44 TIPOC50 GROUP246 GROUP272 GROUP274 GROUP285 GROUP300 GROUP311 GROUP365 GROUP530 GROUP553 GROUP602 GROUP715 GROUP716 GROUP722 GROUP73399 --covar-name GENDER, PC1, PC2, PC3, PC4, AGE --ci 0.95 --glm firth cols=chrom,pos,ref,alt,a1count,a1countcc,nobs,a1freq,a1freqcc,test,orbeta,se,ci,tz,p hide-covar --out $output2/gwas --threads 7

#then for chr X
$plink2 --pfile $input --chr 23 --pheno-name TIPO041,TIPO242,TIPO244,TIPO246,TIPO250,TIPO268,TIPO272,TIPO274,TIPO275,TIPO280,TIPO285,TIPO296,TIPO300,TIPO311,TIPO346,TIPO365,TIPO401,TIPO427,TIPO432,TIPO459,TIPO472,TIPO493,TIPO496,TIPO530,TIPO536,TIPO537,TIPO553,TIPO558,TIPO564,TIPO569,TIPO600,TIPO602,TIPO626,TIPO627,TIPO692,TIPO696,TIPO704,TIPO710,TIPO715,TIPO716,TIPO719,TIPO722,TIPO724,TIPO728,TIPO729,TIPO733,TIPO780,TIPO784,TIPO788,TIPO799,TIPO995,TIPOC43,TIPOC44,TIPOC50,TIPOV25 --covar-name PC1, PC2, PC3, PC4, AGE --xchr-model 1  --ci 0.95 --glm firth  cols=chrom,pos,ref,alt,a1count,a1countcc,nobs,a1freq,a1freqcc,test,orbeta,se,ci,tz,p hide-covar --out $output2/gwas_x --threads 7


#unzip the output files
TIPO041,TIPO242,TIPO244,TIPO246,TIPO250,TIPO268,TIPO272,TIPO274,TIPO275,TIPO280,TIPO285,TIPO296,TIPO300,TIPO311,TIPO346,TIPO365,TIPO401,TIPO427,TIPO432,TIPO459,TIPO472,TIPO493,TIPO496,TIPO530,TIPO536,TIPO537,TIPO553,TIPO558,TIPO564,TIPO569,TIPO600,TIPO602,TIPO626,TIPO627,TIPO692,TIPO696,TIPO704,TIPO710,TIPO715,TIPO716,TIPO719,TIPO722,TIPO724,TIPO728,TIPO729,TIPO733,TIPO780,TIPO784,TIPO788,TIPO799,TIPO995,TIPOC43,TIPOC44,TIPOC50,TIPOV25

|gzip -c > gwas_all_$TIPO.glm.firth 

#select the columns we are interested with and save them
grep -v ^#CHROM $input | cut -f 1,2,4,5,20 > /imppc/labs/dnalab/share/ana_test/output/cols_yes

#create a file with the header
grep ^#CHROM gwas.TIPO041.glm.firth | cut -f 1,2,3,4,5,20 > header



#Join the outputs of the 22 chromosomes with the one from X
# go to the directory
cd /imppc/labs/dnalab/share/ana_test/output2/gwas
#for all traits
for TIPO in TIPO04186 TIPO24200 TIPO24210 TIPO24290 TIPO2440 TIPO2449 TIPO2462 TIPO2469 TIPO25000 TIPO2689 TIPO2720 TIPO2721 TIPO2724 TIPO2728 TIPO27401 TIPO2749 TIPO2800 TIPO2809 TIPO2812 TIPO2820 TIPO2822 TIPO28240 TIPO28245 TIPO28246 TIPO28409 TIPO29590 TIPO30000 TIPO30001 TIPO30020 TIPO30022 TIPO30023 TIPO3003 TIPO3004 TIPO311 TIPO34690 TIPO36504 TIPO36513 TIPO3659 TIPO4019 TIPO41090 TIPO4139 TIPO43491 TIPO4720 TIPO49390 TIPO496 TIPO5300 TIPO53010 TIPO53011 TIPO53013 TIPO5303 TIPO5305 TIPO53081 TIPO53085 TIPO5309 TIPO5379 TIPO5531 TIPO5533 TIPO5539 TIPO5559 TIPO5569 TIPO5690 TIPO57140 TIPO5715 TIPO5716 TIPO5718 TIPO60000 TIPO60090 TIPO6011 TIPO6019 TIPO6029 TIPO6929 TIPO6961 TIPO7100 TIPO71500 TIPO71514 TIPO71516 TIPO71518 TIPO71589 TIPO71590 TIPO71690 TIPO71691 TIPO7222 TIPO72252 TIPO7226 TIPO7291 TIPO73300 TIPO73390 TIPO73399 TIPO78052 TIPO7871 TIPO9951 TIPO9953 TIPOC44 TIPOC50 GROUP246 GROUP272 GROUP274 GROUP285 GROUP300 GROUP311 GROUP365 GROUP530 GROUP553 GROUP571 GROUP602 GROUP715 GROUP716 GROUP722 GROUP73399 GROUP995
do
# gunzip gwas.$TIPO.glm.firth.gz #unzip the file
cat gwas.$TIPO.glm.firth gwas_x.$TIPO.glm.firth > gwas_all_$TIPO.glm.firth #join all chromosomes

#sort rows by chromosome and only keep the columns we are interested in
grep -v ^#CHROM gwas_all_$TIPO.glm.firth | sort -k1,1V -k2,2n | cut -f 1,2,3,4,5,20 > gwas_all_sorted_$TIPO.glm.firth 

#Add the header we have removed before
cat header gwas_all_sorted_$TIPO.glm.firth > gwas_output_$TIPO.glm.firth  

#take put the variants we are not interessted in
awk 'NR==FNR{A[$1]++;next}!($3 in A)' exclude_ok.txt gwas_output_$TIPO.glm.firth | gzip -c > gwas_QC_$TIPO.glm.firth.gz rm gwas_all_$TIPO.glm.firth

#remove the no needed files
rm gwas_all_sorted_$TIPO.glm.firth
rm gwas_output_$TIPO.glm.firth 

#Change the name of the files
mv gwas_QC_$TIPO.glm.firth.gz $TIPO.gz
#Look for the file
echo $TIPO
#Finishes the loop
done



#Mirar psam
TIPOS = c("TIPO04186","TIPO24200","TIPO24210","TIPO24290","TIPO2440","TIPO2449","TIPO2462","TIPO2469","TIPO25000","TIPO2689","TIPO2720","TIPO2721","TIPO2724","TIPO2728","TIPO27401","TIPO2749","TIPO2800","TIPO2809","TIPO2812","TIPO2820","TIPO2822","TIPO28240","TIPO28245","TIPO28246","TIPO28409","TIPO29590","TIPO30000","TIPO30001","TIPO30020","TIPO30022","TIPO30023","TIPO3003","TIPO3004","TIPO311","TIPO34690","TIPO36504","TIPO36513","TIPO3659","TIPO4019","TIPO41090","TIPO4139","TIPO43491","TIPO4720","TIPO49390","TIPO496","TIPO5300","TIPO53010","TIPO53011","TIPO53013","TIPO5303","TIPO5305","TIPO53081","TIPO53085","TIPO5309","TIPO5379","TIPO5531","TIPO5533","TIPO5539","TIPO5559","TIPO5569","TIPO5690","TIPO57140","TIPO5715","TIPO5716","TIPO5718","TIPO60000","TIPO60090","TIPO6011","TIPO6019","TIPO6029","TIPO6929","TIPO6961","TIPO7100","TIPO71500","TIPO71514","TIPO71516","TIPO71518","TIPO71589","TIPO71590","TIPO71690","TIPO71691","TIPO7222","TIPO72252","TIPO7226","TIPO7291","TIPO73300","TIPO73390","TIPO73399","TIPO78052","TIPO7871","TIPO9951","TIPO9953","TIPOC44","TIPOC50","GROUP246","GROUP272","GROUP274","GROUP285","GROUP300","GROUP311","GROUP365","GROUP530","GROUP553","GROUP571","GROUP602","GROUP715","GROUP716","GROUP722","GROUP73399","GROUP995")
frequencies = data.frame(TIPO= NA, freq= NA)

#Look for the cases of the tipos
for(i in seq(10,119)){
  frequencies = rbind(frequencies,data.frame(TIPO = names(gcat_imputed)[i], freq=nrow(filter(gcat_imputed,names(gcat_imputed)[as.numeric(i)] == 2))
}



#Remove the ones with less than 15 cases
rm TIPO24200.gz
rm TIPO2724.gz
rm TIPO30020.gz
rm TIPO30023.gz
rm TIPO53011.gz
rm TIPO5559.gz
rm TIPO5531.gz
rm TIPO5539.gz
rm TIPO6011.gz
rm TIPO71589.gz
rm TIPO71691.gz
rm TIPO73399.gz
rm TIPO2812.gz
rm TIPO7226.gz
rm TIPO2440.gz
rm TIPO28246.gz
rm TIPO5559.gz
rm TIPO60090.gz
rm TIPO5718.gz
rm TIPO7100.gz
rm TIPO27401.gz
rm TIPO29590.gz
rm TIPO3003.gz
rm TIPO53010.gz
rm TIPO6019.gz
rm TIPO71500.gz
rm TIPO2721.gz
rm TIPO71516.gz
rm TIPO2689.gz
rm TIPO57140.gz
rm TIPO60000.gz

# DPH6 gene analysis
#Load GWAS output data of the trait                                            
data <- fread("gwas.TIPO2749.glm.firth")
#Filter by p-value                                             
data_f <- filter(data, P < 1e-10)
#how many snps fulfill the condition                                          
dim(data_f) #30 snps
#sort by p-value                                           
data_s <- data_f %>% arrange(P)
write.table(data_f, "snps_DPH6.wcf", rownames = F, quote = F)
                                             
#TIPO6961
#Load GWAS output data of the trait                                            
data2 <- fread("gwas.TIPO6961.glm.firth")
#Filter by p-value                                             
data_f2 <- filter(data2, P < 1e-10)
#how many snps fulfill the condition                                          
dim(data_f2) #24 snps
#sort by p-value                                           
data_s <- data_f %>% arrange(P)
write.table(data_f, "snps_DPH6.wcf", rownames = F, quote = F)
                                             

