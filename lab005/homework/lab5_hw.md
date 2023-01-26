---
title: "dplyr Superhero"
date: "2023-01-26"
author: "Bode Wang"
output:
  html_document: 
    theme: spacelab
    toc: yes
    keep_md: yes
---

## Load the tidyverse

```r
library("tidyverse")
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
## ✔ ggplot2 3.4.0      ✔ purrr   1.0.0 
## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
## ✔ tidyr   1.2.1      ✔ stringr 1.5.0 
## ✔ readr   2.1.3      ✔ forcats 0.5.2 
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

## Load the superhero data
These are data taken from comic books and assembled by fans. The include a good mix of categorical and continuous data.  Data taken from: https://www.kaggle.com/claudiodavi/superhero-set  

Check out the way I am loading these data. If I know there are NAs, I can take care of them at the beginning. But, we should do this very cautiously. At times it is better to keep the original columns and data intact.  

```r
superhero_info <- readr::read_csv("data/heroes_information.csv", na = c("", "-99", "-"))
```

```
## Rows: 734 Columns: 10
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (8): name, Gender, Eye color, Race, Hair color, Publisher, Skin color, A...
## dbl (2): Height, Weight
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
superhero_info$Gender <- as.factor(superhero_info$Gender)
superhero_info$`Eye color` <- as.factor(superhero_info$`Eye color`)
superhero_info$Race <- as.factor(superhero_info$Race)
superhero_info$`Hair color` <- as.factor(superhero_info$`Hair color`)
superhero_info$Publisher <- as.factor(superhero_info$Publisher)
superhero_info$Alignment <- as.factor(superhero_info$Alignment)
superhero_info$`Skin color` <- as.factor(superhero_info$`Skin color`)
```


```r
superhero_powers <- readr::read_csv("data/super_hero_powers.csv", na = c("", "-99", "-"))
```

```
## Rows: 667 Columns: 168
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr   (1): hero_names
## lgl (167): Agility, Accelerated Healing, Lantern Power Ring, Dimensional Awa...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## Data tidy
1. Some of the names used in the `superhero_info` data are problematic so you should rename them here.  

```r
names(superhero_info) <- sub(" ", "_", tolower(names(superhero_info)))
names(superhero_info)
```

```
##  [1] "name"       "gender"     "eye_color"  "race"       "hair_color"
##  [6] "height"     "publisher"  "skin_color" "alignment"  "weight"
```

Yikes! `superhero_powers` has a lot of variables that are poorly named. We need some R superpowers...

```r
head(superhero_powers)
```

```
## # A tibble: 6 × 168
##   hero_…¹ Agility Accel…² Lante…³ Dimen…⁴ Cold …⁵ Durab…⁶ Stealth Energ…⁷ Flight
##   <chr>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl> 
## 1 3-D Man TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   FALSE 
## 2 A-Bomb  FALSE   TRUE    FALSE   FALSE   FALSE   TRUE    FALSE   FALSE   FALSE 
## 3 Abe Sa… TRUE    TRUE    FALSE   FALSE   TRUE    TRUE    FALSE   FALSE   FALSE 
## 4 Abin S… FALSE   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE 
## 5 Abomin… FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   FALSE   FALSE   FALSE 
## 6 Abraxas FALSE   FALSE   FALSE   TRUE    FALSE   FALSE   FALSE   FALSE   TRUE  
## # … with 158 more variables: `Danger Sense` <lgl>,
## #   `Underwater breathing` <lgl>, Marksmanship <lgl>, `Weapons Master` <lgl>,
## #   `Power Augmentation` <lgl>, `Animal Attributes` <lgl>, Longevity <lgl>,
## #   Intelligence <lgl>, `Super Strength` <lgl>, Cryokinesis <lgl>,
## #   Telepathy <lgl>, `Energy Armor` <lgl>, `Energy Blasts` <lgl>,
## #   Duplication <lgl>, `Size Changing` <lgl>, `Density Control` <lgl>,
## #   Stamina <lgl>, `Astral Travel` <lgl>, `Audio Control` <lgl>, …
```

```r
names(superhero_powers)
```

