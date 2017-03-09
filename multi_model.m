times = 1:
while(time > 10):
	times = times + 1;	
	data-genneate;%生成数据
	ols-rbf-gf;
	ols-rbf-htf;
	content = xlsread('C:\Users\lenovo\Desktop\result.xlsx');
	A1 = content(:,1:2);
	A2 = content(:,3:4);
	B = content(:,5:6);
	C = content(:,7:8);		
	X= [ones(num,1),B(:,1),C(:,1)];
	T = inv(X'*X)*X'*A1(:,4);
	Y =[ones(num,1),B(:,2),C(:,2)]*T;
	M1=mean(((A2(:,4)-B(:,2)).^2));
	M2=mean(((A2(:,4)-C(:,2)).^2));
	M3=mean(((A2(:,4)-Y).^2));
	RRet = [RRet;[M1,M2,M3]];
end