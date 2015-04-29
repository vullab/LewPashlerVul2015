function [rmseTrain,rmseUniTest,rmseRepTest]= ...
    Exp4_plotRMSE(respTrain, targTrain, respTest, targTest)
%% Calculate and plot RMSE for experiment 4
% 4.15.2015-Created

%% Calculate RMSE

rmseTrain=sqrt((respTrain-targTrain).^2);
rmseTrain(isnan(rmseTrain))=.002;
rmseTrain=mean(rmseTrain,3);

rmseUniTest=mean(sqrt((respTest(:,:,1,:)-targTest(:,:,1,:)).^2),4); 
rmseRepTest=mean(sqrt((respTest(:,:,2,:)-targTest(:,:,2,:)).^2),4); 

subjRound=sum(~isnan(nanmean(respTrain,3)),2);
tempRmse=nan(1,length(subjRound));
for isub=1:length(subjRound)
    tempResp=squeeze(respTrain(isub,subjRound(isub),:));
    tempTarg=squeeze(targTrain(isub,subjRound(isub),:));
    tempRmse(isub)=mean(sqrt((tempResp-tempTarg).^2));
end
rmseUniTest=[tempRmse' rmseUniTest];
rmseRepTest=[tempRmse' rmseRepTest];

%% Plot RMSE

train_mean=nanmean(rmseTrain);
train_sem=nanstd(rmseTrain)./sqrt(sum(~isnan(rmseTrain)));
uni_mean=nanmean(rmseUniTest);
uni_sem=nanstd(rmseUniTest)./sqrt(sum(~isnan(rmseUniTest)));
rep_mean=nanmean(rmseRepTest);
rep_sem=nanstd(rmseRepTest)./sqrt(sum(~isnan(rmseRepTest)));

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

a=errorbar([2 9 16 30]+.5,uni_mean,uni_sem,'ko','LineWidth',4,'Color',[.5 .5 .5],'MarkerSize',7);
b=errorbar([2 9 16 30]-.5,rep_mean,rep_sem,'k-','LineWidth',4);
c=errorbar(-20:-1,train_mean(1:20),train_sem(1:20),'k-','LineWidth',4);

plot([0 0],[0 .4],'Color',[.3 .3 .3]);
ylim([0 .4])

% Axes
set(gca,'XTick',[-20 -15 -10 -5 2 9 16 30])
set(gca,'XTickLabel',{'0','5','10','15','0','7','14','28'})
hYLabel=ylabel('RMSE (Log_1_0 Error)');
xlim([-21 31])
legh=legend([a b],{'Single','Repeated'},'Location','SouthEast');

hx1=text(-10,-.07,'Block','HorizontalAlignment','center');
hx2=text(16,-.07,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-10,.35,'Training','HorizontalAlignment','center');
hx4=text(16,.35,'Testing','HorizontalAlignment','center');
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
disp('Length of training')
finishBlocks=sum(~isnan(nanmean(respTrain,3)),2);
disp(strcat( 'Mean: ',num2str(mean(finishBlocks)),'::','SEM: ',num2str(std(finishBlocks)/length(finishBlocks))      ))

disp('Was performance at the start of training different from during testing?')
compRmse=(rmseUniTest(:,2:4)+rmseRepTest(:,2:4))/2;
allRmse=[rmseTrain(:,1) compRmse;];
subs=repmat([1:24]',1,4);
conds=repmat(1:4,24,1);

tempTable1=table(allRmse(:),subs(:), conds(:),'VariableNames',{'rmse','subs','cond'});
lme1 = fitlme(tempTable1,'rmse~cond+(1|subs)+(1|subs:cond)');
disp(lme1)

disp('Was single different from repeated testing?')
singRmse=rmseUniTest(:,2:4);
repRmse=rmseRepTest(:,2:4);
allRmse=[singRmse repRmse];
allBlock=[repmat(1:3,size(singRmse,1),1) repmat(1:3,size(singRmse,1),1)];
subs=repmat([1:24]',1,6);
conds=[ones(size(singRmse)) 2*ones(size(repRmse))];

tempTable1=table(allRmse(:),subs(:), conds(:),allBlock(:),'VariableNames',{'rmse','subs','cond','block'});
lme1 = fitlme(tempTable1,'rmse~cond*block+(1|subs)+(1|subs:cond)+(1|subs:block)');
disp(lme1)


