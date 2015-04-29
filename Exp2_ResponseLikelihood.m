function [llk_responses, data]=Exp2_ResponseLikelihood(allResp, allTarg, center,randsd,currParams,envrad)
% Calculate llk of responses given targets and current parameters
% 4.8.2015-Created

% Settings
numObj=size(allResp,2);
numSubj=size(allResp,1);
centerX=repmat(center(1),numObj,1);
centerY=repmat(center(2),numObj,1);

% Allocate llk array
llk_responses=nan(numObj,numObj+1,numSubj); % objects x targs x subj

% Construct prior
prior=repmat(currParams(3)/(numObj-1),numObj,numObj);
prior(logical(eye(numObj)))=currParams(2);
prior=[prior repmat(((currParams(4))),numObj,1)];

errType=[0 0 0]; % Count types of errors
dist=[];

for is=1:numSubj
    
    % Calculate llk
    xr=allResp(is,:,1);
    yr=allResp(is,:,2);
    xt=allTarg(is,:,1);
    yt=allTarg(is,:,2);
    
    % X llk
    x_tarmis=normpdf(repmat(xr',1,numObj),repmat(xt,numObj,1),currParams(1));
    
    % Y llk
    y_tarmis=normpdf(repmat(yr',1,numObj),repmat(yt,numObj,1),currParams(1));
    
    % Rand llk-truncated normal 
    rand_llk=mvnpdf([xr' yr'], [centerX(1) centerY(1)], (eye(2)*randsd^2)/(1-exp(-envrad^2/(2*randsd^2))));
    
    % x & y joint
    joint_llk=x_tarmis.*y_tarmis;
    joint_llk=[joint_llk rand_llk];
    
    % Multiply prior and llk
    llk_curr=prior.*joint_llk;
    
    % And sample
    [targ, miss, r_err, curr_dist]=Exp1_samps(llk_curr,xr,yr,xt,yt);
    
    % And store samples
    errType(1)=errType(1)+sum(targ);
    errType(2)=errType(2)+sum(miss);
    errType(3)=errType(3)+sum(r_err);
    dist=[dist;curr_dist];
    
    
    llk_responses(:,:,is)=llk_curr;
end

data={errType, dist};





