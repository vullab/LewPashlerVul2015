function [E2_dist, E1_dist, E1Rev_dist]=E1_E2_plotRMSE(E2_Resp, E2_Targ,E1_Resp, E1_Targ)
%% Calculate and plot RMSE for experiments 1 and 2
% 4.15.2015-Created

%% Calculate RMSE

E1_dist=mean(sqrt(sum((E1_Resp-E1_Targ).^2,4)),3);
compBlock=sum(~isnan(E1_dist),2);
numAnalyze=2;
for ia=0:numAnalyze
    E1Rev_dist(:,ia+1)=diag(E1_dist(:,compBlock-ia));
end
E1Rev_dist=fliplr(E1Rev_dist);
E2_dist=mean(sqrt(sum((E2_Resp-E2_Targ).^2,4)),3);

%% Plot RMSE

E1_dist_mean=nanmean(E1_dist);
E1_dist_sem=nanstd(E1_dist)./sqrt(sum(~isnan(E1_dist)));
E1Rev_dist_mean=nanmean(E1Rev_dist);
E1Rev_dist_sem=nanstd(E1Rev_dist)./sqrt(sum(~isnan(E1Rev_dist)));
E2_dist_mean=nanmean(E2_dist);
E2_dist_sem=nanstd(E2_dist)./sqrt(sum(~isnan(E2_dist)));

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

errorbar(-24:-5,E1_dist_mean(1:20),E1_dist_sem(1:20),'k');
errorbar(-3:-1,E1Rev_dist_mean,E1Rev_dist_sem,'k');
errorbar([1 2 8],E2_dist_mean,E2_dist_sem,'k','LineWidth',4);

plot([0 0],[0 350],'Color',[.3 .3 .3]);
ylim([0 350])

% Axes
set(gca,'XTick',[-24 -19 -14 -9  -3 -1 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','-2','0','0','1','7'})
hYLabel=ylabel('RMSE (px)');

hx1=text(-14,-60,'Block','HorizontalAlignment','center');
hx2=text(4.5,-60,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-14.5,150,'Training','HorizontalAlignment','center');
hx4=text(4,150,'Testing','HorizontalAlignment','center');
set([ hx3,hx4],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 36);

% Positioning and cleaning
scale = 0.10;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(nan,hYLabel,nan)
hold off

%% Statistics

% Average number of blocks
disp('Average Number of Blocks')
numBlock=sum(~isnan(E2_dist),2);
disp(strcat('Mean: ',num2str(mean(numBlock)),'---SEM: ',num2str(std(numBlock)./sqrt(length(numBlock)))))

% End of E1 vs Start of E2
[H,P,CI,STATS]=ttest2(E2_dist(:,1),E1Rev_dist(:,3));
disp('RMSE end of E1 vs. start of E2')
disp(strcat('t(',num2str(STATS.df),')=',num2str(STATS.tstat),'---p=',num2str(P)))



