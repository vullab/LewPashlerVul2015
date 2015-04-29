function llk_trial=Exp4_TrialLikelihood(llk_responses)
%% Collapse llk by trial
llk_trial=squeeze(sum(log(llk_responses+eps),2));



