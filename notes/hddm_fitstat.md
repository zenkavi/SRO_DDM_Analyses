# Useful functions:

**hddm.utils.post_pred_stats**: calls below with default statistics  

**kabuki.analyze.post_pred_stats**: applies statistics defined in an OrderedDict to data generated from the posterior predictive. Treats stim data and real data completely separately and therefore seems hard to use it for the calculation of a fit statistic. Still, might be worth hacking it.

**kabuki.analyze.post_pred_gen**: given a model generates data for all subjects in that model using their parameters. By default samples 500 values from the posterior predictive distributions of the parameters and generates stimulated data for all trials that many times. The *groupby* argument generates stimulated data subsetted by the condition specified with this argument. I don't think this is necessary if the model is already specified with different parameters for condition. It is described [here](http://ski.clps.brown.edu/hddm_docs/tutorial_post_pred.html) to be used for generating stimulated data for subsets of data using the same parameters.

# Structure of stimulated data

**post_pred_gen_debug**

*Note: Order of output is NOT sequential (i.e. trial 1, trial 2 etc.)*
index level 0: node - subject
index level 1: sample - number of sampled parameter from its posterior predictive
rt_sampled: rt's calculated using the sampled parameters
rt: actual rt's

# TODO:
Read Ratcliff & Childers for comparison of DDMs and examples of individual difference analyses  
Read Wagenmakers et al for EZ predictions  
