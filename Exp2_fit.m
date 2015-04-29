function [allParam, allLlk,allMle]=Exp2_fit(data,center,envrad)
% Find the best parameter fits
% 4.8.2015-Created

%% Files
foldName='E2Fits';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Restructure data
[allResp, allTarg]=Exp2_restruc(data,center);

%% Run Gibbs sampler
numBurn=500;
numSamps=700;

numTotal=numSamps+numBurn;
allParam=nan(3,numSamps,4); % sessions x samples x parameters 
allLlk=nan(3,numSamps);
allMle=nan(10,11,size(allResp,1),3);
init=[60 1/3 1/3 1/3]; % Initial parameters. Set probability to 0 to eliminate mixture weight
probPrior=[1 1 1];
for is=1:3
    disp(is)
    fullName=fullfile(foldName,strcat(fName,num2str(is),'.mat'));
    if ~exist(fullName)
        allRespSess=squeeze(allResp(:,is,:,:));
        allTargSess=squeeze(allTarg(:,is,:,:));
        [params, llk,Mle]=Exp2_gibbs(allRespSess,allTargSess,center,numBurn,numSamps,init,probPrior,envrad);
        save(fullName,'params','llk','Mle');
    else
        load(fullName);
    end
    % Note, parameters are ordered SD, Targ, Miss
    allParam(is,:,:)=params((numBurn+1):numTotal,:); 
    allLlk(is,:)=llk((numBurn+1):numTotal);
    allMle(:,:,:,is)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
end

