function E1_E2_plotErrorPartition(E2_Resp, E2_Targ,E1_Resp, E1_Targ, ...
    E2_dist, E1_dist, E1Rev_dist, ...
    E2_Mle,E1_Mle,E1Rev_Mle, ...
    centerE2,centerE1, ...
    E2_params,E1_params,E1Rev_params)
%% Divide RMSE into different types of errors
% 4.15.2015-Created

%% Partition RMSE

% E1
E1_sd=mean(E1_params(:,:,1),2);
[E1_part]=errorPartition(E1_Resp, E1_Targ,E1_Mle,centerE1,E1_sd);

% E1Rev
compBlock=sum(~isnan(E1_dist),2);
for is=1:length(compBlock)
    for ib=1:3
        E1Rev_Resp(is,ib,:,:)=squeeze(E1_Resp(is,compBlock(is)+1-ib,:,:));
        E1Rev_Targ(is,ib,:,:)=squeeze(E1_Targ(is,compBlock(is)+1-ib,:,:));
    end
end

E1Rev_sd=mean(E1Rev_params(:,:,1),2);
[E1Rev_part]=errorPartition(E1Rev_Resp, E1Rev_Targ,E1Rev_Mle,centerE1,E1Rev_sd);

% E2
E2_sd=mean(E2_params(:,:,1),2);
[E2_part]=errorPartition(E2_Resp, E2_Targ,E2_Mle,centerE2,E2_sd);

%% Average
% Block x error type
E1_mean=squeeze(nanmean(E1_part));
E1Rev_mean=flipud(squeeze(mean(E1Rev_part)));
E2_mean=squeeze(mean(E2_part));

E1_sum=cumsum(E1_mean,2);
E1Rev_sum=cumsum(E1Rev_mean,2);
E2_sum=cumsum(E2_mean,2);


%% Plot

% Average distances
E1_dist_mean=nanmean(E1_dist);
E1_dist_sem=nanstd(E1_dist)./sqrt(sum(~isnan(E1_dist)));
E1Rev_dist_mean=nanmean(E1Rev_dist);
E1Rev_dist_sem=nanstd(E1Rev_dist)./sqrt(sum(~isnan(E1Rev_dist)));
E2_dist_mean=nanmean(E2_dist);
E2_dist_sem=nanstd(E2_dist)./sqrt(sum(~isnan(E2_dist)));

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

% Stack plot error partition
stackCol=[.25 .25 .25;.5 .5 .5;.75 .75 .75];
handles=nan(1,3);
for ie=3:-1:1
    a=fill([1 1 2 8 8],[0 E2_sum(:,ie)' 0],stackCol(ie,:));
    handles(ie)=a;
    fill([-24 -24:-5 -5],[0 E1_sum(:,ie)' 0],stackCol(ie,:))
    fill([-3 -3:-1 -1],[0 E1Rev_sum(:,ie)' 0],stackCol(ie,:))
    
end

% Plot RMSE
errorbar(-24:-5,E1_dist_mean(1:20),E1_dist_sem(1:20),'k');
errorbar(-3:-1,E1Rev_dist_mean,E1Rev_dist_sem,'k');
errorbar([1 2 8],E2_dist_mean,E2_dist_sem,'k','LineWidth',4);

plot([0 0],[0 350],'Color',[.3 .3 .3]);
ylim([0 350])
legend(handles,{'Noise','Misassociation','Random Guess'})
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

end