function [E2_aic,E1_aic,E1Rev_aic]=E1_E2_plotModComp(E2_llk,E1_llk,E1Rev_llk)

%% Convert to AIC
numMod=size(E1_llk,3);
E1_numParams=[4 2 3 1];
E1Rev_numParams=[4 2 3 1];
E2_numParams=[3 2 2 1];

E1_aic=nan(size(E1_llk));
E1Rev_aic=nan(size(E1Rev_llk));
E2_aic=nan(size(E2_llk));

for im=1:numMod
    E1_aic(:,:,im)=2*E1_numParams(im)-2*E1_llk(:,:,im);
    E1Rev_aic(:,:,im)=2*E1Rev_numParams(im)-2*E1Rev_llk(:,:,im);
    E2_aic(:,:,im)=2*E2_numParams(im)-2*E2_llk(:,:,im);
end


%% Statistics
E1_minDif_mean=mean(min(E1_aic(:,:,2:end),[],3)-E1_aic(:,:,1),2);
E1_minDif_std=std(min(E1_aic(:,:,2:end),[],3)-E1_aic(:,:,1),[],2);
E1Rev_minDif_mean=mean(min(E1Rev_aic(:,:,2:end),[],3)-E1Rev_aic(:,:,1),2);
E1Rev_minDif_std=std(min(E1Rev_aic(:,:,2:end),[],3)-E1Rev_aic(:,:,1),[],2);
E2_minDif_mean=mean(min(E2_aic(:,:,2:end),[],3)-E2_aic(:,:,1),2);
E2_minDif_std=std(min(E2_aic(:,:,2:end),[],3)-E2_aic(:,:,1),[],2);

disp('During training, how many blocks did the full model do the best in?')
tempDiff=min(E1_aic(:,:,2:end),[],3)-E1_aic(:,:,1);
disp(sum(prctile(tempDiff,2.5,2)>0))

disp('During testing, how many blocks did the full model do the best in?')
tempDiff=min(E2_aic(:,:,2:end),[],3)-E2_aic(:,:,1);
disp(sum(prctile(tempDiff,2.5,2)>0))

%% Plot
E1_mean=squeeze(mean(E1_aic,2));
E1_std=squeeze(std(E1_aic,[],2));
E1Rev_mean=flipud(squeeze(mean(E1Rev_aic,2)));
E1Rev_std=flipud(squeeze(std(E1Rev_aic,[],2)));
E2_mean=squeeze(mean(E2_aic,2));
E2_std=squeeze(std(E2_aic,[],2));

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

modNames={'Full','No Mis','No Rand','Target'};
handles=nan(1,numMod);
lineStyle={'-','-',':',':'};
cols=[0 0 0;.5 .5 .5; 0 0 0;.5 .5 .5];

for im=1:numMod
    plot(-24:-5,E1_mean(:,im),'Color',cols(im,:),'LineStyle',lineStyle{im});
    plot(-3:-1,E1Rev_mean(:,im),'Color',cols(im,:),'LineStyle',lineStyle{im});
    a=plot([1 2 8],E2_mean(:,im),'Color',cols(im,:),'LineStyle',lineStyle{im});
    handles(im)=a;
    
    errorbar(-24:-5,E1_mean(:,im),E1_std(:,im),'k.','Color',cols(im,:));
    errorbar(-3:-1,E1Rev_mean(:,im),E1Rev_std(:,im),'k.','Color',cols(im,:));
    errorbar([1 2 8],E2_mean(:,im),E2_std(:,im),'k.','Color',cols(im,:));
end

plot([0 0],[0 4]*10^5,'Color',[.3 .3 .3]);

% Axes
set(gca,'XTick',[-24 -19 -14 -9  -3 -1 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','-2','0','0','1','7'})
hYLabel=ylabel('AIC');
legh=legend(handles,modNames,'Location','North');

hx1=text(-14,-.7*10^5,'Block','HorizontalAlignment','center');
hx2=text(4.5,-.7*10^5,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-14.5,.5*10^5,'Training','HorizontalAlignment','center');
hx4=text(4,.5*10^5,'Testing','HorizontalAlignment','center');
set([ hx3,hx4],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 36);


% Positioning and cleaning
scale = 0.10;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(nan,hYLabel,legh)
set([legh],'FontSize'   , 35 )
hold off

%% Minimum difference

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

plot(-24:-5,E1_minDif_mean,'Color','k','LineStyle','-');
plot(-3:-1,E1Rev_minDif_mean,'Color','k','LineStyle','-');
plot([1 2 8],E2_minDif_mean,'Color','k','LineStyle','-');

errorbar(-24:-5,E1_minDif_mean,E1_minDif_std,'Color','k','LineStyle','-');
errorbar(-3:-1,E1Rev_minDif_mean,E1Rev_minDif_std,'Color','k','LineStyle','-');
errorbar([1 2 8],E2_minDif_mean,E2_minDif_std,'Color','k','LineStyle','-');

plot([0 0],[-.6 .3]*10^5,'Color',[.3 .3 .3]);
ylim([-.6 .2]*10^5)
% Axes
set(gca,'XTick',[-24 -19 -14 -9  -3 -1 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','-2','0','0','1','7'})
hYLabel=ylabel('Minimum AIC Difference');
legh=legend(handles,modNames,'Location','North');

hx1=text(-14,-.75*10^5,'Block','HorizontalAlignment','center');
hx2=text(4.5,-.75*10^5,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-14.5,-.3*10^5,'Training','HorizontalAlignment','center');
hx4=text(4,-.3*10^5,'Testing','HorizontalAlignment','center');
set([ hx3,hx4],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 36);

% Positioning and cleaning
scale = 0.10;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
prettyplot(nan,hYLabel,legh)
set([legh],'FontSize'   , 35 )
hold off

end