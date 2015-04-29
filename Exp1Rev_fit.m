function [allParam, allLlk,allMle]=Exp1Rev_fit(data,center,envrad)
% Find the best parameter fits
% 4.8.2015-Created

%% Files
foldName='E1RevFits';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Restructure data
numAnalyze=35;
[allResp, allTarg,allRep,allPrev]=Exp1_restruc(data,numAnalyze,center);
numBlock=sum(~isnan(mean(mean(allResp,4),3)),2);

%% Run Gibbs sampler
numBurn=500;
numSamps=700;

numTotal=numSamps+numBurn;
numAnalyze2=2;
allParam=nan(numAnalyze2+1,numSamps,5); % sessions x samples x parameters 
allLlk=nan(numAnalyze2+1,numSamps);
allMle=nan(10,13,size(allResp,1),3);
init=[60 1/3 1/3 1/6 1/6]; % Initial parameters. Set probability to 0 to eliminate mixture weight
probprior=[1 1 .5 .5];
for is=0:numAnalyze2
    disp(is)
    fullName=fullfile(foldName,strcat(fName,num2str(is),'.mat'));
    if ~exist(fullName)
        for isub=1:size(allResp,1)
            allRespSess(isub,:,:)=squeeze(allResp(isub,(numBlock(isub)-is),:,:));
            allTargSess(isub,:,:)=squeeze(allTarg(isub,(numBlock(isub)-is),:,:));
            allRepSess(isub,:,:)=squeeze(allRep(isub,(numBlock(isub)-is),:,:));
            allPrevSess(isub,:,:)=squeeze(allPrev(isub,(numBlock(isub)-is),:,:));
        end
        
        [params, llk,Mle]=Exp1_gibbs(allRespSess,allTargSess, ...
            allRepSess,allPrevSess, ...
        center,numBurn,numSamps,init,probprior,envrad);
        save(fullName,'params','llk','Mle');
    else
        load(fullName);
    end
    % Note, parameters are ordered SD, Targ, Miss
    allParam(is+1,:,:)=params((numBurn+1):numTotal,:); 
    allLlk(is+1,:)=llk((numBurn+1):numTotal);
    allMle(:,:,:,is+1)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
end


