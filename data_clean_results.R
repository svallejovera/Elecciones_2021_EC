## Elecciones 2021 ##
## Data clean ##
# Sebastián Vallejo #

library(tidyverse)
library(quanteda)

#create a list of the files from your target directory
setwd("/Volumes/SP B75 PRO/Papers and Chapters/Women Voting for Women")

file_list <- list.files(path="/Volumes/SP B75 PRO/Papers and Chapters/Women Voting for Women",
                        pattern = ".Rdata")

### Bind all together
resultados_raw_all <- data.frame()

for (i in 2:length(file_list)){
  load(file_list[i]) 
  resultados_raw_all <- rbind.data.frame(resultados_raw_all, results_juntas)
}

setwd("/Volumes/SP B75 PRO/Papers and Chapters/Women Voting for Women/data_cleaned")

### Eliminate dups
resultados_raw_all <-  as.data.frame(resultados_raw_all[!duplicated(resultados_raw_all$mesa_temp),])

### Extract info:

# All letter identifiers should start in 2 
resultados_df <- resultados_raw_all[!is.na(resultados_raw_all$mesa_temp),]
resultados_df <- resultados_df[resultados_df$i!=1,]


# Extract info by junta:
results_final_clean <- NA

for(i in 1:length(resultados_df$mesa_temp)){
sentences_results_junta <- char_segment(resultados_df$candidatos_temp[i],
                                  pattern = "\n",
                                  valuetype = "fixed",
                                  pattern_position = "before",
                                  remove_pattern = TRUE) 

porcentaje_results_junta <- str_extract(sentences_results_junta,"[0-9]{1,2}\\,[0-9]{1,2} \\%")
porcentaje_results_junta <- str_remove(porcentaje_results_junta, "\\%")
porcentaje_results_junta <- str_squish(porcentaje_results_junta)

sentences_results_junta <- str_remove(sentences_results_junta,"[0-9]{1,2}\\,[0-9]{1,2} \\%")
sentences_results_junta <- str_squish(sentences_results_junta)

total_results_junta <- str_extract(sentences_results_junta,"[0-9]{1,5}$")

party <- str_remove(sentences_results_junta,"[0-9]{1,5}$")
party <- str_squish(party)

mesa_temp <- paste(resultados_df$mesa_temp[i], " >", sep = "")
sentences_loc_junta <- char_segment(mesa_temp,
                                        pattern = ">",
                                        valuetype = "fixed",
                                        pattern_position = "after",
                                        remove_pattern = TRUE) 


if(str_detect(sentences_loc_junta[2],"CIRCUNSCRIPCIÓN")){
results_temp <- cbind.data.frame(party,total_results_junta,porcentaje_results_junta,sentences_loc_junta[1],sentences_loc_junta[2],sentences_loc_junta[3],sentences_loc_junta[4],sentences_loc_junta[5],sentences_loc_junta[6])
colnames(results_temp) <- c("partido", "total_votos_junta", "porcentaje_votos_junta", "provincia", "circunscripcion","canton","parroquia","zona","junta")
results_final_clean <- rbind.data.frame(results_final_clean,results_temp)
}else{
  results_temp <- cbind.data.frame(party,total_results_junta,porcentaje_results_junta,sentences_loc_junta[1],"",sentences_loc_junta[2],sentences_loc_junta[3],sentences_loc_junta[4],sentences_loc_junta[5])
  colnames(results_temp) <- c("partido", "total_votos_junta", "porcentaje_votos_junta", "provincia", "circunscripcion","canton","parroquia","zona","junta")
  results_final_clean <- rbind.data.frame(results_final_clean,results_temp)
}
print(i)
}

# Dusting
results_final_clean <- results_final_clean[-1,]
results_final_clean$total_votos_junta <- as.numeric(results_final_clean$total_votos_junta)
results_final_clean$porcentaje_votos_junta <- str_replace(results_final_clean$porcentaje_votos_junta,"\\,","\\.")
results_final_clean$porcentaje_votos_junta <- as.numeric(results_final_clean$porcentaje_votos_junta)

# Save
save(results_final_clean, file ="results_final_clean.Rdata")
