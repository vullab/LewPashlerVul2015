function [trainFreeDist, trainCuedDist, testDist]=E3_plotRMSE( ...
    respTrainFree,targTrainFree, ...
    respTrainCued,targTrainCued, ...
    respTest,targTest)
%% Calculate and plot RMSE for experiment 3
% 4.15.2015-Created

%% Calculate RMSE
trainFreeDist=mean(sqrt(sum(((respTrainFree-targTrainFree).^2),4)),3);
trainCuedDist=mean(sqrt(sum(((respTrainCued-targTrainCued).^2),4)),3);
testDist=mean(sqrt(sum(((respTest-targTest).^2),4)),3);

%% Plot RMSE

trainFreeDist_mean=nanmean(trainFreeDist);
trainFreeDist_sem=nanstd(trainFreeDist)./sqrt(sum(~isnan(trainFreeDist)));
trainCuedDist_mean=nanmean(trainCuedDist);
trainCuedDist_sem=nanstd(trainCuedDist)./sqrt(sum(~isnan(trainCuedDist)));
testDist_mean=nanmean(testDist);
testDist_sem=nanstd(testDist)./sqrt(sum(~isnan(testDist)));

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

a=errorbar([1 2 8],testDist_mean,testDist_sem,'k','LineWidth',4);
b=errorbar(-20:-1,trainCuedDist_mean(1:20),trainCuedDist_sem(1:20),'Color',[.5 .5 .5],'LineWidth',4);
c=errorbar(-19:2:-1,trainFreeDist_mean(1:10),trainFreeDist_sem(1:10),'k.','LineWidth',4);

plot([0 0],[0 250],'Color',[.3 .3 .3]);
ylim([0 250])

% Axes
set(gca,'XTick',[-20 -15 -10 -5 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','0','1','7'})
hYLabel=ylabel('RMSE (px)');
xlim([-21 9])
legh=legend([b a],{'Cued Recall','Free Recall'},'Location','NorthEast');

hx1=text(-10,-45,'Block','HorizontalAlignment','center');
hx2=text(4.5,-45,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-10,175,'Training','HorizontalAlignment','center');
hx4=text(4,175,'Testing','HorizontalAlignment','center');
set([ hx3,hx4],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 36);

% Positioning and cleaning
scale = 0.10;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(nan,hYLabel,legh)
hold off



%% Statistics

disp('Were free and cued recall performance correlated?')
trainFreeDist2=trainFreeDist(~isnan(trainFreeDist));
trainCuedDist2=trainCuedDist(:,2:2:end);
trainCuedDist3=trainCuedDist2(~isnan(trainCuedDist2));
[r p]=corr(trainFreeDist2,trainCuedDist3);
disp(strcat('r: ',num2str(r),'::p=',num2str(p)))

disp('Compare performance in free and cued recall')
% indicator variables
subInd=repmat((1:74)',1,size(trainFreeDist,2));% subj
blockInd=repmat(1:size(trainFreeDist,2),size(trainFreeDist,1),1);% block
cond1=ones(size(trainFreeDist)); % cond
cond2=2*ones(size(trainCuedDist2)); % cond

nansel=~isnan(trainFreeDist);
rmse_all=[trainFreeDist(nansel);trainCuedDist2(nansel)];
subs_all=[subInd(nansel);subInd(nansel) ];
block_all=[blockInd(nansel);blockInd(nansel) ];
conds2_all=[cond1(nansel);cond2(nansel) ];

% Remove non matching block
excess=block_all==11;
rmse_all(excess)=[];
subs_all(excess)=[];
block_all(excess)=[];
conds2_all(excess)=[];

tempTable1=table(rmse_all,subs_all,block_all,conds2_all,'VariableNames',{'rmse','subs','block','cond'});
lme1 = fitlme(tempTable1,'rmse~cond*block+(1|subs)+(1|subs:cond)+(1|subs:block)');
disp(lme1)
