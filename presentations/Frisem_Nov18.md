A large-scale comparison of raw cognitive task measures and derived model parameters for individual difference analyses
========================================================
author: A. Zeynep Enkavi
date: November 30, 2018
autosize: true
css: custom.css

Background
========================================================

- What do we mean by individual difference analyses  
- Example papers using HDDM parameters (see [here second paragraph](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4517692/)) for multiple examples

Dataset
========================================================

- Self-regulation ontology dataset as described in Eisenberg et al. (2017), Eisenberg et al. (2018), Enkavi et al. (2018)
- N=552 collected on MTurk using Experiment Factory (Sochat et al., 2016)
- N=150 follow-up with same battery
- Battery consisted of 35 behavioral tasks, 23 surveys and demographic questions

***

Add images for each bullet point in this column

Data cleaning and variable selection
========================================================

- Basic cleaning for each task
- 14 Tasks 
-- Number of trials in each task

"adaptive_n_back" ~ 400             
"attention_network_task" ~ 140     
"choice_reaction_time" ~ 150        
"directed_forgetting" ~ 70       
"dot_pattern_expectancy" ~ 156      
"local_global_letter" ~ 95
"motor_selective_stop_signal" ~ 180 
"recent_probes" ~ 71
"shape_matching" ~ 277          
"simon" ~ 100       
"stim_selective_stop_signal" ~ 240
"stop_signal" ~ 600
"stroop" ~ 95           
cued response switching "threebytwo" ~ 433

Types of variables
========================================================

- DDM: Drift rate, threshold, non-decision time  
- Raw: Response times (RT), accuracy  
- HDDM: DDM parameters estimates using priors accounting for the sample  
- EZ: A closed form solution  
- Contrast:  
- Non-contrast:  
- Condition: 

***
Add images for each bullet point in this column

Sample selection for HDDM
========================================================

- 
- Refit vs. t1

Raw measures vs DDM parameter reliability
========================================================



Sample size effects on reliability
========================================================

<span class="emphasized">Pay attention to this!</span>
More text

Consequences of hierarchical parameter estimation
========================================================

Flat vs. hierarchical

Clustering
========================================================

Do ddm parameters capture similar cognitive processes across tasks?

- Are the correlations between ddm parameters across tasks higher than correlations between ddm parameters and other variables from a given task?
- Can you recover a 3 factor structure that is separate than the raw measures using the ddm measures?
- Are these lower dimensional projections more reliable?

Prediction
========================================================

- Cross-validated $R^2$ predicting demographic factors using  
-- Each individual measure  
-- Lower dimensional projections  
