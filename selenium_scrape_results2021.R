### Elecciones Ecuador 2021 ###
## Annotated Version ##
# Sebastián Vallejo 

#####
rm(list=ls(all=TRUE))
setwd("/Volumes/SP B75 PRO/Papers and Chapters/Women Voting for Women")

# I use Selenium to create a virtual navigator and download the data from the 
# national registry
library(RSelenium)
library(stringr)
library(beepr)

# Load docker in order to use the virtual navigator through Selenium
system('docker pull selenium/standalone-chrome')
# Choose a port. Note that the port will be "taken" unless you kill it
# through terminal by:
#   lsof -i :4444
# Kill PIDs of any processes listed. For example:
#   kill 30681
system('docker run -d -p 4445:4444 selenium/standalone-chrome')

# Launch the remote driver
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
# "open" navigator
remDr$open()
# Navigate to webpage
remDr$navigate("https://resultados.cne.gob.ec/")
# Check everything is OK ->
remDr$getTitle()
remDr$screenshot(display = TRUE)

## Let's go by type: Asambleistas Prov w Circunscription

asam_button <- remDr$findElement(using = "css selector", ".m-1:nth-child(3) .myButtonDig")
asam_button$clickElement()

# results_juntas <- NA ## The main df

## List of provinces: ----

# I will do with all the drop down menus the same thing:
n_prov<- remDr$findElement(using = 'css selector', "#ddlProvincia") # Find the element (drop down menu)
n_prov_temp <- unlist(n_prov$getElementText()) # Expand the list of elements 
n_prov_final <- as.numeric(length(unlist(str_split(n_prov_temp, pattern = "\\n")))) # Split the list to see how many elements present and that gives me the length of the drop down menu

con_circuns <- c(10,14,18) # Since the elements are numbers i manually choose Guayas, Manabi, Pichincha
sin_circuns <- c(2:9,11:13,15:17,19:n_prov_final) # I will run a separate code for the rest

## Fruty loopy

