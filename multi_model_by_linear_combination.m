%clc
%clear 

%% 1 load data
load data
tic

%% 2 initalize parameters 
ret=[];Size=[];
num_in = length(X1(1,:));
num1 = length(X1(:,1));
h = num1;%number of nodes in hidelayer
c = X1;
dmax = 0; 
for i = 1:h
    d = sqrt(max(sum((ones(num1,1)*c(i,:)-c).^2,2)));
    if dmax < d
        dmax = d;% maximum distance between nodes
    end
end
alpha = 1;
sigma = dmax/(alpha);% width coefficient in Gussian function
Pg =zeros(num1,num1);%initalize regression matrix
for i = 1:num1
    Pg(i,:)= exp((-1/(sigma)^2).*(sum((ones(num1,1)*X1(i,:)-c).^2,2)));
end
Q=rand(num1,3);
Pht=tanh(X1*Q');
P=[Pg,Pht];
num1 = 2*num1;
c = [c;c];
G=[];A=1;cnt =1;W=[];sum_err_max=0;ERR=0;cter = [];afa=0;Sel=0;L=0;T=[];
thoval = 0.5/var(Y1);%The threshold value of error reduce ratio

%% 3 training process
while(1)
    t1=clock;
    err_max=0;
    for i = num1/2:num1
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
            Sel(cnt,1) = i;
            G(cnt,1) = g;
            wp=w;
            if i <= 500
                cter(cnt,:) =c(i,:);
            else
                cter(cnt,:) =Q(i-500,:);
            end
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

%% 4 testing model
P2 = zeros(num2,cnt-1);
for j =1:cnt-1
    if Sel(j)<=500
        for i = 1:num2
            P2(i,j) = exp((-1/(sigma)^2)*(sum((X2(i,:)-cter(j,:)).^2,2)));
        end
    else
        P2(:,j) = tanh(X2*cter(j,:)');
    end
end

YY=P2*seta;
RMSE = mean(sqrt((YY-Y2).^2));
display(['RMSE: ',num2str(RMSE)]);%The root mean square error of test
display(['model size:',num2str(L)]);
toc

%% 5 saving results and drawing figure

