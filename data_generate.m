% clc
% clear
%% 1  data generation
num1 =500;%amount of train data
X1 = zeros(num1,3);X2=zeros(num1,3);
Y1 = zeros(num1,1);Y2 =zeros(num1,1);
e = 0.1 ;% variance of noise
for i = 1:num1
    e1 = normrnd(0,e);
    e2 = normrnd(0,e);
    e3 = normrnd(0,e);
    e4 = normrnd(0,e);
    x = rand*2-1;
    X1(i,1) = x^3+x+e1;
    X1(i,2) = sin(x)^3+cos(x)+e2;
    X1(i,3) = exp(x)-1+e3;
    Y1(i)= X1(i,1)^3+X1(i,2)^2+X1(i,3)+e4;
end
num2 =500;%amount of test data
for i = 1:num2
    e1 = normrnd(0,e);
    e2 = normrnd(0,e);
    e3 = normrnd(0,e);
    e4 = normrnd(0,e);
    x = rand*2-1;
    X2(i,1) = x^3+x+e1;
    X2(i,2) = sin(x)^3+cos(x)+e2;
    X2(i,3) = exp(x)-1+e3;
    Y2(i)=X2(i,1)^3+X2(i,2)^2+X2(i,3);
end
save data
