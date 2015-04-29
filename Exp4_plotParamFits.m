function Exp4_plotParamFits(params)
%% Plot Experiment 4 parameters

paramMean=squeeze(mean(params,2)); % Session x parameter
paramStd=squeeze(std(params,[],2));

%% Plot random noise
figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

lineStyle={':','--','-'};
markerStyle={'s','d','o'};
handles=[];
for ip=2:4
    if ip==2
        a=errorbar(-1,paramMean(1,ip),paramStd(1,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',14,'LineWidth',3);
        errorbar([2 9 16 30],paramMean(2:end,ip),paramStd(2:end,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',14,'LineWidth',3);
    elseif ip==3
        a=errorbar(-1,paramMean(1,ip),paramStd(1,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',17,'LineWidth',3);
        errorbar([2 9 16 30],paramMean(2:end,ip),paramStd(2:end,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',15,'LineWidth',3);
    elseif ip==4
        a=errorbar(-1,paramMean(1,ip),paramStd(1,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',4,'LineWidth',3,'MarkerFaceColor',[0 0 0]);
        errorbar([2 9 16 30],paramMean(2:end,ip),paramStd(2:end,ip),'k','LineWidth',4,'LineStyle',lineStyle{ip-1},'Color',[0 0 0],'Marker',markerStyle{ip-1},'MarkerSize',4,'LineWidth',3,'MarkerFaceColor',[0 0 0]);
    end
    handles(ip-1)=a;
end

legh=legend(handles,{'Target','Misassociation','Random Guess'});
ylim([0 1])
xlim([-2 31])

% Labels
set(gca,'XTick',[-1 2 9 16 30])
set(gca,'XTickLabel',{'Base','0','7','14','28'})
hYLabel=ylabel({'Probability'},'FontSize',32);
hXLabel=xlabel('Days');

% Positioning and cleaning
scale = 0.1;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(hXLabel,hYLabel,nan)
set( gca,'FontSize',40 );
hold off

%% Plot noise
figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

errorbar(-1,paramMean(1),paramStd(1),'k','LineWidth',4);
errorbar([2 9 16 30],paramMean(2:end,1),paramStd(2:end,1),'k','LineWidth',4);

ylim([0 .2])
xlim([-2 31])

% Labels
set(gca,'XTick',[-1 2 9 16 30])
set(gca,'XTickLabel',{'Base','0','7','14','28'})
set(gca,'YTick',[0 .1 .2])
hYLabel=ylabel({'Imprecision: estimated SD','of city distance memories'});
hXLabel=xlabel('Days');

% Positioning and cleaning
scale = 0.1;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(hXLabel,hYLabel,nan)
set( gca,'FontSize',40 );
set( hYLabel,'FontSize',36 );
hold off

%% Plot random noise
figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

errorbar(-1,paramMean(1,5),paramStd(1,5),'k','LineWidth',4);
errorbar([2 9 16 30],paramMean(2:end,5),paramStd(2:end,5),'k','LineWidth',4);

ylim([0 1])
xlim([-2 31])

% Labels
set(gca,'XTick',[-1 2 9 16 30])
set(gca,'XTickLabel',{'Base','0','7','14','28'})
hYLabel=ylabel({'Random Guess SD'},'FontSize',32);
hXLabel=xlabel('Days');

% Positioning and cleaning
scale = 0.1;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(hXLabel,hYLabel,nan)
set( gca,'FontSize',40 );
hold off

%% Statistics

disp('Noise, base')
tempDiff=params(1,:,1);
disp(strcat('Noise base: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Noise, day0')
tempDiff=params(2,:,1);
disp(strcat('Noise day0: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Misassociations, day0')
tempDiff=params(2,:,3);
disp(strcat('Misassociations day0: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Noise, day7')
tempDiff=params(3,:,1);
disp(strcat('Noise day7: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Noise, base-day7')
tempDiff=params(1,:,1)-params(3,:,1);
disp(strcat('Noise base-day7: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Misassociation, day 7')
tempDiff=params(3,:,3);
disp(strcat('Misassociations, day 7: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Noise, day14')
tempDiff=params(4,:,1);
disp(strcat('Noise day14: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Noise, day28')
tempDiff=params(5,:,1);
disp(strcat('Noise day28: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Noise, baseline-day14')
tempDiff=params(1,:,1)-params(4,:,1);
disp(strcat('Noise baseline-day14: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Noise, baseline-day28')
tempDiff=params(1,:,1)-params(5,:,1);
disp(strcat('Noise baseline-day28: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Misassociation, day 14')
tempDiff=params(4,:,3);
disp(strcat('Misassociations, day 14: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))

disp('Misassociation, day 28')
tempDiff=params(5,:,3);
disp(strcat('Misassociations, day 28: ',num2str(mean(tempDiff))))
disp(strcat(num2str(prctile(tempDiff,2.5)),'::',num2str(prctile(tempDiff,97.5))))
