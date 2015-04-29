function [partition]=errorPartition(resp, targ,Mle,center,sd)
%% Actual partition errors based on type
% 4.15.2015-Created

numSubj=size(resp,1);
numSess=size(Mle,4);
numObj=size(resp,3);

partition=nan(numSubj,numSess,3);
numSamp=nan(numSubj,numSess,3);
for is=1:numSubj
    for is2=1:numSess
        
        currMle=Mle(:,:,is,is2);
        [a sampVal]=max(currMle,[],2);
        
        errs=zeros(1,3); % Noise, Miss, Rand
        balSamp=[0 0 0];
        for oi=1:numObj
            tIt=squeeze(targ(is,is2,oi,:));
            if sampVal(oi)>10
                % If rand
                gIt=center';
                errs(3)=errs(3)+sqrt(sum((tIt-gIt).^2));
                balSamp(3)=balSamp(3)+1;
            elseif sampVal(oi)~=oi
                % If Miss
                gIt=squeeze(resp(is,is2,sampVal(oi),:));
                errs(1)=errs(1)+sd(is2); % Location noise
                errs(2)=errs(2)+sqrt(sum((gIt-tIt).^2)); % Misassociation
                balSamp(1:2)=balSamp(1:2)+1;
            else
                % If target
                gIt=squeeze(resp(is,is2,oi,:));
                errs(1)=errs(1)+sd(is2);
                balSamp(1)=balSamp(1)+1;
            end
            
        end
        partition(is,is2,:)=errs/10;
        numSamp(is,is2,:)=balSamp;
    end
end