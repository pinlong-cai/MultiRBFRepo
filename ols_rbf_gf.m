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
P =zeros(num1,num1);%initalize regression matrix
for i = 1:num1
    P(i,:)= exp((-1/(sigma)^2).*(sum((ones(num1,1)*X1(i,:)-c).^2,2)));
end
G=[];A=1;cnt =1;W=[];sum_err_max=0;ERR=0;cter = [];afa=0;Sel=0;L=0;T=[];
thoval = 0.5/var(Y1);%The threshold value of error reduce ratio

%% 3 training process
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

%% 4 testing model
P2 = zeros(num2,cnt-1);
for i = 1:num2
    for j =1:cnt-1
        P2(i,j)= exp((-1/(sigma)^2)*(sum((X2(i,:)-cter(j,:)).^2,2)));
    end
end
YY=P2*seta;
RMSE = mean(sqrt((YY-Y2).^2));
display(['RMSE: ',num2str(RMSE)]);%The root mean square error of test
display(['model size:',num2str(L)]);
toc

%% 5 saving results and drawing figure
range1 = ['A1:A',num2str(num1),':D1:D',num2str(num2)];
xlswrite('C:\Users\lenovo\Desktop\result.xlsx',[X1,Y1],'Sheet1',range1);%data for training input and output
range2 = ['E1:E',num2str(num1),':H1:H',num2str(num2)];
xlswrite('C:\Users\lenovo\Desktop\result.xlsx',[X2,Y2],'Sheet1',range2);%data for testing input and output
range3 = ['I1:I',num2str(num1),':J1:J',num2str(num2)];
xlswrite('C:\Users\lenovo\Desktop\result.xlsx',[YX,YY],'Sheet1',range3);%output of training and testing

% if num_in == 1
%     plot(X2,Y2,'-');hold on 
%     plot(X2,YY,'-');
% else
%    bar(1:num2,Y2-YY,'b');hold on 
%    axis([0 500 -10 10])
% end
% title('RBF with Gaussian Function');
% ylabel('RMSE');