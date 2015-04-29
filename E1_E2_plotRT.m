function E1_E2_plotRT(allStru2,allStru1,E2_Mle,E1_Mle)
%% Test reaction time data
% 4.19.2015-Created

% For Experiment 2
E1_rt={[] [] []};
E1_subj={[] [] []};
E1_rtRand={[] []};
E1_subjRand={[] []};
for is=1:size(E1_Mle,3)
    for is2=1:size(E1_Mle,4)
        if ~isnan(E1_Mle(1,1,is,is2))
            [a samp]=max(E1_Mle(:,:,is,is2),[],2);
            currTime=log10([allStru1{is,is2}.time]);
            
            targ=samp==(1:10)';
            mis=samp~=(1:10)' & samp<11;
            r_err=samp>=11;
            
            E1_rt{1}=[E1_rt{1} currTime(targ)];
            E1_rt{2}=[E1_rt{2} currTime(mis)];
            E1_rt{3}=[E1_rt{3} currTime(r_err)];
            E1_subj{1}=[E1_subj{1} repmat(is,1,length(currTime(targ)))];
            E1_subj{2}=[E1_subj{2} repmat(is,1,length(currTime(mis)))];
            E1_subj{3}=[E1_subj{3} repmat(is,1,length(currTime(r_err)))];
            
            r_err2=samp==11;
            r_err3=samp>=11;
            E1_rtRand{1}=[E1_rtRand{1} currTime(r_err2)];
            E1_rtRand{2}=[E1_rtRand{2} currTime(r_err3)];
            E1_subjRand{1}=[E1_subjRand{1} repmat(is,1,length(currTime(r_err2)))];
            E1_subjRand{2}=[E1_subjRand{2} repmat(is,1,length(currTime(r_err3)))];
        end
    end
end
disp('Experiment 1 RT')
E1_AllRts=[E1_rt{1}';E1_rt{2}';E1_rt{3}'];
E1_AllSubjs=[E1_subj{1}';E1_subj{2}';E1_subj{3}'];
E1_ErrType=[ones(length(E1_rt{1}),1);2*ones(length(E1_rt{2}),1);3*ones(length(E1_rt{3}),1)];
tempTable2=table(E1_ErrType,E1_AllSubjs,E1_AllRts,'VariableNames',{'Errtype','Subj','RT'});
lme2 = fitlme(tempTable2,'RT~Errtype+(1|Subj)+(1|Subj:Errtype)');
disp(lme2)

disp('Random RT')
E1_AllRtsRand=[E1_rtRand{1}';E1_rtRand{2}'];
E1_AllSubjsRand=[E1_subjRand{1}';E1_subjRand{2}'];
E1_ErrTypeRand=[ones(length(E1_rtRand{1}),1);2*ones(length(E1_rtRand{2}),1)];
tempTableRand=table(E1_ErrTypeRand,E1_AllSubjsRand,E1_AllRtsRand,'VariableNames',{'Errtype','Subj','RT'});
lmeRand = fitlme(tempTableRand,'RT~Errtype+(1|Subj)+(1|Subj:Errtype)');
disp(lmeRand)

%% Experiment 2

E2_rt={[] [] []};
E2_subj={[] [] []};
for is=1:size(E2_Mle,3)
    for is2=1:size(E2_Mle,4)
        [a samp]=max(E2_Mle(:,:,is,is2),[],2);
        currTime=log10([allStru2{is}{2+is2}.time]);
        
        targ=samp==(1:10)';
        mis=samp~=(1:10)' & samp~=11;
        r_err=samp==11;
        
        E2_rt{1}=[E2_rt{1} currTime(targ)];
        E2_rt{2}=[E2_rt{2} currTime(mis)];
        E2_rt{3}=[E2_rt{3} currTime(r_err)];
        
        E2_subj{1}=[E2_subj{1} repmat(is,1,length(currTime(targ)))];
        E2_subj{2}=[E2_subj{2} repmat(is,1,length(currTime(mis)))];
        E2_subj{3}=[E2_subj{3} repmat(is,1,length(currTime(r_err)))];
    end
end
disp('Experiment 2 RT')
E2_AllRts=[E2_rt{1}';E2_rt{2}';E2_rt{3}'];
E2_AllSubjs=[E2_subj{1}';E2_subj{2}';E2_subj{3}'];
E2_ErrType=[ones(length(E2_rt{1}),1);2*ones(length(E2_rt{2}),1);3*ones(length(E2_rt{3}),1)];
tempTable1=table(E2_ErrType,E2_AllSubjs,E2_AllRts,'VariableNames',{'Errtype','Subj','RT'});
lme1 = fitlme(tempTable1,'RT~Errtype+(1|Subj)+(1|Subj:Errtype)');
disp(lme1)

