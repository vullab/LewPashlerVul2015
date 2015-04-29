function [curveParams]=E1_E2_plotParamFits(E2_params,E1_params,E1Rev_params)
%% Fit exp learning curves and plot the parameter fits for E1 and E2
% 4.15.2015-Created

%% Means & Sd
E1_paramsBlock_mean=squeeze(mean(E1_params,2));
E1Rev_paramsBlock_mean=squeeze(mean(E1Rev_params,2));
E1Rev_paramsBlock_mean=flipud(E1Rev_paramsBlock_mean);
E2_paramsBlock_mean=squeeze(mean(E2_params,2));

E1_paramsBlock_std=squeeze(std(E1_params,[],2));
E1Rev_paramsBlock_std=squeeze(std(E1Rev_params,[],2));
E1Rev_paramsBlock_std=flipud(E1Rev_paramsBlock_std);
E2_paramsBlock_std=squeeze(std(E2_params,[],2));


%% Exp learning curve fits

if ~exist('E1_E2_expFit.mat')
    [noiseCurveParams]=hierExpSlope(E1_params(:,:,1),0);
    [targCurveParams]=hierExpSlope(E1_params(:,:,2),1);
    [misCurveParams]=hierExpSlope(E1_params(:,:,3),1);
    [randCurveParams]=hierExpSlope(E1_params(:,:,4),1);
    curveParams2={noiseCurveParams,targCurveParams,misCurveParams,randCurveParams};
    curveParams={squeeze(mean(noiseCurveParams,3)), ...
        squeeze(mean(targCurveParams,3)), ...
        squeeze(mean(misCurveParams,3)), ...
        squeeze(mean(randCurveParams,3))};
    save('E1_E2_expFit.mat','curveParams','curveParams2')
else
    load('E1_E2_expFit.mat')
end

%% Plot noise
figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

errorbar(-24:-5,E1_paramsBlock_mean(:,1),E1_paramsBlock_std(:,1),'k.','Color',[.5 .5 .5],'MarkerSize',10,'LineWidth',3);
noiseParams=mean(curveParams{1},1);
plot(-24:-5,noiseParams(2)+((noiseParams(1)-noiseParams(2))*exp(-(0:19)/noiseParams(3))),'k')
errorbar(-3:-1,E1Rev_paramsBlock_mean(:,1),E1Rev_paramsBlock_std(:,1),'k');

errorbar([1 2 8],E2_paramsBlock_mean(:,1),E2_paramsBlock_std(:,1),'k','LineWidth',4);

plot([0 0],[0 160],'Color',[.3 .3 .3]);
ylim([0 160])
xlim([-25 9])

