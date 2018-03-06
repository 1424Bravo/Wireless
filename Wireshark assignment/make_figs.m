clear all;
close all;
T1 = readtable('connects.csv');
T2 = readtable('disconnects.csv');
T3 = readtable('numclients.csv');
A1 = table2array(T1);
A2 = table2array(T2);
A3 = table2array(T3);
fontsize_title = 25;
fontsize_axis = 20;
fontsize_axisbar = 14;
figure
set(gcf,'units','points','position',[0,0,900,600])
hold on
yyaxis left;
ylabel('# of (dis)connects','fontsize',fontsize_axis)
stem(A1(:,1),A1(:,2), 'filled', 'green');
stem(A2(:,1),A2(:,2), 'filled');
yyaxis right;
plot(A3(:,1),A3(:,2))
hold off
xlabel('time (s)','fontsize',fontsize_axis)
ylabel('# of connected clients','fontsize',fontsize_axis)
title({'The number of (dis)connects per second';'and total number of clients'},'fontsize',fontsize_title )
xlim([min(min(A1(:,1)),min(A2(:,1))) max(max(A1(:,1)),max(A2(:,1)))])
legend([T1.Properties.VariableNames(2),T2.Properties.VariableNames(2), 'Number of connected clients'])

print('connects_disconnects_time','-dpng')

%%%%% Now do the vendor part:
%clear all;
%close all;
formatSpec = '%C%f%f';
T = readtable('vendor.csv','Delimiter',',','Format',formatSpec);
labels = table2array(T(:,1));
vals = table2array(T(:,2));
n_time = table2array(T(:,3));
name = cellstr(labels);


figure
set(gcf,'units','points','position',[0,0,900,600])
bar(vals)
set(gca,'xticklabel',name,'fontsize',fontsize_axisbar)
ylabel('# of distinctive addresses','fontsize',fontsize_axis)
title('Number of MAC addresses from vendor','fontsize',fontsize_title )
print('vendor','-dpng')

figure
set(gcf,'units','points','position',[0,0,900,600])
bar(n_time)
set(gca,'xticklabel',name,'fontsize',fontsize_axisbar)
ylabel('time(s)','fontsize',fontsize_axis)
title('Average time on network per vendor','fontsize',fontsize_title)
print('timeonnetwork','-dpng')

