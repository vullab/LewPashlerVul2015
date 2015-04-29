function [allParam, allLlk, allMle]=Exp3_trainCuedFit(allResp,allTarg,center,envrad)
%% Fit cued recall trials of experiment 3
% 4.17.2015-Created

%% Files
foldName='E3_cuedFits';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Generate previous and repeat matrices
allRep=nan(size(allResp));
allPrev=nan(size(allResp));
for is=1:size(allRep,1)
    for ib=1:size(allRep,2)
        allRep(is,ib,1,:)=center;
        allPrev(is,ib,1,:)=center;
        
        allRep(is,ib,2:end,1)=allResp(is,ib,1:9,1);
        allRep(is,ib,2:end,2)=allResp(is,ib,1:9,2);
        allPrev(is,ib,2:end,1)=allTarg(is,ib,1:9,1);
        allPrev(is,ib,2:end,2)=allTarg(is,ib,1:9,2);
    end
end


%% Run Gibbs sampler
numAnalyze=20;
numBurn=200;
numSamps=1000;
numTotal=numSamps+numBurn;
allParam=nan(numAnalyze,numSamps,5); % sessions x samples x parameters 
allLlk=nan(numAnalyze,numSamps);
allMle=nan(10,13,size(allResp,1),3);
init=[60 1/3 1/3 1/6 1/6]; % Initial parameters. Set probability to 0 to eliminate mixture weight
probPrior=[1 1 .5 .5];
for is=1:numAnalyze
    disp(is)
    fullName=fullfile(foldName,strcat(fName,num2str(is),'.mat'));
    if ~exist(fullName)
        allRespSess=squeeze(allResp(:,is,:,:));
        allTargSess=squeeze(allTarg(:,is,:,:));
        allRepSess=squeeze(allRep(:,is,:,:));
        allPrevSess=squeeze(allPrev(:,is,:,:));
        
        [params, llk,Mle]=Exp2_gibbs(allRespSess,allTargSess,allRepSess,allPrevSess, ...
            center,numBurn,numSamps,init,probPrior,envrad);
        
        save(fullName,'params','llk','Mle');
    else
        load(fullName);
    end
    % Note, parameters are ordered SD, Targ, Miss
    allParam(is,:,:)=params((numBurn+1):numTotal,:); 
    allLlk(is,:)=llk((numBurn+1):numTotal);
    allMle(:,:,:,is)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
end




end