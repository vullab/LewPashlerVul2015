function [params,llk,Mle]=Exp2_gibbs(allResp,allTarg,allRep,allPrev,center,numBurn,numSamps,init,probPrior,envrad)
% Run Gibbs sampler on data
% 4.8.2014-Created
numTotal=numBurn+numSamps;
Mle=nan(10,13,size(allResp,1),numTotal);

%% Initialize priors and data structures
params=nan(numTotal,5); % sd, targ, miss
params(1,:)=init;
currParams=params(1,:);

% Find sd of random guesses
allX=allResp(:,:,1);allX=allX(:)-center(1);
allY=allResp(:,:,2);allY=allY(:)-center(2);
randsd=nanstd([allX;allY]);

% Calculate llk of current parameters
llk=nan(numTotal,1);
[llk_responses, samps]=Exp1_ResponseLikelihood(allResp, allTarg,allRep,allPrev, center,randsd,params(1,:),envrad);
llk_trial=Exp1_TrialLikelihood(llk_responses);
llk(1)=Exp1_TotalLikelihood(llk_trial);
Mle(:,:,:,1)=llk_responses;

%% Iterate
for ii=2:numTotal
    % Sample new parameters
    [new_params, new_llk, new_samps,new_mle]=Exp1_TransitionFX(allResp, allTarg, ...
        allRep,allPrev, center,randsd,samps, params(ii-1,:),llk(ii-1),probPrior,Mle(:,:,:,ii-1),envrad);
    params(ii,:)=new_params;
    llk(ii)=new_llk;
    Mle(:,:,:,ii)=new_mle;
    samps=new_samps;
end

