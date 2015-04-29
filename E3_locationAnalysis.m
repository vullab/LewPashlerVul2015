function [E1_loc,E2_loc,E3free_loc,E3cued_loc,E3test_loc]=E3_locationAnalysis( ...
    E2_Mle,E1_Mle, ...
    E3trainFree_Mle,E3trainCued_Mle,E3test_Mle)
%% Use MLE to identify how many unique objects recalled in each experiment
% 4.17.2015-Created

%% Calculate unique locations recalled
E1_loc=calcNumLoc(E1_Mle);
E2_loc=calcNumLoc(E2_Mle);
E3free_loc=calcNumLoc(E3trainFree_Mle);
E3cued_loc=calcNumLoc(E3trainCued_Mle);
E3test_loc=calcNumLoc(E3test_Mle);

%% Plot
E1_mean=nanmean(E1_loc);
E1_sem=nanstd(E1_loc)./sqrt(sum(~isnan(E1_loc)));
E2_mean=nanmean(E2_loc);
E2_sem=nanstd(E2_loc)./sqrt(sum(~isnan(E2_loc)));

trainFreeLoc_mean=nanmean(E3free_loc);
trainFreeLoc_sem=nanstd(E3free_loc)./sqrt(sum(~isnan(E3free_loc)));
trainCuedLoc_mean=nanmean(E3cued_loc);
trainCuedLoc_sem=nanstd(E3cued_loc)./sqrt(sum(~isnan(E3cued_loc)));
testLoc_mean=nanmean(E3test_loc);
testLoc_sem=nanstd(E3test_loc)./sqrt(sum(~isnan(E3test_loc)));

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

% E1
fill([-20:-1 fliplr(-20:-1)],[E1_mean+E1_sem fliplr(E1_mean-E1_sem)],[.75 .75 .75],'LineStyle','none');
plot(-20:-1,E1_mean,'Color',[.5 .5 .5])

% E2
fill([1 2 8 8 2 1],[E2_mean+E2_sem fliplr(E2_mean-E2_sem)],[.75 .75 .75],'LineStyle','none');
plot([1 2 8],E2_mean,'Color',[.5 .5 .5])

% E3
a=errorbar([1 2 8],testLoc_mean,testLoc_sem,'k','LineWidth',4);
errorbar(-20:-1,trainCuedLoc_mean(1:20),trainCuedLoc_sem(1:20),'k.','Color',[.5 .5 .5],'LineWidth',4,'Marker','o','MarkerSize',8);
b=plot([-100 -100],[-1 -1],'k-','Color',[.5 .5 .5],'LineWidth',4,'Marker','o','MarkerSize',8);
c=errorbar(-19:2:-1,trainFreeLoc_mean(1:10),trainFreeLoc_sem(1:10),'k.','LineWidth',4);

plot([0 0],[0 10],'Color',[.3 .3 .3]);
ylim([0 10])

% Axes
set(gca,'XTick',[-20 -15 -10 -5 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','0','1','7'})
hYLabel=ylabel('Number of Locations');
xlim([-21 9])
legh=legend([b a],{'Cued Recall','Free Recall'},'Location','SouthEast');

hx1=text(-10,-1.7,'Block','HorizontalAlignment','center');
hx2=text(4.5,-1.7,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-10,3,'Training','HorizontalAlignment','center');
hx4=text(4,3,'Testing','HorizontalAlignment','center');
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
disp('Locations recalled in the first block')
disp('Cued')
disp(strcat('Mean: ',num2str(mean(E3cued_loc(:,2))),'SEM',num2str(std(E3cued_loc(:,2))/sqrt(size(E3cued_loc,1)))))
disp('Free')
disp(strcat('Mean: ',num2str(mean(E3free_loc(:,1))),'SEM',num2str(std(E3free_loc(:,1))/sqrt(size(E3free_loc,1)))))

disp('Did subjects recall more locations during learning?')
E3cued_loc2=E3cued_loc(:,2:2:end);
E3free_loc2=E3free_loc(:,1:10);
% indicator variables
subInd=repmat((1:74)',1,size(E3free_loc2,2));% subj
blockInd=repmat(1:size(E3free_loc,2),size(E3free_loc2,1),1);% block
cond1=ones(size(E3free_loc2)); % cond
cond2=2*ones(size(E3cued_loc2)); % cond

nansel=~isnan(E3free_loc2);
rmse_all=[E3free_loc2(nansel);E3cued_loc2(nansel)];
subs_all=[subInd(nansel);subInd(nansel) ];
block_all=[blockInd(nansel);blockInd(nansel) ];
conds2_all=[cond1(nansel);cond2(nansel) ];

tempTable1=table(rmse_all,subs_all,block_all,conds2_all,'VariableNames',{'locs','subs','block','cond'});
lme1 = fitlme(tempTable1,'locs~cond*block+(1|subs)+(1|subs:cond)+(1|subs:block)');
disp(lme1)

disp('Did subjects know locations equally well at the start of test?')
[h p ci stats]=ttest2(E1_loc(:,1),E3test_loc(:,1));
disp(strcat('t(',num2str(stats.df),'): ',num2str(stats.tstat),' p: ',  num2str(p)))

disp('Did subjects recall more locations during forgetting?')
subInd1=repmat((1:37)',1,size(E2_loc,2));% subj
subInd2=repmat(37+(1:25)',1,size(E3test_loc,2));% subj
blockInd1=repmat(1:size(E2_loc,2),size(E2_loc,1),1);% block
blockInd2=repmat((1:size(E3test_loc,2)),size(E3test_loc,1),1);% block
cond1=ones(size(E2_loc)); % cond
cond2=2*ones(size(E3test_loc)); % cond

nansel1=~isnan(E2_loc);
nansel2=~isnan(E3test_loc);
locs_all=[E2_loc(nansel1);E3test_loc(nansel2)];
subs_all=[subInd1(nansel1);subInd2(nansel2) ];
block_all=[blockInd1(nansel1);blockInd2(nansel2) ];
conds2_all=[cond1(nansel1);cond2(nansel2) ];

tempTable1=table(locs_all,subs_all,block_all,conds2_all,'VariableNames',{'locs','subs','block','cond'});
lme1 = fitlme(tempTable1,'locs~cond*block+(1|subs)+(1|subs:block)');
disp(lme1)

%% Calculate locations
    function numLoc=calcNumLoc(mle)
        numSubj=size(mle,3);
        numSess=size(mle,4);
        
        numLoc=nan(numSubj,numSess);
        for is=1:numSubj
            for is2=1:numSess
                if ~isnan(mle(1,1,is,is2))
                    currMle=mle(:,:,is,is2);
                    [blank, samp]=max(currMle,[],2);
                    samp2=samp(samp<=10);
                    numLoc(is,is2)=length(unique(samp2));
                end
            end
        end
        
        
    end


end