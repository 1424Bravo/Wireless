clear all;
close all;
T1 = readtable('connects.csv');
T2 = readtable('disconnects.csv');
T3 = readtable('numclients.csv');
A1 = table2array(T1);
A2 = table2array(T2);
A3 = table2array(T3);

figure
set(gcf,'units','points','position',[0,0,900,600])
hold on
yyaxis left;
ylabel('# of (dis)connects')
stem(A1(:,1),A1(:,2), 'filled', 'green');
stem(A2(:,1),A2(:,2), 'filled');
yyaxis right;
plot(A3(:,1),A3(:,2))
hold off
xlabel('time (s)')
ylabel('# of connected clients')
title('The number of (dis)connects of the network per second and total number of clients')
xlim([min(min(A1(:,1)),min(A2(:,1))) max(max(A1(:,1)),max(A2(:,1)))])
legend([T1.Properties.VariableNames(2),T2.Properties.VariableNames(2), 'Number of connected clients'])

print('connects_disconnects_time','-dpng')

%%%%% Now do the vendor part:
%clear all;
%close all;
figure
set(gcf,'units','points','position',[0,0,900,600])

formatSpec = '%C%f%f';
T = readtable('vendor.csv','Delimiter',',','Format',formatSpec);
labels = table2array(T(:,1));
vals = table2array(T(:,2));
n_time = table2array(T(:,3));
name = cellstr(labels);

bar(vals)
set(gca,'xticklabel',name)
ylabel('# of distinctive addresses')
title('Number of MAC addresses from vendor')
print('vendor','-dpng')

figure
set(gcf,'units','points','position',[0,0,900,600])
bar(n_time)
title('Average time on network per vendor')
ylabel('time(s)')
set(gca,'xticklabel',name)
print('timeonnetwork','-dpng')

