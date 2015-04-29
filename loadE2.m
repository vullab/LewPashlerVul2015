function allData=loadE2()
%% Load data from LaS1-Long-term memory experiment 0-1-7 delay

center=[500 475];
fpath=fullfile(cd,'data');

disp('Loading data')
fname='Exp1';
datafile=fopen(fullfile(fpath,strcat(fname,'.txt')));
data =textscan(datafile,'%f %f %f %f %f %f %f %s %f %f %f', 'delimiter',';');
fclose all;

taskid=data{2};

idcheck=taskid==2;
id=data{1}(idcheck);
count=data{3}(idcheck);
xsel=data{4}(idcheck);
ysel=data{5}(idcheck);
xtarg=data{6}(idcheck);
ytarg=data{7}(idcheck);
item=data{8}(idcheck);
sesNum=data{9}(idcheck);
time=data{10}(idcheck);
phase=data{11}(idcheck);
unqId=unique(id)';

numItem=10;
numCatch=2;
numAll=numItem+numCatch;
%% Figure out which subjects to remove

% Subjects to remove due to self-reported cheating
removeSub=[11952 10129 13912];

% Subjects to remove who didn't finish
for i = unqId
    if sum((id==i).*(sesNum==3))~=numAll
        removeSub=[removeSub i];
    end
end

subjs=setdiff(unique(unqId),removeSub);

%% Process data into blocks
% Note this code is ugly.
allData=cell(1,length(subjs));
count=1;
big_s1p1=1; % Figure out the longest s1p1
catchNum=nan(length(subjs),8);
for i = subjs
    
    s1p1=[];
    s1p2=[];
    s1p3=[];
    s2p1=[];
    s3p1=[];
    
    storeItems=[];
    
    inds=id==i;
    inds=find(inds)';
    
    listitems=unique(item(inds));
    listitems=listitems(2:end);
    
    for j=listitems'
        ind=find(strcmp(j,item(inds)));
        ind=inds(ind(1));
        itm=struct('xt',xtarg(ind),'yt',ytarg(ind),'item',item(ind),'time',time(ind));
        storeItems=[storeItems itm];
    end
    
    allItems{count}=storeItems;
    
    for j=inds
        trial=struct('xs',xsel(j),'ys',ysel(j),'xt',xtarg(j),'yt',ytarg(j),'item',item(j),'time',time(j),'rs',nan);
        if sesNum(j)==1
            if phase(j)==1
                s1p1=[s1p1 trial];
                if length(s1p1)>big_s1p1
                    big_s1p1=length(s1p1);
                end
            elseif phase(j)==2
                s1p2=[s1p2 trial];
            elseif phase(j)==3
                s1p3=[s1p3 trial];
            end
        elseif sesNum(j)==2
            s2p1=[s2p1 trial];
        elseif sesNum(j)==3
            s3p1=[s3p1 trial];
        end
    end
    wordcount=1;
    for j =  {s1p3.item}
        
        if 1==sum(strcmp({s1p1.item},j))
            catchNum(subjs==i,wordcount)=find(strcmp({s1p1.item},j));
            catchNum(subjs==i,wordcount+2)=find(strcmp({s1p3.item},j));
            catchNum(subjs==i,wordcount+4)=find(strcmp({s2p1.item},j));
            catchNum(subjs==i,wordcount+6)=find(strcmp({s3p1.item},j));
            wordcount=wordcount+1;
        end
        
    end
    s1p3(catchNum(find(subjs==i),3:4))=[];
    s2p1(catchNum(subjs==i,5:6))=[];
    s3p1(catchNum(subjs==i,7:8))=[];
    allData{count}={s1p1,s1p2,s1p3,s2p1,s3p1};
    count=count+1;
end