function [respTrain, targTrain, ...
    respTest, targTest ...
    ]=loadE4()
%% Load data from Experiment 4
% 4.17.2015-Created

%% Experiment
y = tdfread('data/Exp4.txt');

delays = [0 7 14 28];

answers = [1343	4734	10589	2606	5576	931	7333	3634	6240 ...
    4409	1331	1026	8288	6402	9966	1064	5834	7524 ...
    4386	9911	2156	9134	2533	7439];

realsubs = [23	27	44	45	46	47	48	51	53	54	55	56	57	58	60	61 ...
    62	63	64	65	66	68	69	70	71	74	75	78	79	83	84	85];

%% Calculate errors
facts = unique(y.fact);
y.error = zeros(size(y.response));
for f = [1:length(facts)]
    y.error(y.fact==facts(f)) = log10(y.response(y.fact==facts(f))./answers(f));
end

%% Filter out all debugging sessions

fields = {'subject', 'session', 'roundn', 'fact', 'rts', 'response', 'cond', 'error'};

for fn = [1:length(fields)]
    x.(fields{fn}) = [];
end

for s = [1:length(realsubs)]
    cursubi = find(y.subject == realsubs(s));
    n = length(cursubi);
    for fn = [1:length(fields)]
        x.(fields{fn})(end+1:end+n,1) = y.(fields{fn})(cursubi);
    end
end

%% Find out who completed it all
subjects = unique(x.subject);

SUBJECTS = [];
incompletes = [];
for s = [1:length(subjects)]
    if(numel(unique(x.session(x.subject==subjects(s))))==4)
        SUBJECTS(end+1) = subjects(s);
    else
        incompletes(end+1) = subjects(s);
    end
end

%% filter out all incomplete subjects

fields = {'subject', 'session', 'roundn', 'fact', 'rts', 'response', 'cond', 'error'};
z = x;
clear x;
for fn = [1:length(fields)]
    x.(fields{fn}) = [];
end

for s = [1:length(SUBJECTS)]
    cursubi = find(z.subject == SUBJECTS(s));
    n = length(cursubi);
    for fn = [1:length(fields)]
        x.(fields{fn})(end+1:end+n,1) = z.(fields{fn})(cursubi);
    end
end

%% Properties

subjects = unique(x.subject);
sessions = unique(x.session);
rounds = unique(x.roundn);
facts = unique(x.fact);
conds = unique(x.cond);
% cond=0: Training
% cond=1: First
% cond=2: Second
% cond=3: Third
% cond=4: Repeated

%% Restructure

%% Training
respTrain=nan(length(subjects),length(rounds),24);
targTrain=nan(length(subjects),length(rounds),24);

for is=1:length(subjects)
    for ir=1:length(rounds)
        subjCheck=(x.subject==subjects(is));
        roundCheck=x.roundn==ir;
        condCheck=x.cond==0;
        sessCheck=x.session==1;
        sel=subjCheck & roundCheck & condCheck &sessCheck;
        
        if ~isempty(sel)
            % Remember, accounting for drop out
            respTrain(is,ir,1:sum(sel))=x.response(sel);
            targTrain(is,ir,1:sum(sel))=answers(x.fact(sel));
        end
    end
end

%% For test
respTest=nan(length(subjects),length(sessions)-1,2,6); % uniq then repeat
targTest=nan(length(subjects),length(sessions)-1,2,6);

for is=1:length(subjects)
    for is2=2:length(sessions)
        subjCheck=(x.subject==subjects(is));
        sessionCheck=x.session==is2;
        
        condUniqCheck=x.cond~=4;
        selUniq=subjCheck & sessionCheck & condUniqCheck;
        
        condRepCheck=x.cond==4;
        selRep=subjCheck & sessionCheck & condRepCheck;
        
        if ~isempty(selUniq)
            % Unique objects
            respTest(is,is2-1,1,:)=x.response(selUniq);
            targTest(is,is2-1,1,:)=answers(x.fact(selUniq));
            
            % Repeated objects
            respTest(is,is2-1,2,:)=x.response(selRep);
            targTest(is,is2-1,2,:)=answers(x.fact(selRep));
        end
    end
end

%% Log them
respTrain=log10(respTrain);
targTrain=log10(targTrain);
respTest=log10(respTest);
targTest=log10(targTest);





