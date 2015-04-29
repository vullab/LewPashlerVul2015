function [E1_meanllk,E2_meanllk,E1Rev_meanllk] ...
    =E1_E2_plotModCompMeanLlk(E2_Mle,E1_Mle,E1Rev_Mle)

%% Convert to Mean Llk
numMod=size(E2_Mle,5);

% E1
E1_numSubj=size(E1_Mle,3);
E1_numSess=size(E1_Mle,4);
E1_meanllk=nan(E1_numSubj,E1_numSess,numMod);

for im=1:numMod
    for is=1:E1_numSubj
        for is2=1:E1_numSess
            if ~isnan(E1_Mle(1,1,is,is2,im))
                curr_llk=E1_Mle(:,:,is,is2,im);
                respLlk=mean(Exp1_TrialLikelihood(curr_llk));
                E1_meanllk(is,is2,im)=respLlk;
            end
        end
    end
end

% E1Rev
E1Rev_numSubj=size(E1Rev_Mle,3);
E1Rev_numSess=size(E1Rev_Mle,4);
E1Rev_meanllk=nan(E1Rev_numSubj,E1Rev_numSess,numMod);

for im=1:numMod
    for is=1:E1Rev_numSubj
        for is2=1:E1Rev_numSess
            curr_llk=E1Rev_Mle(:,:,is,is2,im);
            respLlk=mean(Exp1_TrialLikelihood(curr_llk));
            E1Rev_meanllk(is,is2,im)=respLlk;
        end
    end
end


% E2
E2_numSubj=size(E2_Mle,3);
E2_numSess=size(E2_Mle,4);
E2_meanllk=nan(E2_numSubj,E2_numSess,numMod);

for im=1:numMod
    for is=1:E2_numSubj
        for is2=1:E2_numSess
            curr_llk=E2_Mle(:,:,is,is2,im);
            respLlk=mean(Exp1_TrialLikelihood(curr_llk));
            E2_meanllk(is,is2,im)=respLlk;
        end
    end
end

%% Statistics

%% Plot
E1_mean=squeeze(nanmean(E1_meanllk,1));
E1_std=squeeze(nanstd(E1_meanllk,[],1))./repmat(sqrt(sqrt(sum(~isnan(E1_meanllk(:,:,1)))))',1,numMod);
E1Rev_mean=flipud(squeeze(mean(E1Rev_meanllk,1)));
E1Rev_std=flipud(squeeze(std(E1Rev_meanllk,[],1)))./repmat(sqrt(sqrt(sum(~isnan(E1Rev_meanllk(:,:,1)))))',1,numMod);
E2_mean=squeeze(mean(E2_meanllk,1));
E2_std=squeeze(std(E2_meanllk,[],1))./repmat(sqrt(sqrt(sum(~isnan(E2_meanllk(:,:,1)))))',1,numMod);

figure('Position', [100, 100, 1249, 895])
set(gcf,'color','w');
hold on

modNames={'Full','No Mis','No Rand','Target'};
handles=nan(1,numMod);
lineStyle={'-','-',':',':'};
cols=[0 0 0;.5 .5 .5; 0 0 0;.5 .5 .5];

for im=1:numMod
    a=plot([1 2 8],E2_mean(:,im),'Color',cols(im,:),'LineStyle',lineStyle{im});
    plot(-24:-5,E1_mean(:,im),'Color',cols(im,:),'LineStyle',lineStyle{im});
    plot(-3:-1,E1Rev_mean(:,im),'Color',cols(im,:),'LineStyle',lineStyle{im});
    handles(im)=a;
    
    errorbar([1 2 8],E2_mean(:,im),E2_std(:,im),'k.','Color',cols(im,:));
    errorbar(-24:-5,E1_mean(:,im),E1_std(:,im),'k.','Color',cols(im,:));
    errorbar(-3:-1,E1Rev_mean(:,im),E1Rev_std(:,im),'k.','Color',cols(im,:));
end

plot([0 0],[-500 -200],'Color',[.3 .3 .3]);

% Axes
set(gca,'XTick',[-24 -19 -14 -9  -3 -1 1 2 8 ])
set(gca,'XTickLabel',{'0','5','10','15','-2','0','0','1','7'})
hYLabel=ylabel('Response Log-Likelihood');
legh=legend(handles,modNames,'Location','SouthEast');

hx1=text(-14,-550,'Block','HorizontalAlignment','center');
hx2=text(4.5,-550,'Day','HorizontalAlignment','center');
set([hx1,hx2],'FontName', 'Helvetica','Color',[.3 .3 .3] ,'FontSize', 60);
hx3=text(-14.5,-250,'Training','HorizontalAlignment','center');
hx4=text(4,-250,'Testing','HorizontalAlignment','center');
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