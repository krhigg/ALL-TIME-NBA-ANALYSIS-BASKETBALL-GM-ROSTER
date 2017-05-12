# ALL-TIME-NBA-ANALYSIS & BASKETBALL-GM-ROSTER
Custom NBA Upload File Plus Research Scripts in R

In Honor of my world-famous San Antonio Spurs reaching the conference finals I'll publish my first attempt at a franchise-based All Time NBA simulation file for Basketball GM.  

I've been researching this project for a while and had begun to code a simulation engine in R when I discovered Basketball GM.  This web engine was so good I decided not to duplicate the effort and just put my energy into selecting the best historic lineups for each NBA franchise so they can duke it out in a format we're all familiar with.  Spurs vs. Bulls?  Now it can happen.  Steph Curry and Draymond against Frazier, Reed and the Knicks?  It's here!

Lineups were mostly selected based on a simple scoring system that weighed (among other factors) years with the franchise, championships, All-NBA selections (and other major awards) as well as PER, WS and more traditional stats (PPG, RPG APG).  I did look at the distributions of the PER and WS statistic so I could weigh them with reasonable weights based on truly exceptional results. It should be notied that all selection criteria were based on player performances within the franchise to which the player was assigned. 

The logic I used to determine rosters is laid out in the TEAM SELECTION 030617 file.  The results of the script for each franchise are included (Top Players zip) so there's no need to re-run the R script for the output if you want to look over the historical files.  Open to any feedback or suggestions for 'experts' on a given franchise if you think I've missed key players.  The age of the player was pegged as the age they had their best year with the franchise. The default start year was 1999.  

Ratings were automated to some extent (height, free throws, 3pt & Defense) and researched (painstakingly) for others (Dunking, Post Play, etc).   

As far as salaries, my main goal was to have every team under the cap to maximize wheeling and dealing for players to improve their franchise with trades.  Max salary was $10m and I only assigned this to 2 or 3 players for each franchise (sometimes fewer for the weaker teams).  The worst teams are even under the cap so a player can hit the free-agent pool for a quick fix (you'll need to if you're playing as Minnesota, New Orleans, etc.)  

Note for historically strong franchises like the Lakers I meant the $10m 'max' to be an advantage that the franchise earned for having multiple franchise players with long tenures with the team.  For example, Magic, Kobe and Kareem all have 5 year deals for $10m.  Shaq also has a max of $10m but given his tenure in Orlando, Miami and Phoenix I had his contract expire in 2001.  

Open to other suggestions to make the game more balanced - my early runs showed the Lakers, Spurs, Warriors, Bulls dominating.  A few runs, interestingly, had the Sonics (sorry OKC) dominate as KD, Westbrook, Shawn Kemp and Gary Payton all had major leaps in talent.  

Finally, I did make some Basketball based judgement calls for players that had significant contributions for multiple teams.  For reasons of gameplay (and just plain fun) a given player could only be assigned to one franchise.  I tried to be fair and in the case of some of the newer franchises, just flat out gave them some borderline players in order to make the gameplay tolerable for some of the weaker teams.  

A few examples (and I would enjoy discussing opposing viewpoints on any of my selections):

Jason Kidd:  Assigned to New Jersey.  3x all star in Dallas with 1 title.  5x all star in NJ with 2 finals appearances (both lost).  I swung Kidd to the Nets primarily because Kidd was the best player on the 2 finals teams and secondarily because the Nets roster needed way more help than the Mavs.

Moses Malone: 6 seasons in Houston, 4 (real) in Philly.  Member of 82-83 title team swung him to Philly.

Charles Barkley: 8 years in Philly, 4 in Phoenix.  Assigned to Philly - had he won a title in Phoenix - maybe different.

Wilt Chamberlain:  Put him on the Warriors - just too much fun to have Wilt with Steph, Rick Barry and Klay Thompson.  

Anyway, obviously, I had a lot of fun doing this, and I hope the community can have some fun using this roster with the great basketball GM game.

Cheers!

Vespa_1933
