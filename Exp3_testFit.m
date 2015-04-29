function [allParam, allLlk, allMle]=Exp3_testFit(allResp,allTarg,center,envrad)
%% Fit free recall test trials of experiment 3
% 4.17.2015-Created

%% Files
foldName='E3_testFits';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Run Gibbs sampler
numAnalyze=size(allResp,2);
numBurn=200;
numSamps=1000;
numTotal=numSamps+numBurn;
allParam=nan(numAnalyze,numSamps,4); % sessions x samples x parameters 
allLlk=nan(numAnalyze,numSamps);
allMle=nan(10,11,size(allResp,1),3);
init=[60 1/3 1/3 1/3]; % Initial parameters. Set probability to 0 to eliminate mixture weight
probPrior=[1 1 1];
for is=1:numAnalyze
    disp(is)
    fullName=fullfile(foldName,strcat(fName,num2str(is),'.mat'));
    if ~exist(fullName)
        allRespSess=squeeze(allResp(:,is,:,:));
        allTargSess=squeeze(allTarg(:,is,:,:));
        
        [params, llk,Mle]=Exp1_gibbs(allRespSess,allTargSess, ...
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