function [allData,allStru]=loadE1()
%% spaceBatAnalysis2
% Basic training to criterion with ten items without dropout
% Created 4.1.2013
% 5.7.2013-ltmGibbs3_1 compatible
% Turned into function for first year project report 5.20.2013

%% Load LaS_Data2.txt
fpath=fullfile(cd,'data');
disp('Loading data')
fname='Exp2'; % Control data
datafile=fopen(fullfile(fpath,strcat(fname,'.txt')));
data =textscan(datafile,'%s %s %s %f %f %f %f %f %f %s %f %f', 'delimiter',';');
fclose all;
taskid=data{12};

% Select experiment iteration
idcheck=taskid==2;

id=data{1}(idcheck);
count=data{4}(idcheck);
phase=data{5}(idcheck);
phase=phase+1;
xsel=data{6}(idcheck);
ysel=data{7}(idcheck);
xtarg=data{8}(idcheck);
ytarg=data{9}(idcheck);
item=data{10}(idcheck);
time=data{11}(idcheck);


unqId=unique(id)';

numItem=10;

%% Figure out what subjects to remove

finished={'A3O6GCNEATUK5F', 'AJEYVMEV87SGN', 'AZF5L5E93FGW0','A1UGH8VVR9JVDL','A3KM47JBFMVT44', ...
    'AX5RAD2CUCUO', 'A1EWHJ42DLEL37', 'A1ZYLIR7S6CXIG', 'A11GOHU8PEXH8L', 'A1TUAUKJ1TPC0F', ...
    'AYCDG1YL7AOSH', 'AWCY6XQ44V737', 'A31OYNEHAO9GBB', 'A2NAABOSB0CQT5','A112V6HAH568DI', ...
    'A6VBANZ5SVIDR', 'A2JEM59HAWM4GX','A2KDCANVN4H2EK','A2GGFBEGFXJFRS','A1Z59EB58SFXPY', ...
    'AAKFUMPLS0U6N', 'AKVZOTBIXGTDM', 'A30YUELTPFSF0T', 'A3HIIRTGJUJZ1D', 'A18LDNUM52AGF0', ...
    'AJOPAQ6KA4DAO', 'A3QNLXR85VWHHH','A19ITIBU81J9D3','A3JKHBY3ZZQJOU', 'A2VWI03315IY52', ...
    'A2VL0FJOC4NJIF', 'A1FIAWWO7WD01P', 'ALE46PXQQQONK','AG2O0W3GV3ZGF', 'A2RFWIPVXZ5ON1', ...
    'A1HW5ZF77SOBDS', 'A3485IQYNO94GA', 'A1QBF6HGY4SF6U', 'A3C8KN9HKGGZKG', 'A3JTJKRDRABFMW'};

unfinished=setdiff(unqId,finished);

% Subjects to remove due to technical errors
removeSub={unfinished{:} 'A1J59G9RJUISM9'};

for i = removeSub
    indRem=strcmp(id,i{1});
    id(indRem)=[];
    count(indRem)=[];
    xsel(indRem)=[];
    ysel(indRem)=[];
    xtarg(indRem)=[];
    ytarg(indRem)=[];
    item(indRem)=[];
    time(indRem)=[];
    phase(indRem)=[];
end


%% Organize data by into struct array by subject
allData=nan(length(finished),max(phase));
allStru=cell(length(finished),max(phase));
for i = 1:length(finished)
    sub=finished{i};
    numPhase=max(phase(strcmp(id,sub)));
    for j=1:numPhase
        numInd=logical(strcmp(id,sub).*(phase==j));
        inds=find(numInd);
        dists=mean(sqrt(((xsel(numInd)-xtarg(numInd)).^2)+((ysel(numInd)-ytarg(numInd)).^2)));
        allData(i,j)=dists;
        
        % Set up struc array
        items=[];
        for k=1:10
            trial=struct('xs',xsel(inds(k)),'ys',ysel(inds(k)),'xt',xtarg(inds(k)),'yt',ytarg(inds(k)),'item',item(inds(k)),'time',time(inds(k)));
            items=[items trial];
        end
        allStru{i,j}=items;
    end
end