```
##   [1] "hero_names"                   "Agility"                     
##   [3] "Accelerated Healing"          "Lantern Power Ring"          
##   [5] "Dimensional Awareness"        "Cold Resistance"             
##   [7] "Durability"                   "Stealth"                     
##   [9] "Energy Absorption"            "Flight"                      
##  [11] "Danger Sense"                 "Underwater breathing"        
##  [13] "Marksmanship"                 "Weapons Master"              
##  [15] "Power Augmentation"           "Animal Attributes"           
##  [17] "Longevity"                    "Intelligence"                
##  [19] "Super Strength"               "Cryokinesis"                 
##  [21] "Telepathy"                    "Energy Armor"                
##  [23] "Energy Blasts"                "Duplication"                 
##  [25] "Size Changing"                "Density Control"             
##  [27] "Stamina"                      "Astral Travel"               
##  [29] "Audio Control"                "Dexterity"                   
##  [31] "Omnitrix"                     "Super Speed"                 
##  [33] "Possession"                   "Animal Oriented Powers"      
##  [35] "Weapon-based Powers"          "Electrokinesis"              
##  [37] "Darkforce Manipulation"       "Death Touch"                 
##  [39] "Teleportation"                "Enhanced Senses"             
##  [41] "Telekinesis"                  "Energy Beams"                
##  [43] "Magic"                        "Hyperkinesis"                
##  [45] "Jump"                         "Clairvoyance"                
##  [47] "Dimensional Travel"           "Power Sense"                 
##  [49] "Shapeshifting"                "Peak Human Condition"        
##  [51] "Immortality"                  "Camouflage"                  
##  [53] "Element Control"              "Phasing"                     
##  [55] "Astral Projection"            "Electrical Transport"        
##  [57] "Fire Control"                 "Projection"                  
##  [59] "Summoning"                    "Enhanced Memory"             
##  [61] "Reflexes"                     "Invulnerability"             
##  [63] "Energy Constructs"            "Force Fields"                
##  [65] "Self-Sustenance"              "Anti-Gravity"                
##  [67] "Empathy"                      "Power Nullifier"             
##  [69] "Radiation Control"            "Psionic Powers"              
##  [71] "Elasticity"                   "Substance Secretion"         
##  [73] "Elemental Transmogrification" "Technopath/Cyberpath"        
##  [75] "Photographic Reflexes"        "Seismic Power"               
##  [77] "Animation"                    "Precognition"                
##  [79] "Mind Control"                 "Fire Resistance"             
##  [81] "Power Absorption"             "Enhanced Hearing"            
##  [83] "Nova Force"                   "Insanity"                    
##  [85] "Hypnokinesis"                 "Animal Control"              
##  [87] "Natural Armor"                "Intangibility"               
##  [89] "Enhanced Sight"               "Molecular Manipulation"      
##  [91] "Heat Generation"              "Adaptation"                  
##  [93] "Gliding"                      "Power Suit"                  
##  [95] "Mind Blast"                   "Probability Manipulation"    
##  [97] "Gravity Control"              "Regeneration"                
##  [99] "Light Control"                "Echolocation"                
## [101] "Levitation"                   "Toxin and Disease Control"   
## [103] "Banish"                       "Energy Manipulation"         
## [105] "Heat Resistance"              "Natural Weapons"             
## [107] "Time Travel"                  "Enhanced Smell"              
## [109] "Illusions"                    "Thirstokinesis"              
## [111] "Hair Manipulation"            "Illumination"                
## [113] "Omnipotent"                   "Cloaking"                    
## [115] "Changing Armor"               "Power Cosmic"                
## [117] "Biokinesis"                   "Water Control"               
## [119] "Radiation Immunity"           "Vision - Telescopic"         
## [121] "Toxin and Disease Resistance" "Spatial Awareness"           
## [123] "Energy Resistance"            "Telepathy Resistance"        
## [125] "Molecular Combustion"         "Omnilingualism"              
## [127] "Portal Creation"              "Magnetism"                   
## [129] "Mind Control Resistance"      "Plant Control"               
## [131] "Sonar"                        "Sonic Scream"                
## [133] "Time Manipulation"            "Enhanced Touch"              
## [135] "Magic Resistance"             "Invisibility"                
## [137] "Sub-Mariner"                  "Radiation Absorption"        
## [139] "Intuitive aptitude"           "Vision - Microscopic"        
## [141] "Melting"                      "Wind Control"                
## [143] "Super Breath"                 "Wallcrawling"                
## [145] "Vision - Night"               "Vision - Infrared"           
## [147] "Grim Reaping"                 "Matter Absorption"           
## [149] "The Force"                    "Resurrection"                
## [151] "Terrakinesis"                 "Vision - Heat"               
## [153] "Vitakinesis"                  "Radar Sense"                 
## [155] "Qwardian Power Ring"          "Weather Control"             
## [157] "Vision - X-Ray"               "Vision - Thermal"            
## [159] "Web Creation"                 "Reality Warping"             
## [161] "Odin Force"                   "Symbiote Costume"            
## [163] "Speed Force"                  "Phoenix Force"               
## [165] "Molecular Dissipation"        "Vision - Cryo"               
## [167] "Omnipresent"                  "Omniscient"
```

