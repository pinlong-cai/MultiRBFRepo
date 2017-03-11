
e = 0;
for e = 0.1:0.1:1
    figure(round(e*10))
    ccnt = 0;        
    while(ccnt <8)
        ccnt = ccnt +1;        
        data_generate;
        ols_rbf_htf;
        subplot(2,4,ccnt);
        bar(1:num2,Y2-YY,'b');
        set(gcf,'Position',[100,100,1200,500]);
        axis([0 500 -10 10]);
        path = 'C:\Users\lenovo\Desktop\fig\';
%         folder = [path, 'e = ', num2str(e) ];
%         if exist(folder) == 0
%             mkdir(folder)
%         end        
        picname = [path, '\e = ', num2str(e),'.jpg'];
        print(round(e*10),'-djpeg',picname)
    end
end