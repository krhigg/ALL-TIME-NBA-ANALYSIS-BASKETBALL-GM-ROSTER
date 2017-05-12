
TEAMS <- c('ATL', 'BOS', 'BRK', 'CHO', 'CHI', 'CLE', 'DAL', 'DEN', 'DET', 'GSW', 'HOU', 'IND',
           'LAC', 'LAL', 'MEM', 'MIA', 'MIL', 'MIN', 'NOP', 'NYK', 'OKC', 'ORL', 'PHI', 'PHO', 'POR',
           'SAC', 'SAS', 'TOR', 'UTA', 'WAS')


require(plyr)

for( j in TEAMS){

  setwd(paste('D:/07-Statis Pro Basketball/06-Basketball Data/TEAMS/', j, sep = ''))
  temp <- list.files(pattern = '.csv')
  team.rip <- data.frame()
  
          for (i in 1:length(temp)) {
            
            season <- read.csv(temp[i], header = T, stringsAsFactors = F)
            season$YR <- as.numeric(substring(temp[i], 1,4))
            season$CITY <- substring(temp[i], 6,8)
            season <- season[, c(61:62, 1:60)]
            team.rip <- rbind(team.rip, season)
            #print(temp)
            
          }
  
# add champ or finals:
setwd('D:/07-Statis Pro Basketball/06-Basketball Data/AWARDS')
         
          CHAMP <- read.csv('08-champ.csv', header = T, stringsAsFactors = F)
          CIT <- unique(team.rip$CITY)
          TITLE <- CHAMP[CHAMP$CHAMP %in% CIT, c(1,4)]
          FINALS <- CHAMP[CHAMP$RU %in% CIT, c(1,6)]
          team.rip$TITLE <- ifelse(team.rip$YR %in% TITLE$Year & team.rip$CITY %in% TITLE$CHAMP, 1,0)
          team.rip$FINALS <- ifelse(team.rip$YR %in% FINALS$Year & team.rip$CITY %in% FINALS$RU, 1,0)
          team.rip$FINALS <- ifelse(team.rip$TITLE==1 & team.rip$FINALS==0, 1, team.rip$FINALS)
          # 1) must finish in top 10 for team in minutes played for season to count
          team.rip <- team.rip[team.rip$Rk <= 10, ]
  
# tenure is the key table that aggregates player performance WHILE WITH A SPECIFIC FRANCHISE:
            
  tenure <- ddply(team.rip, .(Player), summarise,
        SEASONS.TM = length(YR),
        MIN.YR = min(YR), 
        MAX.YR = max(YR),
        MIN.CIT = min(CITY),
        MAX.CIT = max(CITY),
        C = sum(ifelse(Pos =='C',1,0)),
        PF = sum(ifelse(Pos=='PF',1,0)),
        SF = sum(ifelse(Pos=='SF',1,0)),
        PG = sum(ifelse(Pos=='PG',1,0)),
        SG = sum(ifelse(Pos=='SG',1,0)),
        FG = sum(ifelse(Pos=='F-G',1,0)),
        FC = sum(ifelse(Pos=='F-C',1,0)),
        CF = sum(ifelse(Pos=='C-F',1,0)),
        MED.PER = median(PER, na.rm=T),
        MAX.PER = max(PER, na.rm=T),
        MED.WS = median(WS, na.rm=T),
        MAX.WS = max(WS, na.rm=T),
        MED.PTS = median(PTS),
        MED.RBD = median(TRB),
        MED.AST = median(AST),
        MED.FG = median(FG.),
        MED.3PA = median(X3PA),
        MED.3P = median(X3P.),
        MED.BLK = median(BLK),
        MED.STL = median(STL),
        MED.TOV = median(TOV),
        MED.PF = median(PF),
        MED.ORtg = median(ORtg),
        MED.DRtg = median(DRtg),
        FINALS = sum(FINALS),
        TITLES = sum(TITLE)
      
        )
  
  
# ALL D SUMMARY:
        
        all_d <- read.csv('01_all_d_search.csv', header= T, stringsAsFactors = F)
        search <- tenure$Player
        def <- all_d[all_d$NAME %in% search, ]
        def$YR <- as.numeric(paste(substring(def$SEASON, 1,2), substring(def$SEASON, 6,7), sep = ''))
        
        def <- merge(def, tenure, by.x = 'NAME', by.y = 'Player', all.x = T)
        def$WITHTEAM <- ifelse(def$YR >= def$MIN.YR & def$YR <= def$MAX.YR, 1,0 )
        
        def <- def[, c(1, 5, 38)]
        
        def <- ddply(def, .(NAME), summarise,
              All.D.1 = sum(ifelse(TEAM=='1st',WITHTEAM,0)),
              All.D.2 = sum(ifelse(TEAM=='2nd',WITHTEAM,0))
        )
        
        tenure <- merge(tenure, def, by.x = 'Player', by.y = 'NAME', all.x = T)
  
  
# ALL NBA SUMMARY:
        
        all_n <- read.csv('02-all_nba_search.csv', header= T, stringsAsFactors = F)
        require(stringr)
        all_n$NAME <- ifelse(all_n$X <= 840, str_sub(all_n$NAME, 1, str_length(all_n$NAME)-2), all_n$NAME)
        all_n <- all_n[all_n$NAME %in% search, ]
        
        all_n$YR <- as.numeric(paste(substring(all_n$SEASON, 1,2), substring(all_n$SEASON, 6,7), sep = ''))
        all_n <- merge(all_n, tenure, by.x = 'NAME', by.y = 'Player', all.x = T)
        
        all_n$WITHTEAM <- ifelse(all_n$YR >= all_n$MIN.YR & all_n$YR <= all_n$MAX.YR, 1,0 )
        
        names(all_n)
        all_n <- all_n[, c(1, 5, 40)]
        
        all_n <- ddply(all_n, .(NAME), summarise,
                     All.NBA.1 = sum(ifelse(TEAM=='1st',WITHTEAM,0)),
                     All.NBA.2 = sum(ifelse(TEAM=='2nd',WITHTEAM,0)),
                     All.NBA.3 = sum(ifelse(TEAM=='3rd',WITHTEAM,0))
        )
        
        tenure <- merge(tenure, all_n, by.x = 'Player', by.y = 'NAME', all.x = T)
  
  
  
# ALL STAR SUMMARY:
        
        AS <- read.csv('03-allstar.csv', header = T, stringsAsFactors = F)
        AS <- AS[AS$Player %in% search & AS$TM %in% CIT, ]
        
        AS <- ddply(AS, .(Player), summarise,
                       ALL.STAR = length(YR)
        )
        
        tenure <- merge(tenure, AS, by.x = 'Player', by.y = 'Player', all.x = T)
  

  
# MVP & RANKINGS:
# MVP win share of .167 99.9% you are in top 5
  
        MVP <- read.csv('05-mvp_voting.csv', header = T, stringsAsFactors = F)
        MVP <- MVP[MVP$Player %in% search , ]
        MVP$Rank2 <- as.numeric(ifelse(grepl('T', MVP$Rank), str_sub(MVP$Rank, 1, str_length(MVP$Rank)-1),MVP$Rank))
        
        MVP <-  merge(MVP, tenure, by.x = 'Player', by.y = 'Player', all.x = T)
        MVP$WITHTEAM <- ifelse(MVP$YR >= MVP$MIN.YR & MVP$YR <= MVP$MAX.YR, 1,0 )
          
        MVP <-  ddply(MVP[MVP$WITHTEAM==1, ], .(Player), summarise,
                MVP = sum(ifelse(Rank==1,1,0)),
                MVP.TOP5 = sum(ifelse(Share >= .167 & Rank != 1,1,0)),
                MVP.VOTES = sum(WITHTEAM),
                MVP.PEAK = min(ifelse(Rank > 1 & Share < .167, Rank2, NA))
          )
        
        tenure <- merge(tenure, MVP, by.x = 'Player', by.y = 'Player', all.x = TRUE)
  
  
# 6th Man
  
  
        SIX <- read.csv('06-six_voting.csv', header = T, stringsAsFactors = F)
        SIX$Rank2 <- as.numeric(ifelse(grepl('T', SIX$Rank), str_sub(SIX$Rank, 1, str_length(SIX$Rank)-1),SIX$Rank))
        
        SIX <- SIX[SIX$Player %in% search , ]
        
        SIX <-  merge(SIX, tenure, by.x = 'Player', by.y = 'Player', all.x = T)
        SIX$WITHTEAM <- ifelse(SIX$YR >= SIX$MIN.YR & SIX$YR <= SIX$MAX.YR, 1,0 )
        
        SIX <-  ddply(SIX[SIX$WITHTEAM==1, ], .(Player), summarise,
                      
                      SIX.TOP3 = sum(ifelse(Share >= .069,1,0)),
                      SIX.PEAK = min(Rank2)
        )
        
        tenure <- merge(tenure, SIX, by.x = 'Player', by.y = 'Player', all.x = TRUE)
        tenure <- tenure[order(-tenure$SEASONS.TM), ]
  
  
# SCORE ALL CAREERS
# AI SELECT RANKS ALL PLAYERS BASED ON PERFORMANCE WITH GIVEN FRANCHISE
# 
  
                          tenure$AI.SELECT <- tenure$SEASONS.TM + 
                          
                          ifelse(tenure$MED.PER < 12, -10,
                          ifelse(tenure$MED.PER >= 12 & tenure$MED.PER <= 14, -1.5,
                            ifelse(tenure$MED.PER >=18 & tenure$MED.PER <= 21, 1,
                                   ifelse(tenure$MED.PER >21 & tenure$MED.PER <=28, 2,
                                          ifelse(tenure$MED.PER >28, 3,0))))) +
                            
                              ifelse(tenure$MAX.PER <= 16, -1.5, 
                              ifelse(tenure$MAX.PER >=20 & tenure$MAX.PER <= 25, 2, 
                                   ifelse(tenure$MAX.PER > 25, 4, 0))) +
                            
                              ifelse(tenure$MED.WS >= 7 & tenure$MED.WS <= 9, 1,
                                     ifelse(tenure$MED.WS > 9, 2, 0)) +
                            
                            ifelse(tenure$MAX.WS >= 10 & tenure$MAX.WS <= 15, 1,
                                   ifelse(tenure$MAX.WS > 15, 2, 0)) +
                            
                              ifelse(tenure$MAX.YR <= 1960, -5, 0) +
                            
                            
                            ifelse(is.na(tenure$MED.3P), 0,
                                   ifelse(tenure$MED.3P >= .33 & tenure$MED.3P <= .37, 1,
                                          ifelse(tenure$MED.3P > .37 & tenure$MED.3P <= .399999, 1.5,
                                                 ifelse(tenure$MED.3P > .40, 3, 0)))) + 
                            
                            ifelse(is.na(tenure$All.D.1), 0, 
                                   tenure$All.D.1 * 2) + 
                            
                            ifelse(is.na(tenure$All.D.2), 0,
                                   tenure$All.D.2 * 1) +
                            
                            ifelse(is.na(tenure$All.NBA.1), 0,
                                   tenure$All.NBA.1 * 4) + 
                            
                            ifelse(is.na(tenure$All.NBA.2), 0,
                                   tenure$All.NBA.2 * 2.5) + 
                            
                            ifelse(is.na(tenure$All.NBA.3), 0,
                                   tenure$All.NBA.3 * 1.5) + 
                            
                            ifelse(is.na(tenure$ALL.STAR), 0,
                                   tenure$ALL.STAR * 1) + 
                            
                            ifelse(is.na(tenure$SIX.TOP3), 0,
                                   tenure$SIX.TOP3 * 1.5) + 
                            
                            ifelse(is.na(tenure$MVP), 0,
                                   tenure$MVP * 5) +
                            
                            ifelse(is.na(tenure$FINALS),0,
                                   tenure$FINALS * 1.5 ) +
                            
                            ifelse(is.na(tenure$TITLE), 0,
                                   tenure$TITLE * 3.5) + 
                            
                            ifelse(is.na(tenure$MED.ORtg), 0,
                                   (tenure$MED.ORtg - tenure$MED.DRtg) / 10)
  

  # 15 man roster with 3 Franchise players & 1 Face
       
        x <- head(tenure[tenure$PG >= 2 & (tenure$PG)/tenure$SEASONS.TM >.5, ],20)
        PG <- head(x[order(-x$AI.SELECT), ],n=6)
        PG$POS.AI <- '1-PG'
  
        x <- head(tenure[tenure$SG >= 2 & (tenure$SG)/tenure$SEASONS.TM >.5, ], 20)
        SG <- head(x[order(-x$AI.SELECT), ],n=6)
        SG$POS.AI <- '2-SG'
  
        x <- head(tenure[tenure$SF >= 2 & (tenure$SF)/tenure$SEASONS.TM >.5, ], 20)
        SF <- head(x[order(-x$AI.SELECT), ],n=6)
        SF$POS.AI <- '3-SF'
 
        x <- head(tenure[tenure$PF >= 2 & (tenure$PF)/tenure$SEASONS.TM >.5, ], 20)
        PF <- head(x[order(-x$AI.SELECT), ],n=6)
        PF$POS.AI <- '4-PF'
  
        x <- head(tenure[tenure$C >= 2 & (tenure$C)/tenure$SEASONS.TM >.5, ], 20)
        C <- head(x[order(-x$AI.SELECT), ],n=6)
        C$POS.AI <- '5-C'
  
#ROUND1:
  
      TM.1 <- rbind(PG,SG,SF,PF, C)
      x <-tenure[tenure$SEASONS.TM >= 2 & !tenure$Player %in% TM.1$Player, ]
      out <- head(x[order(-x$AI.SELECT), ],n=5)
      out$POS.AI <- '6-BH'
      TM.1 <- rbind(TM.1, out)
      TM.1 <- TM.1[order(TM.1$POS.AI, -TM.1$AI.SELECT), c(1, 46:45, 2:44)]
  
  rm(all_d); rm(all_n); rm(AS); rm(CHAMP); rm(def); rm(DP); rm(DPOY); rm(FINALS); rm(MVP); rm(season); rm(SIX); rm(TITLE)
  

  setwd("D:/07-Statis Pro Basketball/06-Basketball Data/TOP PLAYERS");list.files()
  write.csv(TM.1, paste(j, '_TOP.csv', sep = ''))
  
}
 