function llk_trial=Exp1_TrialLikelihood(llk_responses)
%% Collapse llk by trial
llk_trial=squeeze(nansum(log(llk_responses+eps),2));



