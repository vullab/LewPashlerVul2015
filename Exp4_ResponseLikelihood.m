function [llk_responses, data]=Exp4_ResponseLikelihood(allResp, allTarg, center,currParams,logans)
% Calculate llk of responses given targets and current parameters
% 4.18.2015-Created

% Settings
numObj=size(allResp,2);
numSubj=size(allResp,1);
numFacts=length(logans);
centerX=repmat(center(1),numFacts,1);

% Allocate llk array
llk_responses=nan(numFacts,numFacts+1,numSubj); % objects x targs x subj

% Construct prior
prior=repmat(currParams(3)/(numFacts-1),numFacts,numFacts);
prior(logical(eye(numFacts)))=currParams(2);
prior=[prior repmat(((currParams(4))),numFacts,1)];

errType=[0 0 0]; % Count types of errors
dist=[];
randDist=[];

for is=1:numSubj
    
    % Calculate llk
    xr=allResp(is,:,1);
    xt=allTarg(is,:,1);
    [indFact b]=find((repmat(xt',1,numFacts)==repmat(logans,numObj,1))');
    xr2=nan(1,numFacts);
    xr2(indFact)=xr;
        
    % X llk
    x_tarmis=normpdf(repmat(xr2',1,numFacts),repmat(logans,numFacts,1),currParams(1));
    x_rand=normpdf(xr2',centerX,currParams(5));
    x_llk=[x_tarmis x_rand];
    
    
    % Multiply prior and llk
    llk_curr=prior.*x_llk;
    
    % And sample
    [targ, miss, r_err, curr_dist,curr_randDist]=Exp4_samps(llk_curr,xr2,logans);
    
    % And store samples
    errType(1)=errType(1)+sum(targ);
    errType(2)=errType(2)+sum(miss);
    errType(3)=errType(3)+sum(r_err);
    dist=[dist;curr_dist];
    randDist=[randDist;curr_randDist];
    
    llk_responses(:,:,is)=llk_curr;
end

data={errType, dist,randDist};



