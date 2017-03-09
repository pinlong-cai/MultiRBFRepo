%clc
%clear

%% 1 加载数据
load data

tic
%% 2 参数初始化
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
alpha = 1;
sigma = dmax/(alpha);
Q=rand(num,3);
P=tanh(X1*Q');
G=[];A=1;cnt =1;W=[];sum_err_max=0;MSE=1;ERR=0;cter = [];afa=0;Sel=0;L=0;T=[];
thoval = 0.5/var(Y1);%误差压缩率err阈值 

% 3 模型训练
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
            cter(cnt,:) = Q(i,:);%c(i,:);
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
    if   1-ERR< thoval || err_max<0.0001
        if cnt>1
        break;   
        end
    end
end
YX=W*G;
mse = mean(abs((W*G-Y1_d)));

%% 4 模型测试
P2=tanh(X2*cter');
YY=P2*seta;
RMSE = mean(sqrt((YY-Y2).^2));
display(['测试均方根误差为：',num2str(RMSE)]);
display(['模型平均大小为：',num2str(L)]);
toc

%% 5 结果输出，绘制偏差图
range4 = ['G1:G',num2str(num1),':H1:H',num2str(num2)];
xlswrite('C:\Users\lenovo\Desktop\result.xlsx',[YX,YY],'Sheet1',range4);%训练和测试输出
if num_in == 1
    plot(X2,Y2,'-');hold on 
    plot(X2,YY,'-');
else
   bar(1:num2,Y2-YY,'b');hold on 
end
title('RBF with Hyperbolic Tangent Function');
ylabel('RMSE');