## Notes on: Wagenmakers, E. J., Van Der Maas, H. L., & Grasman, R. P. (2007). An EZ-diffusion model for response time and accuracy. Psychonomic bulletin & review, 14(1), 3-22.

**TODO:**  

Run the 3 checks on all 14 tasks to see if EZ is appropriate for all.  
Does EZ fit worse for tasks with putatively multiple cognitive processes?  
Split half correlation on EZ for fitstats?

**Exceprts:**  

Modifications in EZ:

"The first simplification is that the EZ-diffusion model
does not allow across-trials variability in parameters. This
means that st , sz, and h are effectively removed from the
model."

"The second and final simplification is that the starting
point z is assumed to be equidistant from the response"

Prerun checks for EZ:

"Check the shape of the RT distributions. The EZ model
should be applied only to RT data that show at least some
amount of right skew. In addition, the skew should become
more pronounced as task difficulty increases."

"the EZ-diffusion model predicts that the RT distributions
of correct and error responses are identical. When
the starting point is equidistant from the response boundaries,
fast error responses come about through across-trials
variability in starting point, and slow error responses come
about through across-trials variability in drift rate. Fast or
slow errors therefore indicate the presence of across-trials
variability in starting point or drift rate, respectively"

"In order to check whether or not the data show evidence of a bias in starting
point, one can compare the relative speed of correct
and error responses for the different stimulus categories. "

RE fit statistics:
"In sum, the EZ-diffusion model cannot be falsified on the
basis of a poor fit to the data: It will always produce a
perfect fit to the data, since it simply transforms the observed
variables to unobserved variables without any loss
of information"

"For instance, both the EZ- and Ratcliff diffusion models are currently limited to tasks that
require only a single process for their completion. That is,
the present model should not be applied to tasks such as the
Eriksen flanker task (Eriksen & Eriksen, 1974), in which
one process may correspond to information accumulation
from the target arrow, and another process may correspond
to information accumulation from the distractor arrows.
We strongly recommend that the three EZ checks for misspecification
mentioned earlier (i.e., check the shape of
the RT distributions, check the relative speed of error responses,
and check whether the starting point is unbiased)
be carried out when the model is applied to data"

"For the EZ-diffusion model, an attractive model selection
procedure would be to use split-half cross-validation
(see, e.g., Browne, 2000): That is, the parameters of the
model could be determined by fitting one half of the data
set. These particular parameter estimates could then be
used to assess the prediction error for the second half of
the data set. The model with the lowest prediction error
would be preferred."
