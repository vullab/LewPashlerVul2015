function [E3_RespTrainCued, E3_TargTrainCued,E3_sdRandTrainCued, ...
    E3_RespTrainFree, E3_TargTrainFree,E3_sdRandTrainFree, ...
    E3_RespTest, E3_TargTest,E3_sdRandTest]=loadE3(center)
%% Load data from Experiment 3 - Cued & Free recall hybrid task
% 4.16.2015-Created

%% Load data
fpath=fullfile(cd,'data');
disp('Loading data')
fname='Exp3';
datafile=fopen(fullfile(fpath,strcat(fname,'.txt')));
data =textscan(datafile,'%f %s %f %f %f %f %f %f %s %s %s', 'delimiter',';');

items=data{9};
phase=data{10};

subjs=(data{1});
count=(data{3})';
block=(data{4})';
xsel=(data{5})';
ysel=(data{6})';

xtarg=(data{7})';
ytarg=(data{8})';

allPhase=unique(phase);

%% Subjects who completed the study
% Completed session 1
S1_completed=[15736 16519 16705 15601 16470 13865 15284 14310 16465 16462 ...
    15549 15968 12779 14924 16413 16467 14723 16562 16340 15894 16565 16407 ...
    5312 14502 3836 7262 8850 14091 16063 15320 16602 16486 7220 4637 16335 ...
    16613 7930 16500 2482 170 13150 16571 16588 11265 16621 16622 16645 16648 ...
    16633 16647 16081 5353 16660 16664 16661 16627 16657 16671 16658 16669 16637 ...
    16703 16699 16700 16651 16719 16722 16731 16760 16782 16787 16752 16797 ...
    16800 16813 16833];

% Completed full experiment
Full_completed=[15736,16519,16465,14502,16063,4637,16613,170,13150,16571,16588, ...
    16633,16660,16661, 5353,16627,16657,16671,16658,16669,16637,16703, ...
    16722,16719,16719,16731];

% 16651-Used notepad
% 5353-Recalled objects on the free recall but not on the cued recall
reject=[ 16651,5353 ...
    ];

S1_completed=setdiff(S1_completed,reject);
Full_completed=setdiff(Full_completed,reject);

%% Organize data


%% For learning cued recall
E3_RespTrainCued=nan(length(S1_completed),23,10,2);
E3_TargTrainCued=nan(length(S1_completed),23,10,2);

phSub=strcmp(phase,'p1'); % For session 1
for sub=1:length(S1_completed)
    selSub=(subjs==S1_completed(sub));
    for bi=0:max(block)
        biSub=block==bi;
        selBlock=find(selSub.*biSub'.*phSub);
        if ~isempty(selBlock)
            E3_RespTrainCued(sub,bi+1,:,1)=xsel(selBlock);
            E3_RespTrainCued(sub,bi+1,:,2)=ysel(selBlock);
            E3_TargTrainCued(sub,bi+1,:,1)=xtarg(selBlock);
            E3_TargTrainCued(sub,bi+1,:,2)=ytarg(selBlock);
        end
    end
end

E3_sdRandTrainCued=nan(1,23);
for is=1:23
    tempX=E3_RespTrainCued(:,is,:,1)-center(1);
    tempY=E3_RespTrainCued(:,is,:,2)-center(2);
    E3_sdRandTrainCued=nanstd([tempX(:);tempY(:)]);
end

%% For learning free recall

numLocBlock=length(unique(block(strcmp(phase,'p2'))));
E3_RespTrainFree=nan(length(S1_completed),numLocBlock,10,2);
E3_TargTrainFree=nan(length(S1_completed),numLocBlock,10,2);

for sub=1:length(S1_completed)
    selSub=(subjs==S1_completed(sub));
    count=numLocBlock-2;
    for ph=2;
        for bi=unique(block(strcmp(phase,allPhase{ph})))
            biSub=block==bi;
            
            sel=find(selSub.*biSub'.*strcmp(phase,allPhase{ph}));
            if isempty(sel)
                continue
            elseif mod(length(sel),10)==0 % Some people's data got sent to the server multiple times...
                sel=sel(1:10);
            end
            xselCurr=xsel(sel);
            yselCurr=ysel(sel);
            xtargCurr=xtarg(sel);
            ytargCurr=ytarg(sel);
            
            if ph==2 && bi~=max(block(logical(strcmp(phase,allPhase{ph}).*selSub)))
                E3_RespTrainFree(sub,ceil(bi/2),:,1)=xselCurr;
                E3_RespTrainFree(sub,ceil(bi/2),:,2)=yselCurr;
                E3_TargTrainFree(sub,ceil(bi/2),:,1)=xtargCurr;
                E3_TargTrainFree(sub,ceil(bi/2),:,2)=ytargCurr;
            else

            end
        end
    end
end

E3_sdRandTrainFree=nan(1,numLocBlock);
for is=1:numLocBlock
    tempX=E3_RespTrainFree(:,is,:,1)-center(1);
    tempY=E3_RespTrainFree(:,is,:,2)-center(2);
    E3_sdRandTrainFree(is)=nanstd([tempX(:);tempY(:)]);
end

% Cut out blanks
unused=isnan(E3_sdRandTrainFree);
E3_RespTrainFree(:,unused,:,:)=[];
E3_TargTrainFree(:,unused,:,:)=[];
E3_sdRandTrainFree(unused)=[];

%% For testing
E3_RespTest=nan(length(Full_completed),3,10,2);
E3_TargTest=nan(length(Full_completed),3,10,2);

numLocBlock=length(unique(block(strcmp(phase,'p2'))))+2;

for sub=1:length(Full_completed)
    selSub=(subjs==Full_completed(sub));
    count=1;%numLocBlock-2;
    for ph=2:length(allPhase);
        for bi=unique(block(strcmp(phase,allPhase{ph})))
            biSub=block==bi;
            
            sel=find(selSub.*biSub'.*strcmp(phase,allPhase{ph}));
            if isempty(sel)
                continue
            elseif mod(length(sel),10)==0 % Some people's data got sent to the server multiple times...
                sel=sel(1:10);
            end
            xselCurr=xsel(sel);
            yselCurr=ysel(sel);
            xtargCurr=xtarg(sel);
            ytargCurr=ytarg(sel);
            
            if ph==2 && bi~=max(block(logical(strcmp(phase,allPhase{ph}).*selSub)))

            else
                E3_RespTest(sub,count,:,1)=xselCurr;
                E3_RespTest(sub,count,:,2)=yselCurr;
                E3_TargTest(sub,count,:,1)=xtargCurr;
                E3_TargTest(sub,count,:,2)=ytargCurr;
                count=count+1;
            end
        end
    end
end

E3_sdRandTest=nan(1,numLocBlock);
for is=1:size(E3_RespTest,2)
    tempX=E3_RespTest(:,is,:,1)-center(1);
    tempY=E3_RespTest(:,is,:,2)-center(2);
    E3_sdRandTest(is)=nanstd([tempX(:);tempY(:)]);
end

end