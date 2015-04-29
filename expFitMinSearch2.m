function llk2=expFitMinSearch2(x,data)

sA=x(1);
sB=x(2);
n0=sB+(sA-sB); % Scaling
expslope=x(3); % Exponential slope
gmeanA=x(4); 
gmeanB=x(5);
gmeanC=x(6);
gstdA=x(7);
gstdB=x(8);
gstdC=x(9);
noise=x(10);

priors=normpdf(sA,gmeanA,gstdA)*normpdf(sB,gmeanB,gstdB)*normpdf(expslope,gmeanC,gstdC);

pred=sB+(sA-sB)*exp(-(0:(length(data)-1))/expslope);
llk=normpdf(pred,data,noise);
llk2=priors*prod(llk);

end