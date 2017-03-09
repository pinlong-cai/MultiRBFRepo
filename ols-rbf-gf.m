clc
clear

%% 1 加载数据
load data
tic

%% 2 参数初始化
ret=[];Size=[];
num_in = length(X1(1,:));
num1 = length(X1(:,1));
h = num1;%初始隐层节点数
c = X1;
dmax = 0; 
for i = 1:h
    d = sqrt(max(sum((ones(num1,1)*c(i,:)-c).^2,2)));
    if dmax < d
        dmax = d;% 节点间最大距离
    end
end
alpha = 1;
sigma = dmax/(alpha);%高斯函数宽度系数
P =zeros(num1,num1);%初始化回归矩阵
for i = 1:num1
    P(i,:)= exp((-1/(sigma)^2).*(sum((ones(num1,1)*X1(i,:)-c).^2,2)));
end
G=[];A=1;cnt =1;W=[];sum_err_max=0;ERR=0;cter = [];afa=0;Sel=0;L=0;T=[];
thoval = 0.5/var(Y1);%误差压缩率err阈值 

%% 3 模型训练
while(1)
    t1=clock;
    err_max=0;
    for i = 1:num1
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
            g = w'* Y1/(w'*w);
            err = (w'*w)*(g^2)/(Y1'*Y1);     
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
    if   1-ERR< thoval || err_max<0.0001
        if cnt>1
        break;   
        end
    end
end
YX=W*G;
mse = mean(sqrt((W*G-Y1).^2));

%% 4 模型测试
P2 = zeros(num2,cnt-1);
for i = 1:num2
    for j =1:cnt-1
        P2(i,j)= exp((-1/(sigma)^2)*(sum((X2(i,:)-cter(j,:)).^2,2)));
    end
end
YY=P2*seta;
MSE = mean(sqrt((YY-Y2).^2));
display(['测试均方根误差为：',num2str(MSE)]);
display(['模型平均大小为：',num2str(L)]);
toc

%% 5 结果输出，绘制偏差图
range1 = ['A1:A',num2str(num1),':B1:B',num2str(num2)];
xlswrite('C:\Users\lenovo\Desktop\result.xlsx',[X1,Y1],'Sheet1',range1);%训练数据：输入和输出
range2 = ['C1:C',num2str(num1),':D1:D',num2str(num2)];
xlswrite('C:\Users\lenovo\Desktop\result.xlsx',[X2,Y2],'Sheet1',range2);%测试数据：输入和输出
range3 = ['E1:E',num2str(num1),':F1:F',num2str(num2)];
xlswrite('C:\Users\lenovo\Desktop\result.xlsx',[YX,YY],'Sheet1',range3);%训练和测试输出
if num_in == 1
    plot(X2,Y2,'-');hold on 
    plot(X2,YY,'-');
else
   bar(1:num2,Y2-YY,'b');hold on 
end
title('RBF with Gaussian Function');
ylabel('RMSE');