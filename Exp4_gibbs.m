function [params,llk,Mle]=Exp4_gibbs(allResp,allTarg,center,numBurn,numSamps,init,probPrior,logans)
% Run Gibbs sampler on E4 data
% 4.18.2014-Created
numTotal=numBurn+numSamps;
Mle=nan(length(logans),length(logans)+1,size(allResp,1),numTotal);

%% Initialize priors and data structures
params=nan(numTotal,5); % sd, targ, miss rand, sdrand
params(1,:)=init;
currParams=params(1,:);

% Calculate llk of current parameters
llk=nan(numTotal,1);
[llk_responses, samps]=Exp4_ResponseLikelihood(allResp, allTarg, center,params(1,:),logans);
llk_trial=Exp4_TrialLikelihood(llk_responses);
llk(1)=Exp4_TotalLikelihood(llk_trial);
Mle(:,:,:,1)=llk_responses;

%% Iterate
for ii=2:numTotal
    if ii==numBurn
        disp('')
    end
    % Sample new parameters
    [new_params, new_llk, new_samps,new_mle]=Exp4_TransitionFX(allResp, allTarg, center,samps, params(ii-1,:),llk(ii-1),probPrior,Mle(:,:,:,ii-1),logans);
    params(ii,:)=new_params;
    llk(ii)=new_llk;
    Mle(:,:,:,ii)=new_mle;
    samps=new_samps;
end

