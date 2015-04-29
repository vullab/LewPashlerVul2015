function [subjparams,hierparams, llks]=hierExpSlope(data,isProb)
%% Find the exponential slope
% 4.15.2015-Created

numBurn=200;
numIter=400;
numSamps=size(data,2);
subjparams=nan(numSamps,3,numIter);
hierparams=nan(7,numIter);
llks=nan(numSamps,numIter);

if isProb
    % Hierarchical params
    gmeanA=.5;
    gmeanB=.5;
    gmeanC=1;
    gsdA=.1;
    gsdB=.1;
    gsdC=.5;
    noise=.1;
    
    % Ind params
    imeanA=rand(numSamps,1);
    imeanB=rand(numSamps,1);
    imeanC=4*rand(numSamps,1);
    
    % Transition
    scalejump=.05;
    slopejump=.05;
    
    scalegjump=.025;
    slopegjump=.025;
    scalesdjump=.01;
    slopesdjump=.01;
    
else
    % Hierarchical params
    gmeanA=50;
    gmeanB=50;
    gmeanC=1;
    gsdA=5;
    gsdB=5;
    gsdC=.5;
    noise=10;
    
    % Ind params
    imeanA=100*rand(numSamps,1);
    imeanB=100*rand(numSamps,1);
    imeanC=1*rand(numSamps,1);
    
    % Transition probabilities
    % subj
    scalejump=5;
    slopejump=.05;
    
    % global
    scalegjump=1;
    slopegjump=.01;
    scalesdjump=.5;
    slopesdjump=.01;
end
subjparams(:,1,1)=imeanA;
subjparams(:,2,1)=imeanB;
subjparams(:,3,1)=imeanC;
hierparams(:,1)=[gmeanA gmeanB gmeanC gsdA gsdB gsdC noise];

% Calculate current llks
all_llk=nan(numSamps,1);
for ns=1:numSamps
    x=[imeanA(ns) imeanB(ns) imeanC(ns) gmeanA gmeanB gmeanC gsdA gsdB gsdC noise];
    data2=data(:,ns)';
    curr_llk=expFitMinSearch2(x,data2); 
    all_llk(ns)=curr_llk;
end
llks(:,1)=all_llk;

for ni=2:(numBurn+numIter)
    
    %% Adjust subject parameters
    for ns=1:numSamps
        nextSubjParam=[normrnd(imeanA(ns),scalejump) normrnd(imeanB(ns),scalejump) normrnd(imeanC(ns),slopejump)];
        
        x=[nextSubjParam gmeanA gmeanB gmeanC gsdA gsdB gsdC noise];
        data2=data(:,ns)';
        next_llk=expFitMinSearch2(x,data2);
        
        if (next_llk/all_llk(ns))>1
            imeanA(ns)=nextSubjParam(1);
            imeanB(ns)=nextSubjParam(2);
            imeanC(ns)=nextSubjParam(3);     
            all_llk(ns)=next_llk;
        end
        
    end
    
    %% Adjust global parameters
    next_gmeanA=normrnd(gmeanA,scalegjump);
    next_gmeanB=normrnd(gmeanB,scalegjump);
    next_gmeanC=normrnd(gmeanC,slopegjump);
    next_gsdA=normrnd(gsdA,scalesdjump);
    next_gsdB=normrnd(gsdB,scalesdjump);
    next_gsdC=normrnd(gsdC,slopesdjump);
    next_noise=normrnd(noise,scalegjump);
    next_globalParam=[next_gmeanA next_gmeanB next_gmeanC ...
        next_gsdA next_gsdB next_gsdC next_noise];
    
    test_llk=nan(numSamps,1);
    
    for ns=1:numSamps
        x=[imeanA(ns) imeanB(ns) imeanC(ns) next_globalParam];
        data2=data(:,ns)';
        test_llk(ns)=expFitMinSearch2(x,data2);
    end
    
    if (sum((test_llk./all_llk)>1)/numSamps)>rand()
        gmeanA=next_gmeanA;
        gmeanB=next_gmeanB;
        gmeanC=next_gmeanC;
        gsdA=next_gsdA;
        gsdB=next_gsdB;
        gsdC=next_gsdC;
        noise=next_noise;
        all_llk=test_llk;
    end
    
    %% Update
    subjparams(:,1,ni)=imeanA;
    subjparams(:,2,ni)=imeanB;
    subjparams(:,3,ni)=imeanC;
    hierparams(:,ni)=[gmeanA gmeanB gmeanC gsdA gsdB gsdC noise];
    llks(:,ni)=all_llk;
end

subjparams=subjparams(:,:,numBurn:(numBurn+numIter)); 
hierparams=hierparams(:,numBurn:(numBurn+numIter));
llks=llks(:,numBurn:(numBurn+numIter));

end