% Labels
set(gca,'XTick',[-24 -19 -14 -9  -3 -1 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','-2','0','0','1','7'})
hYLabel=ylabel({'Imprecision: estimated','SD of location memories (px)'},'FontSize',32);
hx1=text(-14,-30,'Block','HorizontalAlignment','center');
hx2=text(4.5,-30,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-14.5,75,'Training','HorizontalAlignment','center');
hx4=text(4,75,'Testing','HorizontalAlignment','center');
set([ hx3,hx4],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 36);

% Positioning and cleaning
scale = 0.1;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(nan,nan,nan)
set( gca,'FontSize',40 );
hold off


%% Plot mixture weights
figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

errName={'Target','Misassociation','Random Guess'};
handles=nan(1,length(errName));
lineStyle={':','--','-'};
markerStyle={'s','d','o'};
for ip=2:4
    % Dummy for legend
    if ip==2
        a=errorbar((-24:-5)-1000,E1_paramsBlock_mean(:,ip),E1_paramsBlock_std(:,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',14,'LineWidth',3);
    elseif ip==3
        a=errorbar((-24:-5)-1000,E1_paramsBlock_mean(:,ip),E1_paramsBlock_std(:,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',15,'LineWidth',3);
    elseif ip==4
        a=errorbar((-24:-5)-1000,E1_paramsBlock_mean(:,ip),E1_paramsBlock_std(:,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',4,'LineWidth',3,'MarkerFaceColor',[0 0 0]);
    end
    handles(ip-1)=a;
    
    % Actual
    errorbar([1 2 8],E2_paramsBlock_mean(:,ip),E2_paramsBlock_std(:,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1});
    if ip==2
        eh=errorbar((-24:-5),E1_paramsBlock_mean(:,ip),E1_paramsBlock_std(:,ip),'k.','Color',[.5 .5 .5],'Marker',markerStyle{ip-1},'MarkerSize',12,'LineWidth',3);
    elseif ip==3
        eh=errorbar((-24:-5),E1_paramsBlock_mean(:,ip),E1_paramsBlock_std(:,ip),'k.','Color',[.5 .5 .5],'Marker',markerStyle{ip-1},'MarkerSize',12,'LineWidth',3);
    elseif ip==4
        eh=errorbar((-24:-5),E1_paramsBlock_mean(:,ip),E1_paramsBlock_std(:,ip),'k.','Color',[.5 .5 .5],'Marker',markerStyle{ip-1},'MarkerSize',4,'LineWidth',3,'MarkerFaceColor',[.5 .5 .5]);
    end
    errorbar_tick(eh,inf);
    noiseParams=mean(curveParams{ip},1);
    plot(-24:-5,noiseParams(2)+((noiseParams(1)-noiseParams(2))*exp(-(0:19)/noiseParams(3))),'k','LineStyle',lineStyle{ip-1})
    errorbar(-3:-1,E1Rev_paramsBlock_mean(:,ip),E1Rev_paramsBlock_std(:,ip),'k','LineStyle',lineStyle{ip-1});
end

plot([0 0],[0 160],'Color',[.3 .3 .3]);
ylim([0 1])
xlim([-25 9])
legh=legend(handles,errName,'Location','East');
set(legh,'position',[.65 .45 .4 .2])

% Labels
set(gca,'XTick',[-24 -19 -14 -9  -3 -1 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','-2','0','0','1','7'})
hYLabel=ylabel('Probability');
hx1=text(-14,-.17,'Block','HorizontalAlignment','center');
hx2=text(4.5,-.17,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-14.5,.25,'Training','HorizontalAlignment','center');
hx4=text(4,.25,'Testing','HorizontalAlignment','center');
set([ hx3,hx4],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 36);

% Positioning and cleaning
scale = 0.1;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(nan,nan,legh)
set( gca,'FontSize',40 );
hold off

%% Statistics
fprintf('\n')

%% E1
disp('E1 Exp Learning curve fits')
errName={'Noise','Target','Misassociation','Random Guess'};
paramName={'A','B','Tau'};
for ie=1:4
    disp(errName{ie})
    
    for ip=1:3
        currFits=curveParams{ie}(:,ip);
        disp(strcat(paramName{ip},': ',num2str(mean(currFits))))
        disp(strcat(num2str(prctile(curveParams{ie}(:,ip),2.5)),'::',num2str(prctile(curveParams{ie}(:,ip),97.5))))
    end
    fprintf('\n')
end

disp('Were associations learned slower than locations?')
targNoiseDiff=curveParams{2}(:,3)-curveParams{1}(:,3);
disp(strcat('Targ-Noise Diff: ',num2str(mean(targNoiseDiff))))
disp(strcat(num2str(prctile(targNoiseDiff,2.5)),'::',num2str(prctile(targNoiseDiff,97.5))))

%% E2
disp('E2 Forgetting by session')
disp('Was random guessing constant the first two days?')
tempDiff=E2_params(1,:,4)-E2_params(2,:,4);
disp(strcat('RG Day0--RG Day1 Diff: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Random guessing--Day 0 vs day 7?')
tempDiff=E2_params(1,:,4)-E2_params(3,:,4);
disp(strcat('RG Day0--RG Day7 Diff: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Random guessing--Day 1 vs day 7?')
tempDiff=E2_params(2,:,4)-E2_params(3,:,4);
disp(strcat('RG Day1--RG Day7 Diff: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Were misassociations constant the first two days?')
tempDiff=E2_params(1,:,3)-E2_params(2,:,3);
disp(strcat('Miss Day0--Miss Day1 Diff: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Misassociations--Day 1 vs day 7?')
tempDiff=E2_params(2,:,3)-E2_params(3,:,3);
disp(strcat('Miss Day1--Miss Day7 Diff: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Misassociations--Day 0 vs day 7?')
tempDiff=E2_params(1,:,3)-E2_params(3,:,3);
disp(strcat('Miss Day0--Miss Day7 Diff: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Misassociations vs Random guessing--Day 0 vs day 1?')
tempDiff=(E2_params(2,:,3)-E2_params(1,:,3))-(E2_params(2,:,4)-E2_params(1,:,4));
disp(strcat('Miss-Rand Day0--Miss Day1 Diff: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

