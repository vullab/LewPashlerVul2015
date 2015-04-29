function [allResp, allTarg,sdRand]=Exp2_restruc(data,center)
% Turn the data into responses and targets
% 4.8.2015-Created

allResp=nan(length(data),3,10,2); % subj x session x objects x dim
allTarg=nan(length(data),3,10,2);

numSubj=length(data);
numSess=[3 4 5]; % identify testing sessions

for is=1:numSubj
    for iSe=1:length(numSess)
        allResp(is,iSe,:,1)=[data{is}{numSess(iSe)}.xs];
        allResp(is,iSe,:,2)=[data{is}{numSess(iSe)}.ys];
        allTarg(is,iSe,:,1)=[data{is}{numSess(iSe)}.xt];
        allTarg(is,iSe,:,2)=[data{is}{numSess(iSe)}.yt];
    end
end

sdRand=nan(1,length(numSess));
for iSe=1:length(numSess)
    xdif=allResp(:,iSe,:,1)-center(1);
    xdif=xdif(:);
    ydif=allResp(:,iSe,:,2)-center(2);
    ydif=ydif(:);
    sdRand(iSe)=std([xdif;ydif]);
end


