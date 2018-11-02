# Useful functions:

**hddm.utils.post_pred_stats**: calls below with default statistics  

**kabuki.analyze.post_pred_stats**: applies statistics defined in an OrderedDict to data generated from the posterior predictive. Treats stim data and real data completely separately and therefore seems hard to use it for the calculation of a fit statistic. Still, might be worth hacking it.

**kabuki.analyze.post_pred_gen**: given a model generates data for all subjects in that model using their parameters. By default samples 500 values from the posterior predictive distributions of the parameters and generates stimulated data for all trials that many times. The *groupby* argument generates stimulated data subsetted by the condition specified with this argument. I don't think this is necessary if the model is already specified with different parameters for condition. It is described [here](http://ski.clps.brown.edu/hddm_docs/tutorial_post_pred.html) to be used for generating stimulated data for subsets of data using the same parameters.

# Structure of stimulated data

**kabuki.analyze.post_pred_gen**

```

```

**post_pred_gen_debug**

```

```

# Goal

- Generate predicted data using *post_pred_gen*  
- Compare distribution of stimulated RT's to actual RT's  
- Calculate: R^2 for regressing one over the other and KL divergence between these two distributions *for each subject*  
- Plot predicted vs actual data for each subject in each task (possibly one figure per task with lines for each subject)

# Plan:

- Generate post_pred_gen data using kabuki vs. own debug to remember the additions you made  - kabuki.analyze.post_pred_gen doesn't seem to append data correctly for concatenated parallel models.
- Use kabuki.analyze.post_pred_gen data to understand what the grouping in kabuki.analyze.post_pred_stats refers to  


Read Ratcliff & Childers for comparison of DDMs and examples of individual difference analyses  
Read Wagenmakers et al for EZ predictions  
