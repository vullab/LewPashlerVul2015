function [allParam, allLlk, allMle]=Exp4_fit(allRespTrain,allTargTrain, ...
    allRespTest,allTargTest,center,logans)
%% Fit cued recall trials of experiment 4
% 4.17.2015-Created

%% Files
foldName='E4_Fits';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Select blocks to analyze

%% Run Gibbs sampler
numBurn=200;
numSamps=1000;
numTotal=numSamps+numBurn;
allParam=nan(5,numSamps,5); % sessions x samples x parameters 
allLlk=nan(4,numSamps);
allMle=nan(24,25,size(allRespTrain,1),3);
init=[.005 1/3 1/3 1/3 1]; % Initial parameters. Set probability to 0 to eliminate mixture weight
probPrior=[1 1 1];
for is=1:5
    disp(is)
    fullName=fullfile(foldName,strcat(fName,num2str(is),'.mat'));
    if ~exist(fullName)
        if is==1
            allRespSess=squeeze(allRespTrain(:,is,:));
            allTargSess=squeeze(allTargTrain(:,is,:));
        elseif is==2
            subjRound=sum(~isnan(nanmean(allRespTrain,3)),2);
            for isub=1:length(subjRound)
                tempResp=squeeze(allRespTrain(isub,subjRound(isub),:));
                tempTarg=squeeze(allTargTrain(isub,subjRound(isub),:));
                allRespSess(isub,:)=tempResp;
                allTargSess(isub,:)=tempTarg;
            end
        else
            allRespSess=reshape(squeeze(allRespTest(:,is-2,:,:)),size(allRespTest,1),12);
            allTargSess=reshape(squeeze(allTargTest(:,is-2,:,:)),size(allTargTest,1),12);
        end
        [params, llk,Mle]=Exp4_gibbs(allRespSess,allTargSess, ...
            center,numBurn,numSamps,init,probPrior,logans);
        
        save(fullName,'params','llk','Mle');
    else
        load(fullName);
    end
    % Note, parameters are ordered SD, Targ, Miss
    allParam(is,:,:)=params((numBurn+1):numTotal,:); 
    allLlk(is,:)=llk((numBurn+1):numTotal);
    allMle(1:size(Mle,1),1:size(Mle,2),:,is)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
end




end
