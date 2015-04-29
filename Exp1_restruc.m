function [allResp, allTarg,allRep,allPrev,sdRand]=Exp1_restruc(data,numAnalyze,center)
% Turn the data into responses and targets
% 4.8.2015-Created

allResp=nan(length(data),numAnalyze,10,2); % subj x session x objects x dim
allTarg=nan(length(data),numAnalyze,10,2);
allRep=nan(length(data),numAnalyze,10,2); % subj x session x objects x dim
allPrev=nan(length(data),numAnalyze,10,2);

numSubj=size(data,1);
numSess=[1:numAnalyze]; % identify testing sessions

for is=1:numSubj
    for iSe=1:length(numSess)
        if ~isempty(data{is,numSess(iSe)})
            allResp(is,iSe,:,1)=[data{is,numSess(iSe)}.xs];
            allResp(is,iSe,:,2)=[data{is,numSess(iSe)}.ys];
            allTarg(is,iSe,:,1)=[data{is,numSess(iSe)}.xt];
            allTarg(is,iSe,:,2)=[data{is,numSess(iSe)}.yt];
            
            % Repeat click
            if iSe==1
                allRep(is,iSe,1,1)=center(1);
                allRep(is,iSe,1,2)=center(2);
                allRep(is,iSe,2:end,1)=allResp(is,iSe,1:end-1,1);
                allRep(is,iSe,2:end,2)=allResp(is,iSe,1:end-1,2);
            else
                allRep(is,iSe,1,1)=allResp(is,iSe-1,end,1);
                allRep(is,iSe,1,2)=allResp(is,iSe-1,end,2);
                allRep(is,iSe,2:end,1)=allResp(is,iSe,1:end-1,1);
                allRep(is,iSe,2:end,2)=allResp(is,iSe,1:end-1,2);
            end
            
            % Previous object
            if iSe==1
                allPrev(is,iSe,1,1)=center(1);
                allPrev(is,iSe,1,2)=center(2);
                allPrev(is,iSe,2:end,1)=allTarg(is,iSe,1:end-1,1);
                allPrev(is,iSe,2:end,2)=allTarg(is,iSe,1:end-1,2);
            else
                allPrev(is,iSe,1,1)=allTarg(is,iSe-1,end,1);
                allPrev(is,iSe,1,2)=allTarg(is,iSe-1,end,2);
                allPrev(is,iSe,2:end,1)=allTarg(is,iSe,1:end-1,1);
                allPrev(is,iSe,2:end,2)=allTarg(is,iSe,1:end-1,2);
            end
        end
    end
end

sdRand=nan(1,length(numSess));
for iSe=1:length(numSess)
    xdif=allResp(:,iSe,:,1)-center(1);
    xdif=xdif(:);
    ydif=allResp(:,iSe,:,2)-center(2);
    ydif=ydif(:);
    sdRand(iSe)=nanstd([xdif;ydif]);
end








