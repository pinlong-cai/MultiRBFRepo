while(1)
%% 1  生存样本数据
num =500;
X1 = zeros(num,3);X2=zeros(num,3);
Y1 = zeros(num,1);Y2 =zeros(num,1);
e1 =0; e2 = 0; e3 = 0; e4 =0;
for i = 1:num
    e1 = normrnd(0,0.5);
    e2 = normrnd(0,0.5);
    e3 = normrnd(0,0.5);
    e4 = normrnd(0,0.5);
    x = rand*2-1;
    X1(i,1) = x^3+x+e1;
    X1(i,2) = sin(x)^3+cos(x)+e2;
    X1(i,3) = exp(x)-1+e3;
    Y1(i)= X1(i,1)^3+X1(i,2)^2+X1(i,3)+e4;
end
% plot(X1(:,1));hold on
% plot(X1(:,2));hold on
% plot(X1(:,3));hold on
% plot(Y1(:,:)); 

for i = 1:num
    e1 = normrnd(0,0.5);
    e2 = normrnd(0,0.5);
    e3 = normrnd(0,0.5);
    e4 = normrnd(0,0.5);
    x = rand*2-1;
    X2(i,1) = x^3+x+e1;
    X2(i,2) = sin(x)^3+cos(x)+e2;
    X2(i,3) = exp(x)-1+e3;
    Y2(i)=X2(i,1)^3+X2(i,2)^2+X2(i,3);
end
save test
%% 2 加载数据
%load data
 tic
%% 3 参数初始化
ret=[];Size=[];
lamda =0.01;
num_in = length(X1(1,:));
num = length(X1(:,1));
Y1_d = Y1;
h=num;
c = zeros(h,num_in);
[s ind] = sort(rand(num,1));
c = X1;
dmax = 0; 
for i = 1:h
        d = sqrt(max(sum((ones(num,1)*c(i,:)-c).^2,2)));
        if dmax < d
            dmax = d;
        end
end
T=[];
%%
alpha = 1;
sigma = dmax/(alpha);
P =zeros(num,num);
for i = 1:num
    P(i,:)= exp((-1/(sigma)^2).*(sum((ones(num,1)*X1(i,:)-c).^2,2)));
end
G=[];A=1;cnt =1;W=[];sum_err_max=0;MSE=1;ERR=0;cter = [];afa=0;Sel=0;L=0;
J=  1/num*Y1_d'*Y1_d;
while(1)
    t1=clock;
    err_max=0;
    for i = 1:num
        if ismember(i,Sel)
            continue;
        end
        A(cnt,cnt)=1;          
            w = P(:,i);  
            a=ones(cnt,1);
            for j = 1: cnt-1
                afa = W(:,j)'*P(:,i)/(W(:,j)'*W(:,j));
                w = w - afa*W(:,j);  
                a(j,1) = afa;
            end
            g = w'* Y1_d/(w'*w);
            err = (w'*w)*(g^2)/(Y1_d'*Y1_d);     
        if  err > err_max;
            err_max = err;
            Sel(cnt) = i;
            G(cnt,1) = g;
            wp=w;
            cter(cnt,:) =c(i,:);
            A(:,cnt) =a;
        end
    end
    if length(Sel) == L
        break;        
    end
    L=length(Sel);
    W = [W,wp];
    ERR = ERR + err_max
    cnt = cnt +1;
    seta=pinv(A)*G;
    t2=clock;
 
    T=[T;etime(t2,t1)];
    if   1-ERR<0.01  || err_max<0.0001
        if cnt>1
        break;   
        end
    end
end
YX=W*G;
mse = mean(sqrt((W*G-Y1).^2));


num2 = length(X2(:,1));
P2 = zeros(num2,cnt-1);
for i = 1:num2
    for j =1:cnt-1
        P2(i,j)= exp((-1/(sigma)^2)*(sum((X2(i,:)-cter(j,:)).^2,2)));
    end
end

YY=P2*seta;
MSE = mean(sqrt((YY-Y2).^2));
display(['测试均方误差为：',num2str(MSE)]);
display(['模型平均大小为：',num2str(L)]);
toc
xlswrite('C:\Users\lenovo\Desktop\book1.xlsx',[X1,Y1],'Sheet1');
xlswrite('C:\Users\lenovo\Desktop\book1.xlsx',[X2,Y2],'Sheet2');
xlswrite('C:\Users\lenovo\Desktop\book1.xlsx',[YX,YY],'Sheet3');
if num_in == 1
plot(X2,Y2,'-');hold on 
plot(X2,YY,'-');
else
        bar(1:num2,Y2-YY,'b');hold on 
%     axis([1 500 -10 10]) 
  %  plot(Y2-YY,'*');hold on 
  %  plot(YY,'o');
%     legend('data line','OLS-RBF')
end
 title('Gaussian Function');
 ylabel(' ');
end