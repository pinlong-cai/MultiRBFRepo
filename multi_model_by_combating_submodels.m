times = 1;RRet=[];
while(times < 10)
	times = times + 1;	
	data_generate;%generat data for models
	ols_rbf_gf;
	ols_rbf_htf;
	content = xlsread('C:\Users\lenovo\Desktop\result.xlsx');
	A1 = content(:,1:4);
	A2 = content(:,5:8);
	B = content(:,9:10);
	C = content(:,11:12);		
	X= [ones(num,1),B(:,1),C(:,1)];
	T = inv(X'*X)*X'*A1(:,4);
	Y =[ones(num,1),B(:,2),C(:,2)]*T;
	M1=mean(((A2(:,4)-B(:,2)).^2));
	M2=mean(((A2(:,4)-C(:,2)).^2));
	M3=mean(((A2(:,4)-Y).^2));
	RRet = [RRet;[M1,M2,M3]];
end