## `janitor`
The [janitor](https://garthtarr.github.io/meatR/janitor.html) package is your friend. Make sure to install it and then load the library.  

```r
# install.packages("janitor")
library("janitor")
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

The `clean_names` function takes care of everything in one line! Now that's a superpower!

```r
superhero_powers <- janitor::clean_names(superhero_powers)
names(superhero_powers)
```

```
##   [1] "hero_names"                   "agility"                     
##   [3] "accelerated_healing"          "lantern_power_ring"          
##   [5] "dimensional_awareness"        "cold_resistance"             
##   [7] "durability"                   "stealth"                     
##   [9] "energy_absorption"            "flight"                      
##  [11] "danger_sense"                 "underwater_breathing"        
##  [13] "marksmanship"                 "weapons_master"              
##  [15] "power_augmentation"           "animal_attributes"           
##  [17] "longevity"                    "intelligence"                
##  [19] "super_strength"               "cryokinesis"                 
##  [21] "telepathy"                    "energy_armor"                
##  [23] "energy_blasts"                "duplication"                 
##  [25] "size_changing"                "density_control"             
##  [27] "stamina"                      "astral_travel"               
##  [29] "audio_control"                "dexterity"                   
##  [31] "omnitrix"                     "super_speed"                 
##  [33] "possession"                   "animal_oriented_powers"      
##  [35] "weapon_based_powers"          "electrokinesis"              
##  [37] "darkforce_manipulation"       "death_touch"                 
##  [39] "teleportation"                "enhanced_senses"             
##  [41] "telekinesis"                  "energy_beams"                
##  [43] "magic"                        "hyperkinesis"                
##  [45] "jump"                         "clairvoyance"                
##  [47] "dimensional_travel"           "power_sense"                 
##  [49] "shapeshifting"                "peak_human_condition"        
##  [51] "immortality"                  "camouflage"                  
##  [53] "element_control"              "phasing"                     
##  [55] "astral_projection"            "electrical_transport"        
##  [57] "fire_control"                 "projection"                  
##  [59] "summoning"                    "enhanced_memory"             
##  [61] "reflexes"                     "invulnerability"             
##  [63] "energy_constructs"            "force_fields"                
##  [65] "self_sustenance"              "anti_gravity"                
##  [67] "empathy"                      "power_nullifier"             
##  [69] "radiation_control"            "psionic_powers"              
##  [71] "elasticity"                   "substance_secretion"         
##  [73] "elemental_transmogrification" "technopath_cyberpath"        
##  [75] "photographic_reflexes"        "seismic_power"               
##  [77] "animation"                    "precognition"                
##  [79] "mind_control"                 "fire_resistance"             
##  [81] "power_absorption"             "enhanced_hearing"            
##  [83] "nova_force"                   "insanity"                    
##  [85] "hypnokinesis"                 "animal_control"              
##  [87] "natural_armor"                "intangibility"               
##  [89] "enhanced_sight"               "molecular_manipulation"      
##  [91] "heat_generation"              "adaptation"                  
##  [93] "gliding"                      "power_suit"                  
##  [95] "mind_blast"                   "probability_manipulation"    
##  [97] "gravity_control"              "regeneration"                
##  [99] "light_control"                "echolocation"                
## [101] "levitation"                   "toxin_and_disease_control"   
## [103] "banish"                       "energy_manipulation"         
## [105] "heat_resistance"              "natural_weapons"             
## [107] "time_travel"                  "enhanced_smell"              
## [109] "illusions"                    "thirstokinesis"              
## [111] "hair_manipulation"            "illumination"                
## [113] "omnipotent"                   "cloaking"                    
## [115] "changing_armor"               "power_cosmic"                
## [117] "biokinesis"                   "water_control"               
## [119] "radiation_immunity"           "vision_telescopic"           
## [121] "toxin_and_disease_resistance" "spatial_awareness"           
## [123] "energy_resistance"            "telepathy_resistance"        
## [125] "molecular_combustion"         "omnilingualism"              
## [127] "portal_creation"              "magnetism"                   
## [129] "mind_control_resistance"      "plant_control"               
## [131] "sonar"                        "sonic_scream"                
## [133] "time_manipulation"            "enhanced_touch"              
## [135] "magic_resistance"             "invisibility"                
## [137] "sub_mariner"                  "radiation_absorption"        
## [139] "intuitive_aptitude"           "vision_microscopic"          
## [141] "melting"                      "wind_control"                
## [143] "super_breath"                 "wallcrawling"                
## [145] "vision_night"                 "vision_infrared"             
## [147] "grim_reaping"                 "matter_absorption"           
## [149] "the_force"                    "resurrection"                
## [151] "terrakinesis"                 "vision_heat"                 
## [153] "vitakinesis"                  "radar_sense"                 
## [155] "qwardian_power_ring"          "weather_control"             
## [157] "vision_x_ray"                 "vision_thermal"              
## [159] "web_creation"                 "reality_warping"             
## [161] "odin_force"                   "symbiote_costume"            
## [163] "speed_force"                  "phoenix_force"               
## [165] "molecular_dissipation"        "vision_cryo"                 
## [167] "omnipresent"                  "omniscient"
```

## `tabyl`
The `janitor` package has many awesome functions that we will explore. Here is its version of `table` which not only produces counts but also percentages. Very handy! Let's use it to explore the proportion of good guys and bad guys in the `superhero_info` data.  


```r
tabyl(superhero_info, alignment)
```

```
##  alignment   n     percent valid_percent
##        bad 207 0.282016349    0.28473177
##       good 496 0.675749319    0.68225585
##    neutral  24 0.032697548    0.03301238
##       <NA>   7 0.009536785            NA
```

2. Notice that we have some neutral superheros! Who are they?

```r
neutral_heros <- superhero_info %>% filter(alignment == "neutral")
neutral_heros$name
```

```
##  [1] "Bizarro"         "Black Flash"     "Captain Cold"    "Copycat"        
##  [5] "Deadpool"        "Deathstroke"     "Etrigan"         "Galactus"       
##  [9] "Gladiator"       "Indigo"          "Juggernaut"      "Living Tribunal"
## [13] "Lobo"            "Man-Bat"         "One-Above-All"   "Raven"          
## [17] "Red Hood"        "Red Hulk"        "Robin VI"        "Sandman"        
## [21] "Sentry"          "Sinestro"        "The Comedian"    "Toad"
```

```r
rm(neutral_heros)
```

## `superhero_info`
3. Let's say we are only interested in the variables name, alignment, and "race". How would you isolate these variables from `superhero_info`?

```r
heros_info_interest <- superhero_info %>% select(name, alignment, race)
head(heros_info_interest)
```

```
## # A tibble: 6 × 3
##   name          alignment race             
##   <chr>         <fct>     <fct>            
## 1 A-Bomb        good      Human            
## 2 Abe Sapien    good      Icthyo Sapien    
## 3 Abin Sur      good      Ungaran          
## 4 Abomination   bad       Human / Radiation
## 5 Abraxas       bad       Cosmic Entity    
## 6 Absorbing Man bad       Human
```

```r
rm(heros_info_interest)
```

## Not Human
4. List all of the superheros that are not human.

```r
non_human_heros <- superhero_info %>% 
                   filter(!grepl("^(H|h)uman ?[A-Za-z/ ]*$", race))
tabyl(non_human_heros, race)
```

```
##                race   n     percent valid_percent
##               Alien   7 0.013752456   0.034146341
##               Alpha   5 0.009823183   0.024390244
##              Amazon   2 0.003929273   0.009756098
##             Android   9 0.017681729   0.043902439
##              Animal   4 0.007858546   0.019512195
##           Asgardian   5 0.009823183   0.024390244
##           Atlantean   5 0.009823183   0.024390244
##             Bizarro   1 0.001964637   0.004878049
##          Bolovaxian   1 0.001964637   0.004878049
##               Clone   1 0.001964637   0.004878049
##       Cosmic Entity   4 0.007858546   0.019512195
##              Cyborg  11 0.021611002   0.053658537
##            Czarnian   1 0.001964637   0.004878049
##  Dathomirian Zabrak   1 0.001964637   0.004878049
##            Demi-God   2 0.003929273   0.009756098
##               Demon   6 0.011787819   0.029268293
##             Eternal   2 0.003929273   0.009756098
##      Flora Colossus   1 0.001964637   0.004878049
##         Frost Giant   2 0.003929273   0.009756098
##       God / Eternal  14 0.027504912   0.068292683
##             Gorilla   1 0.001964637   0.004878049
##              Gungan   1 0.001964637   0.004878049
##               Human   0 0.000000000   0.000000000
##          Human-Kree   2 0.003929273   0.009756098
##       Human-Spartoi   1 0.001964637   0.004878049
##        Human-Vulcan   1 0.001964637   0.004878049
##     Human-Vuldarian   1 0.001964637   0.004878049
##     Human / Altered   0 0.000000000   0.000000000
##       Human / Clone   0 0.000000000   0.000000000
##      Human / Cosmic   0 0.000000000   0.000000000
##   Human / Radiation   0 0.000000000   0.000000000
##       Icthyo Sapien   1 0.001964637   0.004878049
##             Inhuman   4 0.007858546   0.019512195
##               Kaiju   1 0.001964637   0.004878049
##     Kakarantharaian   1 0.001964637   0.004878049
##           Korugaran   1 0.001964637   0.004878049
##          Kryptonian   7 0.013752456   0.034146341
##           Luphomoid   1 0.001964637   0.004878049
##               Maiar   1 0.001964637   0.004878049
##             Martian   1 0.001964637   0.004878049
##           Metahuman   2 0.003929273   0.009756098
##              Mutant  63 0.123772102   0.307317073
##      Mutant / Clone   1 0.001964637   0.004878049
##             New God   3 0.005893910   0.014634146
##            Neyaphem   1 0.001964637   0.004878049
##           Parademon   1 0.001964637   0.004878049
##              Planet   1 0.001964637   0.004878049
##              Rodian   1 0.001964637   0.004878049
##              Saiyan   2 0.003929273   0.009756098
##             Spartoi   1 0.001964637   0.004878049
##           Strontian   1 0.001964637   0.004878049
##            Symbiote   9 0.017681729   0.043902439
##            Talokite   1 0.001964637   0.004878049
##          Tamaranean   1 0.001964637   0.004878049
##             Ungaran   1 0.001964637   0.004878049
##             Vampire   2 0.003929273   0.009756098
##     Xenomorph XX121   1 0.001964637   0.004878049
##              Yautja   1 0.001964637   0.004878049
##      Yoda's species   1 0.001964637   0.004878049
##       Zen-Whoberian   1 0.001964637   0.004878049
##              Zombie   1 0.001964637   0.004878049
##                <NA> 304 0.597249509            NA
```

```r
non_human_heros$name
```

```
##   [1] "Abe Sapien"                "Abin Sur"                 
##   [3] "Abraxas"                   "Adam Monroe"              
##   [5] "Agent 13"                  "Agent Zero"               
##   [7] "Air-Walker"                "Ajax"                     
##   [9] "Alan Scott"                "Alex Woolsly"             
##  [11] "Alien"                     "Allan Quatermain"         
##  [13] "Amazo"                     "Ando Masahashi"           
##  [15] "Angel"                     "Angel"                    
##  [17] "Angel Dust"                "Angel Salvadore"          
##  [19] "Angela"                    "Annihilus"                
##  [21] "Anti-Monitor"              "Anti-Spawn"               
##  [23] "Anti-Venom"                "Apocalypse"               
##  [25] "Aquababy"                  "Aqualad"                  
##  [27] "Aquaman"                   "Archangel"                
##  [29] "Arclight"                  "Ardina"                   
##  [31] "Ares"                      "Ariel"                    
##  [33] "Armor"                     "Astro Boy"                
##  [35] "Atlas"                     "Atlas"                    
##  [37] "Atom"                      "Atom"                     
##  [39] "Atom Girl"                 "Atom III"                 
##  [41] "Atom IV"                   "Aurora"                   
##  [43] "Azazel"                    "Aztar"                    
##  [45] "Bantam"                    "Batgirl"                  
##  [47] "Batgirl III"               "Batgirl V"                
##  [49] "Batgirl VI"                "Battlestar"               
##  [51] "Beak"                      "Beast"                    
##  [53] "Beetle"                    "Ben 10"                   
##  [55] "Beta Ray Bill"             "Beyonder"                 
##  [57] "Big Barda"                 "Big Daddy"                
##  [59] "Big Man"                   "Bill Harken"              
##  [61] "Billy Kincaid"             "Binary"                   
##  [63] "Bionic Woman"              "Bird-Brain"               
##  [65] "Birdman"                   "Bishop"                   
##  [67] "Bizarro"                   "Black Abbott"             
##  [69] "Black Adam"                "Black Bolt"               
##  [71] "Black Canary"              "Black Flash"              
##  [73] "Black Goliath"             "Black Lightning"          
##  [75] "Black Mamba"               "Black Widow II"           
##  [77] "Blackout"                  "Blackwing"                
##  [79] "Blackwulf"                 "Blade"                    
##  [81] "Blaquesmith"               "Bling!"                   
##  [83] "Blink"                     "Blizzard"                 
##  [85] "Blizzard"                  "Blizzard II"              
##  [87] "Blob"                      "Bloodhawk"                
##  [89] "Bloodwraith"               "Blue Beetle"              
##  [91] "Blue Beetle"               "Blue Beetle II"           
##  [93] "Bolt"                      "Bomb Queen"               
##  [95] "Boom-Boom"                 "Boomer"                   
##  [97] "Box"                       "Box III"                  
##  [99] "Box IV"                    "Brainiac"                 
## [101] "Brainiac 5"                "Brundlefly"               
## [103] "Bumbleboy"                 "Cable"                    
## [105] "Callisto"                  "Cameron Hicks"            
## [107] "Cannonball"                "Captain Epic"             
## [109] "Captain Mar-vell"          "Captain Marvel"           
## [111] "Captain Planet"            "Captain Universe"         
## [113] "Carnage"                   "Cat"                      
## [115] "Cat II"                    "Cecilia Reyes"            
## [117] "Century"                   "Cerebra"                  
## [119] "Chamber"                   "Chameleon"                
## [121] "Changeling"                "Chromos"                  
## [123] "Chuck Norris"              "Claire Bennet"            
## [125] "Clea"                      "Cloak"                    
## [127] "Cogliostro"                "Colin Wagner"             
## [129] "Colossal Boy"              "Colossus"                 
## [131] "Copycat"                   "Corsair"                  
## [133] "Crimson Crusader"          "Crimson Dynamo"           
## [135] "Crystal"                   "Curse"                    
## [137] "Cy-Gor"                    "Cyborg"                   
## [139] "Cyborg Superman"           "Cyclops"                  
## [141] "Cypher"                    "Dagger"                   
## [143] "Danny Cooper"              "Daphne Powell"            
## [145] "Darkman"                   "Darkseid"                 
## [147] "Darkside"                  "Darkstar"                 
## [149] "Darth Maul"                "Darth Vader"              
## [151] "Data"                      "Dazzler"                  
## [153] "Deadpool"                  "Deathlok"                 
## [155] "Demogoblin"                "Destroyer"                
## [157] "DL Hawkins"                "Doctor Doom II"           
## [159] "Donatello"                 "Donna Troy"               
## [161] "Doomsday"                  "Doppelganger"             
## [163] "Dormammu"                  "Ego"                      
## [165] "Elle Bishop"               "Elongated Man"            
## [167] "Emma Frost"                "Energy"                   
## [169] "ERG-1"                     "Etrigan"                  
## [171] "Evil Deadpool"             "Evilhawk"                 
## [173] "Exodus"                    "Fabian Cortez"            
## [175] "Fallen One II"             "Faora"                    
## [177] "Feral"                     "Fighting Spirit"          
## [179] "Fin Fang Foom"             "Firebird"                 
## [181] "Firelord"                  "Firestar"                 
## [183] "Firestorm"                 "Fixer"                    
## [185] "Flash Gordon"              "Forge"                    
## [187] "Franklin Richards"         "Franklin Storm"           
## [189] "Frenzy"                    "Frigga"                   
## [191] "Galactus"                  "Gambit"                   
## [193] "Gamora"                    "Garbage Man"              
## [195] "Gary Bell"                 "General Zod"              
## [197] "Genesis"                   "Ghost Rider"              
## [199] "Ghost Rider II"            "Giant-Man II"             
## [201] "Giganta"                   "Gladiator"                
## [203] "Goblin Queen"              "Godzilla"                 
## [205] "Gog"                       "Goku"                     
## [207] "Goliath"                   "Goliath IV"               
## [209] "Gorilla Grodd"             "Granny Goodness"          
## [211] "Greedo"                    "Green Goblin II"          
## [213] "Green Goblin III"          "Green Goblin IV"          
## [215] "Groot"                     "Guy Gardner"              
## [217] "Havok"                     "Hawk"                     
## [219] "Hawkgirl"                  "Hawkman"                  
## [221] "Hawkwoman"                 "Hawkwoman II"             
## [223] "Hawkwoman III"             "Hela"                     
## [225] "Hellboy"                   "Hellstorm"                
## [227] "Hercules"                  "Hiro Nakamura"            
## [229] "Hobgoblin"                 "Hollow"                   
## [231] "Hope Summers"              "Howard the Duck"          
## [233] "Huntress"                  "Husk"                     
## [235] "Hybrid"                    "Hydro-Man"                
## [237] "Hyperion"                  "Iceman"                   
## [239] "Indigo"                    "Ink"                      
## [241] "Iron Monger"               "Isis"                     
## [243] "Jack Bauer"                "Jar Jar Binks"            
## [245] "Jean Grey"                 "Jennifer Kale"            
## [247] "Jessica Sanders"           "Jigsaw"                   
## [249] "Jim Powell"                "JJ Powell"                
## [251] "Johann Krauss"             "John Wraith"              
## [253] "Jolt"                      "Jubilee"                  
## [255] "Junkpile"                  "K-2SO"                    
## [257] "Kang"                      "Kid Flash II"             
## [259] "Killer Croc"               "Kilowog"                  
## [261] "King Kong"                 "King Shark"               
## [263] "Kool-Aid Man"              "Krypto"                   
## [265] "Lady Bullseye"             "Lady Deathstrike"         
## [267] "Leader"                    "Leech"                    
## [269] "Legion"                    "Leonardo"                 
## [271] "Light Lass"                "Lightning Lad"            
## [273] "Lightning Lord"            "Living Brain"             
## [275] "Living Tribunal"           "Liz Sherman"              
## [277] "Lobo"                      "Loki"                     
## [279] "Luke Campbell"             "Lyja"                     
## [281] "Mach-IV"                   "Machine Man"              
## [283] "Magneto"                   "Magog"                    
## [285] "Magus"                     "Man of Miracles"          
## [287] "Man-Thing"                 "Man-Wolf"                 
## [289] "Mantis"                    "Martian Manhunter"        
## [291] "Marvel Girl"               "Master Brood"             
## [293] "Match"                     "Matt Parkman"             
## [295] "Maverick"                  "Maxima"                   
## [297] "Maya Herrera"              "Medusa"                   
## [299] "Meltdown"                  "Mephisto"                 
## [301] "Mera"                      "Metallo"                  
## [303] "Metamorpho"                "Meteorite"                
## [305] "Metron"                    "Micah Sanders"            
## [307] "Michelangelo"              "Micro Lad"                
## [309] "Mimic"                     "Minna Murray"             
## [311] "Misfit"                    "Miss Martian"             
## [313] "Mister Knife"              "Mister Mxyzptlk"          
## [315] "MODOK"                     "Mogo"                     
## [317] "Mohinder Suresh"           "Moloch"                   
## [319] "Molten Man"                "Monarch"                  
## [321] "Monica Dawson"             "Moonstone"                
## [323] "Morlun"                    "Morph"                    
## [325] "Moses Magnum"              "Mr Immortal"              
## [327] "Ms Marvel II"              "Multiple Man"             
## [329] "Mystique"                  "Namor"                    
## [331] "Namor"                     "Namora"                   
## [333] "Namorita"                  "Nathan Petrelli"          
## [335] "Nebula"                    "Negasonic Teenage Warhead"
## [337] "Nightcrawler"              "Niki Sanders"             
## [339] "Nina Theroux"              "Nite Owl II"              
## [341] "Northstar"                 "Odin"                     
## [343] "Offspring"                 "Omega Red"                
## [345] "Omniscient"                "One-Above-All"            
## [347] "Onslaught"                 "Osiris"                   
## [349] "Overtkill"                 "Parademon"                
## [351] "Penance"                   "Penance I"                
## [353] "Penance II"                "Peter Petrelli"           
## [355] "Phantom"                   "Phantom Girl"             
## [357] "Phoenix"                   "Plantman"                 
## [359] "Plastic Lad"               "Plastique"                
## [361] "Polaris"                   "Power Girl"               
## [363] "Power Man"                 "Predator"                 
## [365] "Professor X"               "Proto-Goblin"             
## [367] "Psylocke"                  "Pyro"                     
## [369] "Q"                         "Quantum"                  
## [371] "Quicksilver"               "Quill"                    
## [373] "Rachel Pirzad"             "Raphael"                  
## [375] "Razor-Fist II"             "Red Mist"                 
## [377] "Red Skull"                 "Red Tornado"              
## [379] "Redeemer II"               "Redeemer III"             
## [381] "Renata Soliz"              "Rick Flag"                
## [383] "Riddler"                   "Ripcord"                  
## [385] "Rocket Raccoon"            "Rogue"                    
## [387] "Sabretooth"                "Sage"                     
## [389] "Sasquatch"                 "Sauron"                   
## [391] "Savage Dragon"             "Scarlet Spider II"        
## [393] "Scarlet Witch"             "Scorpia"                  
## [395] "Sebastian Shaw"            "Sentry"                   
## [397] "Shadow King"               "Shadow Lass"              
## [399] "Shadowcat"                 "Shatterstar"              
## [401] "Shriek"                    "Shrinking Violet"         
## [403] "Sif"                       "Silk Spectre"             
## [405] "Silk Spectre II"           "Silver Surfer"            
## [407] "Silverclaw"                "Sinestro"                 
## [409] "Siren"                     "Siren II"                 
## [411] "Siryn"                     "Skaar"                    
## [413] "Snake-Eyes"                "Snowbird"                 
## [415] "Sobek"                     "Solomon Grundy"           
## [417] "Songbird"                  "Spawn"                    
## [419] "Spectre"                   "Speedball"                
## [421] "Spider-Carnage"            "Spider-Woman II"          
## [423] "Spider-Woman III"          "Spider-Woman IV"          
## [425] "Spock"                     "Spyke"                    
## [427] "Stacy X"                   "Star-Lord"                
## [429] "Stardust"                  "Starfire"                 
## [431] "Static"                    "Steel"                    
## [433] "Stephanie Powell"          "Steppenwolf"              
## [435] "Storm"                     "Sunspot"                  
## [437] "Superboy"                  "Superboy-Prime"           
## [439] "Supergirl"                 "Superman"                 
## [441] "Swamp Thing"               "Swarm"                    
## [443] "Sylar"                     "Synch"                    
## [445] "T-1000"                    "T-800"                    
## [447] "T-850"                     "T-X"                      
## [449] "Tempest"                   "Thanos"                   
## [451] "The Cape"                  "Thor"                     
## [453] "Thor Girl"                 "Thunderbird"              
## [455] "Thunderbird II"            "Thunderbird III"          
## [457] "Thunderstrike"             "Thundra"                  
## [459] "Tigra"                     "Tinkerer"                 
## [461] "Titan"                     "Toad"                     
## [463] "Toxin"                     "Toxin"                    
## [465] "Tracy Strauss"             "Trigon"                   
## [467] "Triplicate Girl"           "Triton"                   
## [469] "Two-Face"                  "Ultragirl"                
## [471] "Ultron"                    "Utgard-Loki"              
## [473] "Vagabond"                  "Valerie Hart"             
## [475] "Valkyrie"                  "Vanisher"                 
## [477] "Vegeta"                    "Venom"                    
## [479] "Venom II"                  "Venom III"                
## [481] "Venompool"                 "Vertigo II"               
## [483] "Vindicator"                "Violator"                 
## [485] "Vision"                    "Vision II"                
## [487] "Vulcan"                    "Warbird"                  
## [489] "Warlock"                   "Warp"                     
## [491] "Warpath"                   "Watcher"                  
## [493] "Weapon XI"                 "White Queen"              
## [495] "Wildfire"                  "Wiz Kid"                  
## [497] "Wolfsbane"                 "Wolverine"                
## [499] "Wonder Girl"               "Wonder Man"               
## [501] "Wonder Woman"              "Wondra"                   
## [503] "Wyatt Wingfoot"            "X-23"                     
## [505] "X-Man"                     "Yellow Claw"              
## [507] "Ymir"                      "Yoda"                     
## [509] "Zoom"
```

```r
rm(non_human_heros)
```

## Good and Evil
5. Let's make two different data frames, one focused on the "good guys" and another focused on the "bad guys".

```r
good_guys <- superhero_info %>% filter(alignment == "good")
head(good_guys)
```

```
## # A tibble: 6 × 10
##   name        gender eye_c…¹ race  hair_…² height publi…³ skin_…⁴ align…⁵ weight
##   <chr>       <fct>  <fct>   <fct> <fct>    <dbl> <fct>   <fct>   <fct>    <dbl>
## 1 A-Bomb      Male   yellow  Human No Hair    203 Marvel… <NA>    good       441
## 2 Abe Sapien  Male   blue    Icth… No Hair    191 Dark H… blue    good        65
## 3 Abin Sur    Male   blue    Unga… No Hair    185 DC Com… red     good        90
## 4 Adam Monroe Male   blue    <NA>  Blond       NA NBC - … <NA>    good        NA
## 5 Adam Stran… Male   blue    Human Blond      185 DC Com… <NA>    good        88
## 6 Agent 13    Female blue    <NA>  Blond      173 Marvel… <NA>    good        61
## # … with abbreviated variable names ¹​eye_color, ²​hair_color, ³​publisher,
## #   ⁴​skin_color, ⁵​alignment
```


```r
bad_guys <- superhero_info %>% filter(alignment == "bad")
head(bad_guys)
```

```
## # A tibble: 6 × 10
##   name        gender eye_c…¹ race  hair_…² height publi…³ skin_…⁴ align…⁵ weight
##   <chr>       <fct>  <fct>   <fct> <fct>    <dbl> <fct>   <fct>   <fct>    <dbl>
## 1 Abomination Male   green   Huma… No Hair    203 Marvel… <NA>    bad        441
## 2 Abraxas     Male   blue    Cosm… Black       NA Marvel… <NA>    bad         NA
## 3 Absorbing … Male   blue    Human No Hair    193 Marvel… <NA>    bad        122
## 4 Air-Walker  Male   blue    <NA>  White      188 Marvel… <NA>    bad        108
## 5 Ajax        Male   brown   Cybo… Black      193 Marvel… <NA>    bad         90
## 6 Alex Mercer Male   <NA>    Human <NA>        NA Wildst… <NA>    bad         NA
## # … with abbreviated variable names ¹​eye_color, ²​hair_color, ³​publisher,
## #   ⁴​skin_color, ⁵​alignment
```

6. For the good guys, use the `tabyl` function to summarize their "race".

```r
tabyl(good_guys, race)
```

```
##                race   n     percent valid_percent
##               Alien   3 0.006048387   0.010752688
##               Alpha   5 0.010080645   0.017921147
##              Amazon   2 0.004032258   0.007168459
##             Android   4 0.008064516   0.014336918
##              Animal   2 0.004032258   0.007168459
##           Asgardian   3 0.006048387   0.010752688
##           Atlantean   4 0.008064516   0.014336918
##             Bizarro   0 0.000000000   0.000000000
##          Bolovaxian   1 0.002016129   0.003584229
##               Clone   1 0.002016129   0.003584229
##       Cosmic Entity   0 0.000000000   0.000000000
##              Cyborg   3 0.006048387   0.010752688
##            Czarnian   0 0.000000000   0.000000000
##  Dathomirian Zabrak   0 0.000000000   0.000000000
##            Demi-God   2 0.004032258   0.007168459
##               Demon   3 0.006048387   0.010752688
##             Eternal   1 0.002016129   0.003584229
##      Flora Colossus   1 0.002016129   0.003584229
##         Frost Giant   1 0.002016129   0.003584229
##       God / Eternal   6 0.012096774   0.021505376
##             Gorilla   0 0.000000000   0.000000000
##              Gungan   1 0.002016129   0.003584229
##               Human 148 0.298387097   0.530465950
##          Human-Kree   2 0.004032258   0.007168459
##       Human-Spartoi   1 0.002016129   0.003584229
##        Human-Vulcan   1 0.002016129   0.003584229
##     Human-Vuldarian   1 0.002016129   0.003584229
##     Human / Altered   2 0.004032258   0.007168459
##       Human / Clone   0 0.000000000   0.000000000
##      Human / Cosmic   2 0.004032258   0.007168459
##   Human / Radiation   8 0.016129032   0.028673835
##       Icthyo Sapien   1 0.002016129   0.003584229
##             Inhuman   4 0.008064516   0.014336918
##               Kaiju   0 0.000000000   0.000000000
##     Kakarantharaian   1 0.002016129   0.003584229
##           Korugaran   0 0.000000000   0.000000000
##          Kryptonian   4 0.008064516   0.014336918
##           Luphomoid   0 0.000000000   0.000000000
##               Maiar   0 0.000000000   0.000000000
##             Martian   1 0.002016129   0.003584229
##           Metahuman   1 0.002016129   0.003584229
##              Mutant  46 0.092741935   0.164874552
##      Mutant / Clone   1 0.002016129   0.003584229
##             New God   0 0.000000000   0.000000000
##            Neyaphem   0 0.000000000   0.000000000
##           Parademon   0 0.000000000   0.000000000
##              Planet   1 0.002016129   0.003584229
##              Rodian   0 0.000000000   0.000000000
##              Saiyan   1 0.002016129   0.003584229
##             Spartoi   0 0.000000000   0.000000000
##           Strontian   0 0.000000000   0.000000000
##            Symbiote   3 0.006048387   0.010752688
##            Talokite   1 0.002016129   0.003584229
##          Tamaranean   1 0.002016129   0.003584229
##             Ungaran   1 0.002016129   0.003584229
##             Vampire   2 0.004032258   0.007168459
##     Xenomorph XX121   0 0.000000000   0.000000000
##              Yautja   0 0.000000000   0.000000000
##      Yoda's species   1 0.002016129   0.003584229
##       Zen-Whoberian   1 0.002016129   0.003584229
##              Zombie   0 0.000000000   0.000000000
##                <NA> 217 0.437500000            NA
```

7. Among the good guys, Who are the Asgardians?

```r
good_guys_asgardian <- good_guys %>% filter(race == "Asgardian")
good_guys_asgardian$name
```

```
## [1] "Sif"       "Thor"      "Thor Girl"
```

```r
rm(good_guys_asgardian)
```

8. Among the bad guys, who are the male humans over 200 inches in height?

```r
bad_guys_tall <- bad_guys %>% filter(height > 200)
bad_guys_tall$name
```

```
##  [1] "Abomination"    "Alien"          "Amazo"          "Apocalypse"    
##  [5] "Bane"           "Bloodaxe"       "Darkseid"       "Doctor Doom"   
##  [9] "Doctor Doom II" "Doomsday"       "Frenzy"         "Hela"          
## [13] "Killer Croc"    "Kingpin"        "Lizard"         "MODOK"         
## [17] "Omega Red"      "Onslaught"      "Predator"       "Sauron"        
## [21] "Scorpion"       "Solomon Grundy" "Thanos"         "Ultron"        
## [25] "Venom III"
```

```r
rm(bad_guys_tall)
```

9. OK, so are there more good guys or bad guys that are bald (personal interest)?

```r
levels(good_guys$hair_color)
```

```
##  [1] "Auburn"           "black"            "Black"            "Black / Blue"    
##  [5] "blond"            "Blond"            "Blue"             "Brown"           
##  [9] "Brown / Black"    "Brown / White"    "Brownn"           "Gold"            
## [13] "Green"            "Grey"             "Indigo"           "Magenta"         
## [17] "No Hair"          "Orange"           "Orange / White"   "Pink"            
## [21] "Purple"           "Red"              "Red / Grey"       "Red / Orange"    
## [25] "Red / White"      "Silver"           "Strawberry Blond" "White"           
## [29] "Yellow"
```

```r
good_bald_count <- good_guys %>% filter(hair_color == "No Hear") %>% nrow()
levels(bad_guys$hair_color)
```

```
##  [1] "Auburn"           "black"            "Black"            "Black / Blue"    
##  [5] "blond"            "Blond"            "Blue"             "Brown"           
##  [9] "Brown / Black"    "Brown / White"    "Brownn"           "Gold"            
## [13] "Green"            "Grey"             "Indigo"           "Magenta"         
## [17] "No Hair"          "Orange"           "Orange / White"   "Pink"            
## [21] "Purple"           "Red"              "Red / Grey"       "Red / Orange"    
## [25] "Red / White"      "Silver"           "Strawberry Blond" "White"           
## [29] "Yellow"
```

```r
bad_bald_count <- bad_guys %>% filter(hair_color == "No Hair") %>% nrow()
if(good_bald_count > bad_bald_count) {
  print("more good guys are bald")
}else {
   print("more bad guys are bald")
}
```

```
## [1] "more bad guys are bald"
```

```r
rm(good_bald_count)
rm(bad_bald_count)
```


10.  Let's explore who the really "big" superheros are. In the `superhero_info` data, which have a height over 200 or weight greater than or equal to 450?

> do you mean 300 in this question? 


```r
big_heros <- superhero_info %>% filter(height > 300 | weight >= 450)
nrow(big_heros)
```

```
## [1] 14
```

```r
big_heros$name
```

```
##  [1] "Bloodaxe"      "Darkseid"      "Fin Fang Foom" "Galactus"     
##  [5] "Giganta"       "Groot"         "Hulk"          "Juggernaut"   
##  [9] "MODOK"         "Onslaught"     "Red Hulk"      "Sasquatch"    
## [13] "Wolfsbane"     "Ymir"
```

1.  Just to be clear on the `|` operator,  have a look at the superheros over 300 in height...

```r
tall_hero <- filter(superhero_info, height > 300)
nrow(tall_hero)
```

```
## [1] 8
```

1.  ...and the superheros over 450 in weight. Bonus question! Why do we not have 16 rows in question #10?

```r
heavy_hero <- filter(superhero_info, weight >= 450)
nrow(heavy_hero)
```

```
## [1] 8
```


```r
# because two heros are both tall and heavy
intersect(heavy_hero$name, tall_hero$name)
```

```
## [1] "Sasquatch" "Wolfsbane"
```

## Height to Weight Ratio
13. It's easy to be strong when you are heavy and tall, but who is heavy and short? Which superheros have the highest height to weight ratio?

```r
superhero_info_ratio <- superhero_info %>%
                        mutate(ratio = height / weight) %>%
                        select(name, ratio, height, weight) %>%
                        arrange(desc(ratio))
dim(superhero_info_ratio)
```

```
## [1] 734   4
```

```r
head(superhero_info_ratio, n=10)
```

```
## # A tibble: 10 × 4
##    name             ratio height weight
##    <chr>            <dbl>  <dbl>  <dbl>
##  1 Groot           175.      701      4
##  2 Galactus         54.8     876     16
##  3 Fin Fang Foom    54.2     975     18
##  4 Longshot          5.22    188     36
##  5 Jack-Jack         5.07     71     14
##  6 Rocket Raccoon    4.88    122     25
##  7 Dash              4.52    122     27
##  8 Howard the Duck   4.39     79     18
##  9 Swarm             4.17    196     47
## 10 Yoda              3.88     66     17
```

## `superhero_powers`
Have a quick look at the `superhero_powers` data frame.  

```r
glimpse(superhero_powers)
```

```
## Rows: 667
## Columns: 168
## $ hero_names                   <chr> "3-D Man", "A-Bomb", "Abe Sapien", "Abin …
## $ agility                      <lgl> TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, F…
## $ accelerated_healing          <lgl> FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, FA…
## $ lantern_power_ring           <lgl> FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, …
## $ dimensional_awareness        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ cold_resistance              <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ durability                   <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, T…
## $ stealth                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_absorption            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ flight                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ danger_sense                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ underwater_breathing         <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ marksmanship                 <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ weapons_master               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ power_augmentation           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animal_attributes            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ longevity                    <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, F…
## $ intelligence                 <lgl> FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FA…
## $ super_strength               <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE…
## $ cryokinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ telepathy                    <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ energy_armor                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_blasts                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ duplication                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ size_changing                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ density_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ stamina                      <lgl> TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FAL…
## $ astral_travel                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ audio_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ dexterity                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnitrix                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ super_speed                  <lgl> TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, FA…
## $ possession                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animal_oriented_powers       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ weapon_based_powers          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ electrokinesis               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ darkforce_manipulation       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ death_touch                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ teleportation                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ enhanced_senses              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ telekinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_beams                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ magic                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ hyperkinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ jump                         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ clairvoyance                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ dimensional_travel           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ power_sense                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ shapeshifting                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ peak_human_condition         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ immortality                  <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, F…
## $ camouflage                   <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, …
## $ element_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ phasing                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ astral_projection            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ electrical_transport         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ fire_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ projection                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ summoning                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_memory              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ reflexes                     <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ invulnerability              <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, T…
## $ energy_constructs            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ force_fields                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ self_sustenance              <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, …
## $ anti_gravity                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ empathy                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_nullifier              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ radiation_control            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ psionic_powers               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ elasticity                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ substance_secretion          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ elemental_transmogrification <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ technopath_cyberpath         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ photographic_reflexes        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ seismic_power                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animation                    <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, …
## $ precognition                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ mind_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ fire_resistance              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_absorption             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_hearing             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ nova_force                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ insanity                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ hypnokinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ animal_control               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ natural_armor                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ intangibility                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_sight               <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ molecular_manipulation       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ heat_generation              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ adaptation                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ gliding                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_suit                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ mind_blast                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ probability_manipulation     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ gravity_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ regeneration                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ light_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ echolocation                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ levitation                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ toxin_and_disease_control    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ banish                       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_manipulation          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ heat_resistance              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ natural_weapons              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ time_travel                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_smell               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ illusions                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ thirstokinesis               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ hair_manipulation            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ illumination                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnipotent                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ cloaking                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ changing_armor               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ power_cosmic                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, …
## $ biokinesis                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ water_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ radiation_immunity           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_telescopic            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ toxin_and_disease_resistance <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ spatial_awareness            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ energy_resistance            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ telepathy_resistance         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ molecular_combustion         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnilingualism               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ portal_creation              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ magnetism                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ mind_control_resistance      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ plant_control                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ sonar                        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ sonic_scream                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ time_manipulation            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ enhanced_touch               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ magic_resistance             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ invisibility                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ sub_mariner                  <lgl> FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, …
## $ radiation_absorption         <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ intuitive_aptitude           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_microscopic           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ melting                      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ wind_control                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ super_breath                 <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, …
## $ wallcrawling                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_night                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_infrared              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ grim_reaping                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ matter_absorption            <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ the_force                    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ resurrection                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ terrakinesis                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_heat                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vitakinesis                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ radar_sense                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ qwardian_power_ring          <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ weather_control              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_x_ray                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_thermal               <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ web_creation                 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ reality_warping              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ odin_force                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ symbiote_costume             <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ speed_force                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ phoenix_force                <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ molecular_dissipation        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ vision_cryo                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omnipresent                  <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ omniscient                   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
```

14. How many superheros have a combination of accelerated healing, durability, and super strength?

```r
superhero_powers %>% 
  filter(accelerated_healing == 1 & durability == 1 & super_strength == 1) %>% 
  nrow()
```

```
## [1] 97
```

## Your Favorite
15. Pick your favorite superhero and let's see their powers!

```r
set.seed(233)
my_hero <- sample(superhero_info$name, 1)
my_hero
```

```
## [1] "Captain Marvel II"
```


```r
my_hero_power <- superhero_powers %>% filter(hero_names == my_hero)
power <- unname(unlist(as.vector(my_hero_power[1, 2:ncol(my_hero_power)])))
power <- c(FALSE, power)
names(my_hero_power)[power]
```

```
## [1] "intelligence"    "super_strength"  "clairvoyance"    "invulnerability"
## [5] "hypnokinesis"    "omnilingualism"
```

## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.   
