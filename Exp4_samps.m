function [targ, miss, r_err, curr_dist,curr_randDist]=Exp4_samps(llk_curr,xr,xt)
% Given llk, sample whether targ, miss or rand, and also how far from targ
numObj=size(llk_curr,1);
numPos=size(llk_curr,2);
% Sample from llk
llk_norm=llk_curr./repmat(sum(llk_curr,2),1,numObj+1);
randNum=rand(numObj,1);
randsel=sum(cumsum(llk_norm,2)<repmat(randNum,1,numObj+1),2)+1;

isTrial=~isnan(sum(llk_norm,2));

targ=randsel==[1:numObj]' & isTrial;
miss=~(randsel==[1:numObj]') & ~(randsel==numPos) & isTrial;
r_err=randsel==numPos & isTrial;

% And calculate distances
isLoc=targ | miss;
distx=xr(isLoc)-xt(randsel(isLoc));
curr_dist=[distx'];

% And calculate rand distances
randDistx=xr(r_err)-3.6;
curr_randDist=[randDistx'];

end