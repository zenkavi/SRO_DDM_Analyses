## Notes on: Ratcliff, R., & Childers, R. (2015). Individual differences and fitting methods for the two-choice diffusion model of decision making. Decision, 2(4), 237.

**TODOs:**  

**Exceprts:**  

"Two issues were examined, first, what sizes of differences between groups can be obtained to distinguish between
groups and second, what sizes of differences would be needed to find individual subjects that had a deficit relative to a control group."

Individual difference (ID) analyses:
- Correlating ID variables with other (e.g. real-world variables) - external validity. This would be capped by a theoretical upper limit for the correlations
- Comparing ID variables to a control group to designate as 'abnormal' - predictive validity (?)

One argument for using the same model that putatively captures the same processes across all tasks (or using a small number of tasks instead of large batteries for ID analyses) is that if the components of cognitive processes differ across tasks then deficits might be averaged out when using different tasks/metrics. (p 3, pp1)

"It is important to distinguish between different sources of variability relevant to applications of the diffusion model. Variability across subjects in the parameters of the model from the fits to each subject's data (SD's) can be used to determine if a parameter value for an individual is significantly different from the values for the group. Standard errors across subjects can be used to determine whether a parameter for one group differs significantly from the parameter for another group. These standard errors represent the variability in the group means and they can be made smaller by increasing the number of subjects in the group."

"In typical applications of the diffusion model, this source of variability [sampling variability ie. that due to difference in number of observations per subject] is typically 3 to 5 times smaller than the variability due to differences among individuals for 45 min. of data collection. "

'Hierarchical methods have been demonstrated to be superior to standard methods when there are low numbers of observations per subject' - for us a test of this could be comparing the difference between EZ and HDDM or HDDM hier vs flat wrt number of tasks in each task.

'One of the most important functions of the diffusion model is that it maps RT and accuracy onto common underlying components of processing, drift rates, boundary settings, and nondecision time, which allows direct comparisons between tasks and conditions that might show the effects of independent variables in different ways.'

'We used the package to fit the data from each subject individually in the same way as for the other methods.' - ie flat estimates
'For the first two simulation studies, we examined separate fits to individual subjects. We also compared parameters recovered from the hierarchical method with those recovered from the chi-square method. '

'The model does make predictions about RT distributions, the same predictions as the standard model and so it is easily possible to evaluate how well EZ fits RT distributions' - EZ fitstats are possible!

Re EZ parameters: van Ravenzwaaij and Oberauer (2009) 'found that EZ and DMAT were better at recovering parameter values
and that EZ was the preferred method when the goal was to recover individual differences in parameter values.'

Learning effects: 'For both experiments, we examined practice effects by grouping the trials into earlier versus
later blocks.'

*Results:*

'In general, for this subject population (undergraduates) and this task, there is little difference in the parameter values
estimated from the first few trials and those estimated from the whole session.'

see p 16 for the conclusion that non-decision times and thresholds can be used to determine if one subject differs from the rest of the group while drift rates are NOT good for this. On the other hand to compare two groups to each other all parameters are good.

Fatigue and practice effects: **'These results show that there are no dramatic differences between model parameters estimated from the last few blocks of trials and the first few blocks of trials.'**

**On using variability statistics as ID variables: Not a good idea for parameter estimates 'Generally, differences in the across-trial variability parameters between individuals or between populations cannot be determined without quite large numbers of observations.'**

Goodness of fit statistic: chi-sq 'Chi-square goodness of fit values are often used to assess how well diffusion models (and other two-choice models) fit data.'

Parameters differ in their usefulness for classification: 'This means that these parameters [boundary separation and non-decision times] are in the range that might be useful for classifying individuals. [...] However, for drift rates, the classification would be much more difficult. Few of the conditions had drift rates that would separate the population with deficits from the
undergraduate population [...] However, it may be possible to use multivariate methods to improve classification with combinations of several parameters (e.g., drift rates, boundary separation, and nondecision time) and, if subjects were tested on
multiple tasks, combinations of measures across tasks might also improve classification.'

Parameter estimates do not change too much with fewer trials BUT DOES THAT NECESSARILY MEAN THAT ESTIMATES FROM FEWER TRIALS ARE GOOD FOR CORRELATING WITH OTHER MEASURES? 'If estimates of the model's parameters from small numbers of observations correlate
positively with estimates from large numbers, then small numbers can still be used to examine individual differences such as whether model parameters are correlated with measures such as IQ, reading measures, depression scores, etc.'

Trial number effects on consistency also depends on parameter type: 'The conclusion from these correlations is that consistency in parameter values is good from small to large numbers of observations for boundary separation and nondecision time but not
drift rates.'

"If the fitted values are strongly correlated with the generating values, **then the fitted values can be used to
investigate correlations between parameters of the model and subject variables such as age or IQ.**" I'm not sure I follow why they well-recovered parameters would necessarily imply good individual difference variables. Shouldn't this be true if there is indeed substantial between subjects variability in the simulation parameters?
