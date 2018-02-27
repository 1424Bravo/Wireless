T1 = readtable('connects.csv');
T2 = readtable('disconnects.csv');
T3 = readtable('numclients.csv');
A1 = table2array(T1);
A2 = table2array(T2);
A3 = table2array(T3);

figure
hold on
yyaxis right;
stem(A1(:,1),A1(:,2), 'filled', 'green');
stem(A2(:,1),A2(:,2), 'filled');
yyaxis left;
plot(A3(:,1),A3(:,2))
hold off
xlabel('time (s)')
ylabel('(dis)connects')
title('The number of (dis)connects of the network per second and total number of clients')
xlim([min(min(A1(:,1)),min(A2(:,1))) max(max(A1(:,1)),max(A2(:,1)))])
legend(['Number of connected clients', T1.Properties.VariableNames(2),T2.Properties.VariableNames(2) ])

print('connects_disconnects_time','-dpng')

%%%%% Now do the vendor part:
%clear all;
%close all;
figure
formatSpec = '%C%f';
T = readtable('vendor.csv','Delimiter',',','Format',formatSpec);
labels = table2array(T(:,1));
vals = table2array(T(:,2));
pie(vals)
legend(cellstr(labels),'Position',[0.35 0.3 1.0 1.0])
title('Percentage of MAC addresses from vendor')
print('vendor','-dpng')




