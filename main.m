%% main
% Analysis code for Lew, Pashler & Vul, 2015
% 4.8.2015-Created

%% Settings
clear all
close all
clc

set(0, 'DefaultAxesFontSize',40)
set(0, 'DefaultLineLineWidth',4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Experiments 1 & 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading Experiment 1')
centerE1=[500 400];
envRadE1=370;
[exp1error,allStru1]=loadE1();
[E1_Resp, E1_Targ,E1_Rep,E1_Prev,E1_sdRand]=Exp1_restruc(allStru1,size(exp1error,2),centerE1);

disp('Loading Experiment 2')
centerE2=[500 475];
envRadE2=450;
allStru2=loadE2();
[E2_Resp, E2_Targ,E2_sdRand]=Exp2_restruc(allStru2,centerE2);

clc

%% Model fit

% Fit experiment 1-Learning
disp('Fitting E1')
[E1_params, E1_llk,E1_Mle]=Exp1_fit(allStru1,centerE1,envRadE1);
E1_params(:,:,4)=E1_params(:,:,4)+E1_params(:,:,5); % Combine random guessing parameters
E1_params(:,:,5)=[];

% Fit experiment 1-Backwards blocks
disp('Fitting E1 Rev')
[E1Rev_params, E1Rev_llk,E1Rev_Mle]=Exp1Rev_fit(allStru1,centerE1,envRadE1);
E1Rev_params(:,:,4)=E1Rev_params(:,:,4)+E1Rev_params(:,:,5);
E1Rev_params(:,:,5)=[];

% Fit experiment 2-Forgetting
disp('Fitting E2')
[E2_params, E2_llk, E2_Mle]=Exp2_fit(allStru2,centerE2,envRadE2);

clc

%% RMSE
% Plot RMSE for Experiments 1 & 2
[E2_dist, E1_dist, E1Rev_dist]=E1_E2_plotRMSE(E2_Resp, E2_Targ,E1_Resp, E1_Targ);

%% Parameter fits
% Plot types of errors for Experiments 1 & 2
[E1_expLearn]=E1_E2_plotParamFits(E2_params,E1_params,E1Rev_params);

%% Error partition
% Partition RMSE based on type of errors for Experiments 1 & 2
E1_E2_plotErrorPartition(E2_Resp, E2_Targ,E1_Resp, E1_Targ, ...
    E2_dist, E1_dist, E1Rev_dist, ...
    E2_Mle,E1_Mle,E1Rev_Mle, ...
    centerE2,centerE1, ...
    E2_params,E1_params,E1Rev_params);

%% Model comparison
% Compare full model, no misassociations, no random guessing and just
% target guesses
[E1_modCompParam, E1_modCompLlk,E1_modCompMle]=Exp1_modelComparison(allStru1,centerE1,envRadE1);

[E1Rev_modCompParam, E1Rev_modCompLlk,E1Rev_modCompMle]=Exp1Rev_modelComparison(allStru1,centerE1,envRadE1);

[E2_modCompParam, E2_modCompLlk,E2_modCompMle]=Exp2_modelComparison(allStru2,centerE2,envRadE1);

[E2_aic,E1_aic,E1Rev_aic]=E1_E2_plotModComp(E2_modCompLlk,E1_modCompLlk,E1Rev_modCompLlk);

[E2_meanllk,E1_meanllk,E1Rev_meanllk]=E1_E2_plotModCompMeanLlk(E2_modCompMle,E1_modCompMle,E1Rev_modCompMle);

%% Reaction time
E1_E2_plotRT(allStru2,allStru1,E2_Mle,E1_Mle)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Experiment 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Loading Experiment 3')
centerE3=[400 280];
envRadE3=275;
[E3_RespTrainCued, E3_TargTrainCued,E3_sdRandTrainCued, ...
    E3_RespTrainFree, E3_TargTrainFree,E3_sdRandTrainFree, ...
    E3_RespTest, E3_TargTest,E3_sdRandTest]=loadE3(centerE3);

%% Model fit

[E3trainFree_params, E3trainFree_llk, E3trainFree_Mle]= ...
    Exp3_trainFreeFit(E3_RespTrainFree,E3_TargTrainFree,centerE3,envRadE3);

[E3trainCued_params, E3trainCued_llk, E3trainCued_Mle]= ...
    Exp3_trainCuedFit(E3_RespTrainCued,E3_TargTrainCued,centerE3,envRadE3);
E3trainCued_params(:,:,4)=E3trainCued_params(:,:,4)+E3trainCued_params(:,:,5); % Combine random guessing parameters
E3trainCued_params(:,:,5)=[];

[E3test_params, E3test_llk, E3test_Mle]= ...
    Exp3_testFit(E3_RespTest,E3_TargTest,centerE3,envRadE3);

%% RMSE

[E3_trainFreeDist, E3_trainCuedDist, E3_testDist]=E3_plotRMSE( ...
    E3_RespTrainFree,E3_TargTrainFree, ...
    E3_RespTrainCued,E3_TargTrainCued, ...
    E3_RespTest,E3_TargTest);

%% Location analysis

[E2_loc,E1_loc,E3free_loc,E3cued_loc,E3test_loc]=E3_locationAnalysis( ...
    E2_Mle,E1_Mle, ...
    E3trainFree_Mle,E3trainCued_Mle,E3test_Mle);

%% Load Experiment 4

disp('Loading Experiment 4')
E4_center=3.6;
answers = [1343	4734	10589	2606	5576	931	7333	3634	6240 ...
    4409	1331	1026	8288	6402	9966	1064	5834	7524 ...
    4386	9911	2156	9134	2533	7439];
logans=log10(answers);
[E4_RespTrain, E4_TargTrain, ...
    E4_RespTest, E4_TargTest ...
    ]=loadE4();

%% Model fit

[E4_params, E4_llk, E4_Mle]= ...
    Exp4_fit(E4_RespTrain, E4_TargTrain, E4_RespTest, E4_TargTest,E4_center,logans);

%% RMSE

[E4_rmse]=Exp4_plotRMSE(E4_RespTrain, E4_TargTrain, E4_RespTest, E4_TargTest);

%% Plot parameter fits

Exp4_plotParamFits(E4_params);



