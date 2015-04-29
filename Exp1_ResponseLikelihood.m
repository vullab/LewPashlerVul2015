function [llk_responses, data]=Exp1_ResponseLikelihood(allResp, allTarg,allRep,allPrev,center,randsd,currParams,envrad)
% Calculate llk of responses given targets and current parameters
% 4.8.2015-Created

% Settings
numObj=size(allResp,2);
numSubj=size(allResp,1);
centerX=repmat(center(1),numObj,1);
centerY=repmat(center(2),numObj,1);
strucRandSd1=5; % Noise of clicking the same spot
strucRandSd2=5; % Noise of clicking the previous location

% Allocate llk array
llk_responses=nan(numObj,numObj+3,numSubj); % objects x targs x subj

% Construct prior
prior=repmat(currParams(3)/(numObj-1),numObj,numObj); % Misassociations
prior(logical(eye(numObj)))=currParams(2); % Target
rProb1=repmat(((currParams(4))),numObj,1);
rProb2=repmat(((currParams(5)))/2,numObj,1);
prior=[prior rProb1 rProb2 rProb2]; % Random guessing

errType=[0 0 0 0]; % Count types of errors
dist=[];

for is=1:numSubj
    if ~(isnan(allResp(is,:,1))>0)
        %% Calculate llk
        
        % Get positions
        xr=allResp(is,:,1);
        yr=allResp(is,:,2);
        xt=allTarg(is,:,1);
        yt=allTarg(is,:,2);
        
        % Add repeat
        xRep=allRep(is,:,1);
        yRep=allRep(is,:,2);
        
        % Add previous
        xPrev=allPrev(is,:,1);
        yPrev=allPrev(is,:,2);
        
        % X llk
        x_tarmis=normpdf(repmat(xr',1,numObj),repmat(xt,numObj,1),currParams(1));
        x_randRep=normpdf(xr',xRep',strucRandSd1);
        x_randPrev=normpdf(xr',xPrev',strucRandSd2);
        x_llk=[x_tarmis x_randRep x_randPrev];
        
        % Y llk
        y_tarmis=normpdf(repmat(yr',1,numObj),repmat(yt,numObj,1),currParams(1));
        y_randRep=normpdf(yr',yRep',strucRandSd1);
        y_randPrev=normpdf(yr',yPrev',strucRandSd2);
        y_llk=[y_tarmis y_randRep y_randPrev];
        
        % Rand-Truncated sd
        rand_llk=mvnpdf([xr' yr'], [centerX(1) centerY(1)], (eye(2)*randsd^2)/(1-exp(-envrad^2/(2*randsd^2))));

        % x & y joint
        joint_llk=x_llk.*y_llk;
        joint_llk=[joint_llk(:,1:numObj) rand_llk joint_llk(:,(end-1):end)];
        
        % Multiply prior and llk
        llk_curr=prior.*joint_llk;
        
        %% And sample
        [targ, miss, r_err,r_err2, curr_dist]=Exp2_samps(llk_curr,xr,yr,xt,yt);
        
        %% And store samples
        errType(1)=errType(1)+sum(targ);
        errType(2)=errType(2)+sum(miss);
        errType(3)=errType(3)+sum(r_err);
        errType(4)=errType(4)+sum(r_err2);
        dist=[dist;curr_dist];
        
        
        llk_responses(:,:,is)=llk_curr;
    end
end

data={errType, dist};

