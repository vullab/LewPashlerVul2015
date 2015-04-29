function [allParam, allLlk,allMle]=Exp1Rev_modelComparison(data,center,envrad)
% Find the best parameter fits
% 4.8.2015-Created

%% Files
foldName='E1RevFits_modComp';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Restructure data
numAnalyze=35;
[allResp, allTarg,allRep,allPrev]=Exp1_restruc(data,numAnalyze,center);
numBlock=sum(~isnan(mean(mean(allResp,4),3)),2);

%% Specify models
init=[60 1/3 1/3 1/6 1/6; ... % Full
    60 1/2 0 1/4 1/4; ... % No misassociations
    60 1/2 1/2 0 0; ... % No random guessing
    60 1 0 0 0; ... % Just targets
    ];
probPrior=[1 1 .5 .5; ... % Full
    1 0 .5 .5; ... % No misassociations
    1 1 0 0; ... % No random guessing
    1 0 0 0; ... % Just targets
    ];
modNames={'Full','NoMiss','NoRand','Targ'};
numMod=length(modNames);


%% Run Gibbs sampler
numBurn=200;
numSamps=1000;

numTotal=numSamps+numBurn;
numAnalyze2=2;
allParam=nan(numAnalyze2+1,numSamps,5,numMod); % sessions x samples x parameters
allLlk=nan(numAnalyze2+1,numSamps,numMod);
allMle=nan(10,13,size(allResp,1),3,numMod);

for im=1:numMod
    disp(modNames{im})
    for is=0:numAnalyze2
        disp(is)
        fullName=fullfile(foldName,strcat(fName,modNames{im},num2str(is),'.mat'));
        if ~exist(fullName)
            for isub=1:size(allResp,1)
                allRespSess(isub,:,:)=squeeze(allResp(isub,(numBlock(isub)-is),:,:));
                allTargSess(isub,:,:)=squeeze(allTarg(isub,(numBlock(isub)-is),:,:));
                allRepSess(isub,:,:)=squeeze(allRep(isub,(numBlock(isub)-is),:,:));
                allPrevSess(isub,:,:)=squeeze(allPrev(isub,(numBlock(isub)-is),:,:));
            end
            
            [params, llk,Mle]=Exp1_gibbs(allRespSess,allTargSess, ...
                allRepSess,allPrevSess, ...
                center,numBurn,numSamps,init(im,:),probPrior(im,:),envrad);
            save(fullName,'params','llk','Mle');
        else
            load(fullName);
        end
        % Note, parameters are ordered SD, Targ, Miss
        allParam(is+1,:,:,im)=params((numBurn+1):numTotal,:);
        allLlk(is+1,:,im)=llk((numBurn+1):numTotal);
        allMle(:,:,:,is+1,im)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
    end
end

