function [allParam, allLlk,allMle]=Exp2_modelComparison(data,center,envrad)
% Find the best parameter fits
% 4.8.2015-Created
% 4.14.2015-Model comparison

%% Files
foldName='E2Fits_modComp';
fName='Session';
if ~exist(foldName)
    mkdir(foldName)
end

%% Restructure data
[allResp, allTarg]=Exp2_restruc(data,center);

%% Specify models
init=[60 1/3 1/3 1/3; ... % Full
    60 1/2 0 1/2; ... % No misassociations
    60 1/2 1/2 0; ... % No random guessing
    60 1 0 0; ... % Just targets
    ];
probPrior=[1 1 1; ... % Full
    1 0 1; ... % No misassociations
    1 1 0; ... % No random guessing
    1 0 0; ... % Just targets
    ];
modNames={'Full','NoMiss','NoRand','Targ'};
numMod=length(modNames);

%% Run Gibbs sampler
numBurn=200;
numSamps=1000;
numTotal=numSamps+numBurn;
allParam=nan(3,numSamps,4,numMod); % sessions x samples x parameters x model
allLlk=nan(3,numSamps,numMod);
allMle=nan(10,11,size(allResp,1),3,numMod);
for im=1:numMod
    disp(modNames{im})
    for is=1:3
        disp(is)
        fullName=fullfile(foldName,strcat(fName,modNames{im},num2str(is),'.mat'));
        if ~exist(fullName)
            allRespSess=squeeze(allResp(:,is,:,:));
            allTargSess=squeeze(allTarg(:,is,:,:));
            [params, llk,Mle]=Exp2_gibbs(allRespSess,allTargSess,center,numBurn,numSamps,init(im,:),probPrior(im,:),envrad);
            save(fullName,'params','llk','Mle');
        else
            load(fullName);
        end
        % Note, parameters are ordered SD, Targ, Miss
        allParam(is,:,:,im)=params((numBurn+1):numTotal,:);
        allLlk(is,:,im)=llk((numBurn+1):numTotal);
        allMle(:,:,:,is,im)=squeeze(mean(Mle(:,:,:,(numBurn+1):numTotal),4));
    end
end