for(n in con_circuns){
  prov <- remDr$findElement(using = 'xpath',  paste("//*[@id=\"ddlProvincia\"]/option[",n,"]", sep = "")) #Pick the element from the drop down menu
  prov$clickElement() # Click
  
  Sys.sleep(3) # Wait bc it might take a couple of sec for the page to load
  
  # Now find the length of circunscriptions drop down menu
  # Sometime it takes longer to load and I wont be able to find the next element so...
  for(u in 1:10){ # I force it to try 10 times before exiting the loop with an error. 
    try({
      n_circuns<- remDr$findElement(using = 'css selector', "#ddlCircunscripcion") # Again, select the drop down menu circuscriptions etc... 
      n_circuns_temp <- unlist(n_circuns$getElementText())
      n_circuns_final <- as.numeric(length(unlist(str_split(n_circuns_temp, pattern = "\\n"))))
      break
    }, silent = FALSE)
    Sys.sleep(5)
    print(paste0("u=",u))
  }
  
  for(m in 5:n_circuns_final){
    circuns <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlCircunscripcion\"]/option[",m,"]", sep = "")) # Find m circunscription... 
    circuns$clickElement() # Click
    
    Sys.sleep(3)
    
    # Cantons... 
    for(q in 1:10){ #Force it to retry 10 times before giving up...
      try({
        n_canton<- remDr$findElement(using = 'css selector', "#ddlCanton")
        n_canton_temp <- unlist(n_canton$getElementText())
        n_canton_final <- as.numeric(length(unlist(str_split(n_canton_temp, pattern = "\\n"))))
        break #break/exit the for-loop
      }, silent = FALSE)
      Sys.sleep(5)
      print(paste0("q=",q))
    }
    
    for(l in 8:n_canton_final){
      canton <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlCanton\"]/option[",l,"]", sep = "")) # Find l canton
      canton$clickElement() # Click
      
      Sys.sleep(3)
      
      # Parroquia
      for(r in 1:10){ #Force it to retry 10 times before giving up...
        try({
          n_parroquia <- remDr$findElement(using = 'css selector', "#ddlParroquia")
          n_parroquia_temp <- unlist(n_parroquia$getElementText())
          n_parroquia_final <- as.numeric(length(unlist(str_split(n_parroquia_temp, pattern = "\\n"))))
          break #break/exit the for-loop
        }, silent = FALSE)
        Sys.sleep(5)
        print(paste0("r=",r))
      }
      
      for(k in 2:n_parroquia_final){ #Aqu'i retomo...
        parroquia <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlParroquia\"]/option[",k,"]", sep = "")) # Find k parroquia
        parroquia$clickElement() # Click
        
        Sys.sleep(3)
        
        # Zona
        for(s in 1:10){ #Force it to retry 10 times before giving up...
          try({
            n_zona <- remDr$findElement(using = 'css selector', "#ddlZona")
            n_zona_temp <- unlist(n_zona$getElementText())
            n_zona_final <- as.numeric(length(unlist(str_split(n_zona_temp, pattern = "\\n"))))
            break #break/exit the for-loop
          }, silent = FALSE)
          Sys.sleep(5)
          print(paste0("s=",s))
        }
        
        for(j in 2:n_zona_final){
          zona <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlZona\"]/option[",j,"]", sep = "")) # Find j zona
          zona$clickElement() # Click
          
          Sys.sleep(4)
          
          # Juntas...
          for(o in 1:10){ #Force it to retry 10 times before giving up...
            try({
              n_juntas <- remDr$findElement(using = 'css selector', "#ddlJunta")
              n_juntas_temp <- unlist(n_juntas$getElementText())
              n_juntas_final <- as.numeric(length(unlist(str_split(n_juntas_temp, pattern = "\\n"))))
              break #break/exit the for-loop
            }, silent = FALSE)
            Sys.sleep(5)
            print(paste0("o=",t))
            beep(2)
          }
          
          for(i in 2:n_juntas_final){
            junta <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlJunta\"]/option[",i,"]", sep = "")) # Find i junta
            junta$clickElement() # Click
            
            Sys.sleep(1)
            
            # Now click the consultar button to open the info... 
            for(o in 1:10){ #Force it to retry 10 times before giving up...
              try({
                consultar <- remDr$findElement(using = 'css selector', "#btnConsultar .text-uppercase")
                consultar$clickElement()
                break #break/exit the for-loop
              }, silent = FALSE)
              Sys.sleep(5)
              print(paste0("o=",t))
  
            }
            
            # Wait for the info to show... 
            Sys.sleep(3)
            
            # Now extract info 
            for(t in 1:10){ #Force it to retry 10 times before giving up...
              try({
                mesa_item <- remDr$findElement(using = "css selector", "#lblSubtitulo") # General info for the mesa
                mesa_temp <- unlist(mesa_item$getElementText()) # This I will eventually separate to get the info I need
                
                candidatos_item <- remDr$findElement(using = "css selector", "#tablaCandi") # Votes by candidate !
                candidatos_temp <- unlist(candidatos_item$getElementText()) # Horrible format but its the best I could do... I will clean it afterwards
                
                results_juntas_temp <- cbind.data.frame(mesa_temp,candidatos_temp,i,j,k,l,m,n) # cbind
                results_juntas <- rbind.data.frame(results_juntas,results_juntas_temp) # rbind
                break #break/exit the for-loop
              }, silent = FALSE)
              beep(2)
              Sys.sleep(5)
              print(paste0("t=",t))
              remDr$navigate("https://resultados.cne.gob.ec/")
              Sys.sleep(8)
              asam_button <- remDr$findElement(using = "css selector", ".m-1:nth-child(3) .myButtonDig")
              asam_button$clickElement()
              Sys.sleep(3)
              prov <- remDr$findElement(using = 'xpath',  paste("//*[@id=\"ddlProvincia\"]/option[",n,"]", sep = "")) #Pick the element from the drop down menu
              prov$clickElement() # Click
              Sys.sleep(5)
              circuns <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlCircunscripcion\"]/option[",m,"]", sep = "")) # Find m circunscription... 
              circuns$clickElement() # Click
              Sys.sleep(3)
              canton <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlCanton\"]/option[",l,"]", sep = "")) # Find l canton
              canton$clickElement() # Click
              Sys.sleep(3)
              parroquia <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlParroquia\"]/option[",k,"]", sep = "")) # Find k parroquia
              parroquia$clickElement() 
              Sys.sleep(3)
              zona <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlZona\"]/option[",j,"]", sep = "")) # Find j zona
              zona$clickElement()
              Sys.sleep(3)
              junta <- remDr$findElement(using = 'xpath', paste("//*[@id=\"ddlJunta\"]/option[",i,"]", sep = "")) # Find i junta
              junta$clickElement() 
              Sys.sleep(3)
              consultar <- remDr$findElement(using = 'css selector', "#btnConsultar .text-uppercase")
              consultar$clickElement()
              Sys.sleep(3)
            }
            mesa_temp <- NA # Fail safe in case i get errors... 
            candidatos_temp <- NA
            results_juntas_temp <- NA
            print(paste0("i=",i))
          }
          # beep(4)
          save(results_juntas, file = "results_juntas_asam_prov_c.Rdata") # Save just in case... 
          print(paste0("j=",j))
        }
        print(paste0("k=",k))
      }
      # beep(3)
      print(paste0("l=",l))
    }
    print(paste0("m=",m))
  }
  print(paste0("n=",n))
}


